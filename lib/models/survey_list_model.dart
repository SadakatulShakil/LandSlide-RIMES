class Survey {
  final String id;
  final String title;
  final String status;

  Survey({required this.id, required this.title, required this.status});

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'],
      title: json['title'],
      status: json['status'],
    );
  }
}
