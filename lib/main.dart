import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Replace ApiService and QuizQuestion with your actual implementations.
import 'api_service.dart';
import 'quiz_question.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService apiService = ApiService();
  List<QuizQuestion> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      questions = await apiService.fetchQuestions();
      setState(() {});
    } catch (e) {
      // Handle error gracefully, e.g., show a message to the user.
      Fluttertoast.showToast(msg: 'Failed to fetch questions.');
    }
  }

  void _checkAnswer(String selectedAnswer) {
    if (selectedAnswer == questions[currentQuestionIndex].correctAnswer) {
      setState(() {
        score++;
      });
      Fluttertoast.showToast(msg: 'Correct!');
    } else {
      Fluttertoast.showToast(msg: 'Incorrect.');
    }
    _nextQuestion();
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Quiz completed. Show the score or navigate to a result screen.
      Fluttertoast.showToast(msg: 'Quiz completed. Your score: $score');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      // Show a loading indicator while fetching questions.
      return Scaffold(
        appBar: AppBar(title: Text('Quiz App')),
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      // Display the quiz question and options.
      final currentQuestion = questions[currentQuestionIndex];
      final options = currentQuestion.options;

      return Scaffold(
        appBar: AppBar(title: Text('Quiz App')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Question ${currentQuestionIndex + 1} of ${questions.length}'),
              SizedBox(height: 20),
              Text(
                currentQuestion.question,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ...options.map((option) => ElevatedButton(
                onPressed: () => _checkAnswer(option),
                child: Text(option),
              )),
            ],
          ),
        ),
      );
    }
  }
}
