class ToDo {
  int id, status;
  String title, desc;
  ToDo({
    this.id = 0,
    this.status = 0,
    required this.title,
    required this.desc,
  });
  factory ToDo.fromMap(Map<String, dynamic> todo) {
    return ToDo(
      id: todo['id'],
      status: todo['status'],
      title: todo['title'],
      desc: todo['desc'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'title': title,
      'desc': desc,
    };
  }
}
