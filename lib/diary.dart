import 'package:diary_app/database.dart';
import 'package:equatable/equatable.dart';

class Diary extends Equatable {
  int id;
  String title;
  String body;
  DateTime updatedAt;

  Diary({this.id, this.title, this.body, this.updatedAt});

  @override
  List<Object> get props => [id];

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'body': this.body,
      'updatedAt': this.updatedAt.toIso8601String(),
    };
  }

  factory Diary.fromMap(Map<String, dynamic> data) => new Diary (
    id: data["id"],
    title: data["title"],
    body: data["body"],
    updatedAt: DateTime.parse(data["updatedAt"]),
  );

}