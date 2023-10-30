class TodoItem {
  int? id;
  String title;
  String quantity;
  double temperature;
  String location;

  TodoItem({
    this.id,
    required this.title,
    required this.quantity,
    required this.temperature,
    required this.location,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'temperature': temperature,
      'location': location,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      quantity: map['quantity'],
      temperature: map['temperature'],
      location: map['location'],
    );
  }
}
