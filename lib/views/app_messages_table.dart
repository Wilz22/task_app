import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/main.dart';
import 'package:taskapp/widgets/message_input_table.dart';
import '/models/icons_data.dart';
import '/models/msg_list.dart';
import '/services/connection_services_messages.dart';
import '/themes/app_themes.dart';

class MessagesTable extends StatefulWidget {
  const MessagesTable({super.key, this.animationController});

  final AnimationController? animationController;

  @override
  State<MessagesTable> createState() => _MessagesTableState();
}

class _MessagesTableState extends State<MessagesTable>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  late AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container();

  late TextEditingController _messageController;
  late List<MsgList> _messages = [];

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _getMessages();

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
  }

  _showProgress(String message) {
    setState(() {
      if (kDebugMode) {
        print(message);
      }
    });
  }

  _addMessage() {
    if (_messageController.text.trim().isEmpty) {
      if (kDebugMode) {
        print("Empty field");
      }
      return;
    }
    _showProgress('Adding Message...');
    ConnectionServices.addMsg(_messageController.text).then((success) {
      if (success) {
        _getMessages();
      }
      _clearValues();
    });
  }

  _getMessages() {
    _showProgress('Loading Messages...');
    ConnectionServices.getAllMsgs().then((messages) {
      setState(() {
        _messages = messages;
        if (kDebugMode) {
          print('Messages: $_messages');
        } // Verifica el contenido de _messages
      });
      _showProgress('Messages Loaded');
    });
  }

  _deleteMessage(int id_mensaje) {
    _showProgress('Deleting Message...');
    ConnectionServices.deleteMsg(id_mensaje).then((success) {
      if (success) {
        setState(() {
          _messages.remove(id_mensaje);
        });
        _getMessages();
      }
    });
  }

  _editMessage(MsgList message) {
    _messageController.text = message.mensaje;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: _messageController,
            decoration: const InputDecoration(labelText: 'Message'),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _clearValues();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                _showProgress('Updating Message...');
                ConnectionServices.updateMsg(
                        message.id_mensaje, _messageController.text)
                    .then((success) {
                  if (success) {
                    _getMessages();
                  }
                  Navigator.of(context).pop();
                  _clearValues();
                });
              },
            ),
          ],
        );
      },
    );
  }

  _clearValues() {
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TaskappTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                getAppBarUI(),
                SizedBox(
                  height: MediaQuery.of(context).padding.top / 2,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Agrega padding horizontal
                    child: MessageInputTable(
                      messageController: _messageController,
                      onAddTask: _addMessage,
                      buildDataTable: _buildDataTable,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 90.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: TaskappTheme.white, // Opacidad fija
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: TaskappTheme.grey
                      .withOpacity(0.4), // Sin opacidad variable
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8.0, // Valores estáticos
                  bottom: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Mensajes',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: TaskappTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 22, // Sin dependencia de topBarOpacity
                            letterSpacing: 1.2,
                            color: TaskappTheme.darkerText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 38,
                      width: 38,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {},
                        child: const Center(
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: TaskappTheme.grey,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.calendar_today,
                              color: TaskappTheme.grey,
                              size: 18,
                            ),
                          ),
                          Text(
                            '18 Dec',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: TaskappTheme.fontName,
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              letterSpacing: -0.2,
                              color: TaskappTheme.darkerText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 38,
                      width: 38,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {},
                        child: const Center(
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: TaskappTheme.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    if (kDebugMode) {
      print('Building DataTable with msgs: $_messages');
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        // constraints: BoxConstraints(
        //   maxHeight: MediaQuery.of(context).size.height -
        //       200, // Ajusta según sea necesario
        // ),
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco para la tabla
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0), // Bordes redondeados
          child: DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return HexColor('#8db237').withOpacity(0.8);
              },
            ),
            headingTextStyle: const TextStyle(
              color: Colors.white, // Color del texto en blanco
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            columns: const [
              // DataColumn(label: Text('ID')),
              DataColumn(
                label: Center(
                  child: Text('ID', textAlign: TextAlign.center),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text('Mensaje', textAlign: TextAlign.center),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text('Actions', textAlign: TextAlign.center),
                ),
              ),
            ],
            rows: _messages.asMap().entries.map((entry) {
              int index = entry.key;
              MsgList msg = entry.value;
              return DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    // Alterna el color de fondo para las filas pares e impares
                    if (index % 2 == 0) {
                      return Colors.grey
                          .withOpacity(0.1); // Color para filas pares
                    }
                    return null; // Color para filas impares (predeterminado)
                  },
                ),
                cells: [
                  DataCell(Text(msg.id_mensaje.toString())),
                  DataCell(Text(msg.mensaje)),
                  DataCell(Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editMessage(msg);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteMessage(msg.id_mensaje);
                        },
                      ),
                    ],
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
