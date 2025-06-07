import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'core/injection/injection.dart';
import 'core/local_storage/hive_service.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/news/presentation/pages/news_page.dart';
import 'features/news/presentation/pages/result_screen.dart';
import 'features/news/domain/entities/question_entity.dart';
import 'features/wrong_answers/presentation/pages/wrong_answers_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  configureDependencies();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Hive service
  final hiveService = GetIt.instance<HiveService>();
  await hiveService.init();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

// GoRouter 설정
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/questions',
      builder: (context, state) => const NewsPage(),
    ),
    GoRoute(
      path: '/questions/wrong-answers',
      builder: (context, state) {
        final wrongQuestionItems = state.extra as List<QuestionItem>?;
        return NewsPage(wrongQuestionItems: wrongQuestionItems);
      },
    ),
    GoRoute(
      path: '/wrong-answers',
      builder: (context, state) => const WrongAnswersScreen(),
    ),
    GoRoute(
      path: '/result',
      builder: (context, state) {
        final questionItems = state.extra as List<QuestionItem>;
        return ResultScreen(questionItems: questionItems);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Language Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      routerConfig: _router,
    );
  }
}
