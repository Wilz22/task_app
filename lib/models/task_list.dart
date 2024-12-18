class Tasklist {
  int id;
  String task;
  int id_message;
  String mensaje;

  Tasklist(
      {required this.id,
      required this.task,
      required this.id_message,
      required this.mensaje});

  factory Tasklist.fromJson(Map<String, dynamic> json) {
    return Tasklist(
      id: int.parse(json['id']),
      task: json['task'] as String,
      id_message: int.parse(json['id_message']),
      mensaje: json['mensaje'] as String,
    );
  }
}
