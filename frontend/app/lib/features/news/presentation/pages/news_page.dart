import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injection/injection.dart';
import '../../domain/entities/question_entity.dart';
import '../bloc/news_bloc.dart';
import '../widgets/question_list.dart';
import 'result_screen.dart';

class NewsPage extends StatelessWidget {
  final List<QuestionItem>? wrongQuestionItems;

  const NewsPage({super.key, this.wrongQuestionItems});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<NewsBloc>();

        // 오답 문제가 있으면 오답 문제를 로드, 없으면 일반 문제를 로드
        if (wrongQuestionItems != null && wrongQuestionItems!.isNotEmpty) {
          bloc.add(
              LoadWrongAnswersEvent(wrongQuestionItems: wrongQuestionItems!));
        } else {
          bloc.add(LoadQuestionsEvent());
        }

        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(wrongQuestionItems != null ? '오답노트 문제 풀기' : 'News Quiz'),
        ),
        body: BlocListener<NewsBloc, NewsState>(
          listener: (context, state) {
            // 모든 문제를 완료했을 때 결과 화면으로 이동
            if (state is NewsCompleted) {
              // GoRouter를 사용하여 결과 화면으로 이동
              context.go('/result', extra: state.questionItems);
            }
          },
          child: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              if (state is NewsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NewsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      ElevatedButton(
                        onPressed: () {
                          if (wrongQuestionItems != null &&
                              wrongQuestionItems!.isNotEmpty) {
                            context.read<NewsBloc>().add(LoadWrongAnswersEvent(
                                wrongQuestionItems: wrongQuestionItems!));
                          } else {
                            context.read<NewsBloc>().add(LoadQuestionsEvent());
                          }
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is NewsLoaded ||
                  state is NewsSubmittingAnswer ||
                  state is NewsAnswerSubmitted ||
                  state is NewsCompleted) {
                final questionItems = state is NewsLoaded
                    ? state.questionItems
                    : state is NewsSubmittingAnswer
                        ? state.questionItems
                        : state is NewsAnswerSubmitted
                            ? (state as NewsAnswerSubmitted).questionItems
                            : (state as NewsCompleted).questionItems;

                final currentQuestionIndex = state is NewsLoaded
                    ? state.currentQuestionIndex
                    : state is NewsSubmittingAnswer
                        ? state.currentQuestionIndex
                        : state is NewsAnswerSubmitted
                            ? (state as NewsAnswerSubmitted)
                                .currentQuestionIndex
                            : 0; // NewsCompleted일 때는 인덱스가 필요없음

                final isSubmitted = state is NewsAnswerSubmitted;

                // NewsCompleted 상태일 때는 로딩 표시
                if (state is NewsCompleted) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('결과를 준비하고 있습니다...'),
                      ],
                    ),
                  );
                }

                return QuestionList(
                  questionItems: questionItems,
                  currentQuestionIndex: currentQuestionIndex,
                  isSubmitted: isSubmitted,
                );
              }
              return const Center(
                  child: Text('Press the button to load questions'));
            },
          ),
        ),
      ),
    );
  }
}
