import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/main.dart';
import 'package:taskapp/widgets/task_input_table.dart';
import '/models/task_list.dart';
import '/services/connection_services_tasks.dart';
import '/services/connection_services_messages.dart';
import '/models/icons_data.dart';
import '/themes/app_themes.dart';

class AppTasksData extends StatefulWidget {
  const AppTasksData({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  State<AppTasksData> createState() => _AppTasksDataState();
}

class _AppTasksDataState extends State<AppTasksData>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  late TextEditingController _taskController;
  late TextEditingController _messageController;
  int? _randomMessageId;
  List<Tasklist> _tasks = [];
  late AnimationController animationController;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  Widget tabBody = Container();

  @override
  void initState() {
    _taskController = TextEditingController();
    _messageController = TextEditingController();
    _getTasks();
    _getRandomMessage();
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

    super.initState();
  }

  _showProgress(String message) {
    setState(() {
      // Update progress message
      if (kDebugMode) {
        print(message);
      }
    });
  }

  _clearValues() {
    _taskController.clear();
    _messageController.clear();
  }

  _getTasks() {
    _showProgress('Loading Tasks...');
    ConnectionServicesTasks.getAllTasks().then((tasks) {
      setState(() {
        _tasks = tasks;
        if (kDebugMode) {
          print('Tasks: $_tasks');
        }
      });
      _showProgress('Tasks Loaded');
    });
  }

  _getRandomMessage() {
    ConnectionServices.getRandomMsg().then((message) {
      setState(() {
        _randomMessageId = message.id_mensaje;
        _messageController.text = message.mensaje;
        if (kDebugMode) {
          print('Random Message: $_randomMessageId - ${message.mensaje}');
        }
      });
    });
  }

  _addTask() {
    if (_taskController.text.trim().isEmpty || _randomMessageId == null) {
      if (kDebugMode) {
        print("Empty field");
      }
      return;
    }
    _showProgress('Adding Task...');
    ConnectionServicesTasks.insertTask(_taskController.text, _randomMessageId!)
        .then((success) {
      if (success) {
        _getTasks();
        _getRandomMessage();
      }
      _clearValues();
      FocusScope.of(context).unfocus();
    }).catchError((error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    });
  }

  _editTask(Tasklist task) {
    _taskController.text = task.task;
    _randomMessageId = task.id_message;
    _messageController.text =
        task.mensaje; // Assuming Tasklist has a message field

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(labelText: 'Task'),
              ),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Random Message'),
                enabled: false,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _clearValues();
                _getRandomMessage();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                _showProgress('Updating Task...');
                ConnectionServicesTasks.updateTask(
                        task.id, _taskController.text, _randomMessageId!)
                    .then((success) {
                  if (success) {
                    _getTasks();
                  }
                  Navigator.of(context).pop();
                  _clearValues();
                  _getRandomMessage();
                });
              },
            ),
          ],
        );
      },
    );
  }

  _deleteTask(int id) {
    _showProgress('Deleting Task...');
    ConnectionServicesTasks.deleteTask(id).then((success) {
      if (success) {
        _getTasks();
        _getRandomMessage();
      }
    });
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
                    child: TaskInputAndTable(
                      taskController: _taskController,
                      messageController: _messageController,
                      onAddTask: _addTask,
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
                          'Tareas',
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
      print('Building DataTable with tasks: $_tasks');
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        // constraints: BoxConstraints(
        //   maxHeight: MediaQuery.of(context).size.height -
        //       200,
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
                  child: Text('Task', textAlign: TextAlign.center),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text('Message', textAlign: TextAlign.center),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text('Actions', textAlign: TextAlign.center),
                ),
              ),
            ],
            rows: _tasks.asMap().entries.map((entry) {
              int index = entry.key;
              Tasklist task = entry.value;
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
                  // DataCell(Text(task.id.toString())),
                  DataCell(Text(task.task)),
                  DataCell(Text(task.mensaje)),
                  DataCell(Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editTask(task);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteTask(task.id);
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
