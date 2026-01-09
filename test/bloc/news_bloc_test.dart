import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:playground/bloc/event_bloc.dart';
import 'package:playground/bloc/event_event.dart';
import 'package:playground/bloc/event_state.dart';
import 'package:playground/models/news_model.dart';
import 'package:playground/services/event_api_service.dart';

class MockNewsApiService extends Mock implements NewsApiService {}

void main() {
  group('NewsBloc', () {
    late MockNewsApiService mockNewsApiService;

    setUp(() {
      mockNewsApiService = MockNewsApiService();
    });

    test('initial state is NewsInitial', () {
      final bloc = NewsBloc(newsApiService: mockNewsApiService);
      expect(bloc.state, equals(NewsInitial()));
      bloc.close();
    });

    group('LoadNews', () {
      final testArticles = [
        const NewsArticle(
          articleId: '1',
          title: 'Test Article 1',
          link: 'https://example.com/1',
          snippet: 'Snippet 1',
          publishedDatetimeUtc: '2026-01-09T10:00:00.000Z',
          sourceUrl: 'https://example.com',
          sourceName: 'Example News',
        ),
        const NewsArticle(
          articleId: '2',
          title: 'Test Article 2',
          link: 'https://example.com/2',
          snippet: 'Snippet 2',
          publishedDatetimeUtc: '2026-01-09T11:00:00.000Z',
          sourceUrl: 'https://example.com',
          sourceName: 'Example News',
        ),
      ];

      final testResponse = NewsResponse(
        status: 'OK',
        requestId: 'test123',
        articles: testArticles,
      );

      blocTest<NewsBloc, NewsState>(
        'emits [NewsLoading, NewsLoaded] when news is loaded successfully',
        build: () {
          when(() => mockNewsApiService.getNews(query: any(named: 'query')))
              .thenAnswer((_) async => testResponse);
          return NewsBloc(newsApiService: mockNewsApiService);
        },
        act: (bloc) => bloc.add(const LoadNews()),
        expect: () => [
          NewsLoading(),
          NewsLoaded(testArticles),
        ],
        verify: (_) {
          verify(() => mockNewsApiService.getNews(query: 'Football')).called(1);
        },
      );

      blocTest<NewsBloc, NewsState>(
        'emits [NewsLoading, NewsLoaded] with custom query',
        build: () {
          when(() => mockNewsApiService.getNews(query: 'Basketball'))
              .thenAnswer((_) async => testResponse);
          return NewsBloc(newsApiService: mockNewsApiService);
        },
        act: (bloc) => bloc.add(const LoadNews(query: 'Basketball')),
        expect: () => [
          NewsLoading(),
          NewsLoaded(testArticles),
        ],
        verify: (_) {
          verify(() => mockNewsApiService.getNews(query: 'Basketball'))
              .called(1);
        },
      );

      blocTest<NewsBloc, NewsState>(
        'emits [NewsLoading, NewsError] when loading news fails',
        build: () {
          when(() => mockNewsApiService.getNews(query: any(named: 'query')))
              .thenThrow(Exception('Failed to load news'));
          return NewsBloc(newsApiService: mockNewsApiService);
        },
        act: (bloc) => bloc.add(const LoadNews()),
        expect: () => [
          NewsLoading(),
          const NewsError('Exception: Failed to load news'),
        ],
      );

      blocTest<NewsBloc, NewsState>(
        'emits [NewsLoading, NewsLoaded] with empty list when no articles',
        build: () {
          when(() => mockNewsApiService.getNews(query: any(named: 'query')))
              .thenAnswer(
                  (_) async => const NewsResponse(
                        status: 'OK',
                        requestId: 'test123',
                        articles: [],
                      ));
          return NewsBloc(newsApiService: mockNewsApiService);
        },
        act: (bloc) => bloc.add(const LoadNews()),
        expect: () => [
          NewsLoading(),
          const NewsLoaded([]),
        ],
      );
    });
  });
}
