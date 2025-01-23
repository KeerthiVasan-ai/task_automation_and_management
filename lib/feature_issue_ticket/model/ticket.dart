class Ticket {
  final String id;
  final String title;
  final String description;
  final String location;
  final String date;
  final String attachment;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.attachment,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'location': location,
    'date': date,
    'attachment': attachment,
  };

  static Ticket fromJson(Map<String, dynamic> json) => Ticket(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    location: json['location'],
    date: json['date'],
    attachment: json['attachment'],
  );
}
