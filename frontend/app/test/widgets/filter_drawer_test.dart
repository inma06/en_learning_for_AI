import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_learning_app/widgets/filter_drawer.dart';

void main() {
  late Function(String, String) mockOnApplyFilters;

  setUp(() {
    mockOnApplyFilters = (difficulty, category) {};
  });

  testWidgets('FilterDrawer displays filter options',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          endDrawer: FilterDrawer(
            selectedDifficulty: 'all',
            selectedCategory: 'all',
            onApplyFilters: mockOnApplyFilters,
          ),
        ),
      ),
    );

    expect(find.text('필터'), findsOneWidget);
    expect(find.text('난이도'), findsOneWidget);
    expect(find.text('카테고리'), findsOneWidget);
    expect(find.text('전체'), findsNWidgets(2));
    expect(find.text('쉬움'), findsOneWidget);
    expect(find.text('보통'), findsOneWidget);
    expect(find.text('어려움'), findsOneWidget);
    expect(find.text('어휘'), findsOneWidget);
    expect(find.text('문법'), findsOneWidget);
    expect(find.text('독해'), findsOneWidget);
  });

  testWidgets('FilterDrawer applies selected filters',
      (WidgetTester tester) async {
    String? selectedDifficulty;
    String? selectedCategory;

    mockOnApplyFilters = (difficulty, category) {
      selectedDifficulty = difficulty;
      selectedCategory = category;
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          endDrawer: FilterDrawer(
            selectedDifficulty: 'all',
            selectedCategory: 'all',
            onApplyFilters: mockOnApplyFilters,
          ),
        ),
      ),
    );

    await tester.tap(find.text('쉬움'));
    await tester.pump();
    await tester.tap(find.text('어휘'));
    await tester.pump();
    await tester.tap(find.text('적용'));
    await tester.pump();

    expect(selectedDifficulty, 'easy');
    expect(selectedCategory, 'vocabulary');
  });

  testWidgets('FilterDrawer maintains selected values',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          endDrawer: FilterDrawer(
            selectedDifficulty: 'medium',
            selectedCategory: 'grammar',
            onApplyFilters: mockOnApplyFilters,
          ),
        ),
      ),
    );

    expect(find.text('보통'), findsOneWidget);
    expect(find.text('문법'), findsOneWidget);
  });

  testWidgets('FilterDrawer closes after applying filters',
      (WidgetTester tester) async {
    bool drawerClosed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          endDrawer: FilterDrawer(
            selectedDifficulty: 'all',
            selectedCategory: 'all',
            onApplyFilters: (_, __) {
              drawerClosed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('적용'));
    await tester.pump();

    expect(drawerClosed, true);
  });
}
