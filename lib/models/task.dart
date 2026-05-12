class Task {
  int? id;
  String title;
  String description;
  String dueDate;
  String category;
  int isDone;
  String createdAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.category,
    this.isDone = 0,
    required this.createdAt,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['due_date'],
      category: map['category'],
      isDone: map['is_done'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'category': category,
      'is_done': isDone,
      'created_at': createdAt,
    };
  }
}
