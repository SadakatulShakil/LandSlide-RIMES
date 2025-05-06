class SurveyQuestion {
  final String id;
  final String group;
  final String title;
  final String type;
  final String required;
  dynamic answer;

  SurveyQuestion({
    required this.id,
    required this.group,
    required this.title,
    required this.type,
    required this.required,
    this.answer,
  });

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SurveyQuestion(
      id: json['id'],
      group: json['group'],
      title: json['title'],
      type: json['type'],
      required: json['required'],
      answer: json['answer'],
    );
  }
}
