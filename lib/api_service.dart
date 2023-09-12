import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz/quiz_question.dart';

class ApiService {
  final String apiUrl = 'https://opentdb.com/api.php?amount=10&type=multiple';

  Future<List<QuizQuestion>> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return (jsonBody['results'] as List)
            .map((questionJson) => QuizQuestion(
          question: questionJson['question'],
          options: [...questionJson['incorrect_answers'], questionJson['correct_answer']],
          correctAnswer: questionJson['correct_answer'],
        ))
            .toList();
      } else {
        throw Exception('Failed to fetch questions');
      }
    } catch (e) {
      throw Exception('Failed to fetch questions: $e');
    }
  }
}
