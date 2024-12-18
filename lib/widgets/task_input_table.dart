import 'package:flutter/material.dart';

class TaskInputAndTable extends StatelessWidget {
  final TextEditingController taskController;
  final TextEditingController messageController;
  final VoidCallback onAddTask;
  final Widget Function() buildDataTable;

  const TaskInputAndTable({
    Key? key,
    required this.taskController,
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
            controller: taskController,
            decoration: const InputDecoration(
              labelText: 'Tarea',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                labelText: 'Random Message',
              ),
              enabled: false,
              minLines: 1,
              maxLines: null,
              // Expande para llenar el contenedor
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
              Text('Agregar'),
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
