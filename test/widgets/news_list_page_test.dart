import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:playground/bloc/event_bloc.dart';
import 'package:playground/bloc/event_state.dart';
import 'package:playground/models/news_model.dart';
import 'package:playground/pages/news_list_page.dart';

class MockNewsBloc extends Mock implements NewsBloc {}

void main() {
  late MockNewsBloc mockNewsBloc;

  setUp(() {
    mockNewsBloc = MockNewsBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<NewsBloc>(
        create: (_) => mockNewsBloc,
        child: const NewsListPage(),
      ),
    );
  }

  group('NewsListPage', () {
    testWidgets('displays loading indicator when state is NewsLoading',
        (tester) async {
      when(() => mockNewsBloc.state).thenReturn(NewsLoading());
      when(() => mockNewsBloc.stream).thenAnswer((_) => Stream.value(NewsLoading()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays news list when state is NewsLoaded', (tester) async {
      const testArticles = [
        NewsArticle(
          articleId: '1',
          title: 'Test Article 1',
          link: 'https://example.com/1',
          snippet: 'Snippet 1',
          publishedDatetimeUtc: '2026-01-09T10:00:00.000Z',
          sourceUrl: 'https://example.com',
          sourceName: 'Example News',
        ),
        NewsArticle(
          articleId: '2',
          title: 'Test Article 2',
          link: 'https://example.com/2',
          snippet: 'Snippet 2',
          publishedDatetimeUtc: '2026-01-09T11:00:00.000Z',
          sourceUrl: 'https://example.com',
          sourceName: 'Example News',
        ),
      ];

      when(() => mockNewsBloc.state).thenReturn(const NewsLoaded(testArticles));
      when(() => mockNewsBloc.stream)
          .thenAnswer((_) => Stream.value(const NewsLoaded(testArticles)));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Test Article 1'), findsOneWidget);
      expect(find.text('Test Article 2'), findsOneWidget);
    });

    testWidgets('displays error message when state is NewsError',
        (tester) async {
      const errorMessage = 'Failed to load news';
      when(() => mockNewsBloc.state)
          .thenReturn(const NewsError(errorMessage));
      when(() => mockNewsBloc.stream)
          .thenAnswer((_) => Stream.value(const NewsError(errorMessage)));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Error: $errorMessage'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('displays empty message when no news found', (tester) async {
      when(() => mockNewsBloc.state).thenReturn(const NewsLoaded([]));
      when(() => mockNewsBloc.stream)
          .thenAnswer((_) => Stream.value(const NewsLoaded([])));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('No news found'), findsOneWidget);
    });

    testWidgets('displays app bar with title', (tester) async {
      when(() => mockNewsBloc.state).thenReturn(NewsInitial());
      when(() => mockNewsBloc.stream).thenAnswer((_) => Stream.value(NewsInitial()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Latest News'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  group('NewsCard', () {
    testWidgets('displays article information correctly', (tester) async {
      const testArticle = NewsArticle(
        articleId: '1',
        title: 'Test Article Title',
        link: 'https://example.com',
        snippet: 'This is a test snippet',
        publishedDatetimeUtc: '2026-01-09T10:00:00.000Z',
        sourceUrl: 'https://example.com',
        sourceName: 'Test Source',
        authors: ['John Doe', 'Jane Smith'],
      );

      when(() => mockNewsBloc.state).thenReturn(const NewsLoaded([testArticle]));
      when(() => mockNewsBloc.stream)
          .thenAnswer((_) => Stream.value(const NewsLoaded([testArticle])));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Test Article Title'), findsOneWidget);
      expect(find.text('This is a test snippet'), findsOneWidget);
      expect(find.text('Test Source'), findsOneWidget);
      expect(find.text('By John Doe, Jane Smith'), findsOneWidget);
    });

    testWidgets('card is tappable and navigates to detail page',
        (tester) async {
      const testArticle = NewsArticle(
        articleId: '1',
        title: 'Test Article',
        link: 'https://example.com',
        snippet: 'Snippet',
        publishedDatetimeUtc: '2026-01-09T10:00:00.000Z',
        sourceUrl: 'https://example.com',
        sourceName: 'Source',
      );

      when(() => mockNewsBloc.state).thenReturn(const NewsLoaded([testArticle]));
      when(() => mockNewsBloc.stream)
          .thenAnswer((_) => Stream.value(const NewsLoaded([testArticle])));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      final cardFinder = find.byType(Card).first;
      expect(cardFinder, findsOneWidget);

      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      // Verify navigation occurred by checking for Article Details text
      expect(find.text('Article Details'), findsOneWidget);
    });
  });
}
