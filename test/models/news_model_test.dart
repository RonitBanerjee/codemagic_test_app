import 'package:flutter_test/flutter_test.dart';
import 'package:playground/models/news_model.dart';

void main() {
  group('NewsArticle', () {
    test('should create NewsArticle from JSON', () {
      final json = {
        'article_id': '123',
        'title': 'Test Article',
        'link': 'https://example.com',
        'snippet': 'Test snippet',
        'photo_url': 'https://example.com/photo.jpg',
        'thumbnail_url': 'https://example.com/thumb.jpg',
        'published_datetime_utc': '2026-01-09T10:00:00.000Z',
        'authors': ['John Doe', 'Jane Smith'],
        'source_url': 'https://example.com',
        'source_name': 'Example News',
        'source_logo_url': 'https://example.com/logo.png',
        'source_favicon_url': 'https://example.com/favicon.ico',
        'source_publication_id': 'pub123',
        'related_topics': [
          {'topic_id': 'topic1', 'topic_name': 'Sports'}
        ],
        'sub_articles': []
      };

      final article = NewsArticle.fromJson(json);

      expect(article.articleId, '123');
      expect(article.title, 'Test Article');
      expect(article.link, 'https://example.com');
      expect(article.snippet, 'Test snippet');
      expect(article.photoUrl, 'https://example.com/photo.jpg');
      expect(article.authors.length, 2);
      expect(article.authors[0], 'John Doe');
      expect(article.sourceName, 'Example News');
      expect(article.relatedTopics.length, 1);
      expect(article.relatedTopics[0].topicName, 'Sports');
    });

    test('should parse published date correctly', () {
      final json = {
        'article_id': '123',
        'title': 'Test',
        'link': 'https://example.com',
        'snippet': 'Test',
        'published_datetime_utc': '2026-01-09T10:00:00.000Z',
        'authors': [],
        'source_url': 'https://example.com',
        'source_name': 'Example',
      };

      final article = NewsArticle.fromJson(json);
      final publishedDate = article.publishedDateTime;

      expect(publishedDate, isNotNull);
      expect(publishedDate!.year, 2026);
      expect(publishedDate.month, 1);
      expect(publishedDate.day, 9);
    });

    test('should handle missing optional fields', () {
      final json = {
        'article_id': '123',
        'title': 'Test',
        'link': 'https://example.com',
        'snippet': 'Test',
        'published_datetime_utc': '2026-01-09T10:00:00.000Z',
        'authors': [],
        'source_url': 'https://example.com',
        'source_name': 'Example',
      };

      final article = NewsArticle.fromJson(json);

      expect(article.photoUrl, isNull);
      expect(article.thumbnailUrl, isNull);
      expect(article.sourceLogoUrl, isNull);
      expect(article.relatedTopics, isEmpty);
      expect(article.subArticles, isEmpty);
    });

    test('should support equality comparison', () {
      final json = {
        'article_id': '123',
        'title': 'Test',
        'link': 'https://example.com',
        'snippet': 'Test',
        'published_datetime_utc': '2026-01-09T10:00:00.000Z',
        'authors': [],
        'source_url': 'https://example.com',
        'source_name': 'Example',
      };

      final article1 = NewsArticle.fromJson(json);
      final article2 = NewsArticle.fromJson(json);

      expect(article1, equals(article2));
    });
  });

  group('RelatedTopic', () {
    test('should create RelatedTopic from JSON', () {
      final json = {
        'topic_id': 'topic123',
        'topic_name': 'Football',
      };

      final topic = RelatedTopic.fromJson(json);

      expect(topic.topicId, 'topic123');
      expect(topic.topicName, 'Football');
    });
  });

  group('NewsResponse', () {
    test('should create NewsResponse from JSON', () {
      final json = {
        'status': 'OK',
        'request_id': 'req123',
        'data': [
          {
            'article_id': '1',
            'title': 'Article 1',
            'link': 'https://example.com/1',
            'snippet': 'Snippet 1',
            'published_datetime_utc': '2026-01-09T10:00:00.000Z',
            'authors': [],
            'source_url': 'https://example.com',
            'source_name': 'Example',
          },
          {
            'article_id': '2',
            'title': 'Article 2',
            'link': 'https://example.com/2',
            'snippet': 'Snippet 2',
            'published_datetime_utc': '2026-01-09T11:00:00.000Z',
            'authors': [],
            'source_url': 'https://example.com',
            'source_name': 'Example',
          }
        ]
      };

      final response = NewsResponse.fromJson(json);

      expect(response.status, 'OK');
      expect(response.requestId, 'req123');
      expect(response.articles.length, 2);
      expect(response.articles[0].title, 'Article 1');
      expect(response.articles[1].title, 'Article 2');
    });

    test('should handle empty articles list', () {
      final json = {
        'status': 'OK',
        'request_id': 'req123',
        'data': []
      };

      final response = NewsResponse.fromJson(json);

      expect(response.articles, isEmpty);
    });
  });
}
