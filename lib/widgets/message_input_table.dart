import 'package:flutter/material.dart';

class MessageInputTable extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onAddTask;
  final Widget Function() buildDataTable;

  const MessageInputTable({
    Key? key,
    required this.messageController,
    required this.onAddTask,
    required this.buildDataTable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              labelText: 'Mensaje',
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.top / 10,
        ),
        ElevatedButton(
          onPressed: onAddTask,
          child: const Row(
            mainAxisSize:
                MainAxisSize.min, // Ajusta el tamaño del Row al contenido
            children: [
              Icon(Icons.add), // Ícono antes del texto
              SizedBox(width: 8), // Espacio entre el ícono y el texto
              Text('Agregar Msg'),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.top / 2,
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: buildDataTable(),
          ),
        ),
      ],
    );
  }
}
