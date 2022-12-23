import '../http/http.dart';
import '/../domain/entities/entities.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  RemoteSurveyModel({
    required this.id,
    required this.question,
    required this.date,
    required this.didAnswer,
  });

  factory RemoteSurveyModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(
      ['id', 'didAnswer', 'question', 'date'],
    )) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyModel(
        id: json['id'],
        didAnswer: json['didAnswer'],
        question: json['question'],
        date: json['date']);
  }

  SurveyEntity toEntity() {
    return SurveyEntity(
        didAnswer: didAnswer,
        dateTime: DateTime.parse(date),
        question: question,
        id: id);
  }
}
