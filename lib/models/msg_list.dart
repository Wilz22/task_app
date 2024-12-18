class MsgList {
  int id_mensaje;
  String mensaje;

  MsgList({required this.id_mensaje, required this.mensaje});

  factory MsgList.fromJson(Map<String, dynamic> json) {
    return MsgList(
      id_mensaje: int.parse(json['id_mensaje']),
      mensaje: json['mensaje'] as String,
    );
  }
}
