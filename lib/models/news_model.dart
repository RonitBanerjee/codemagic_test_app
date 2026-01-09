import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  final String articleId;
  final String title;
  final String link;
  final String snippet;
  final String? photoUrl;
  final String? thumbnailUrl;
  final String publishedDatetimeUtc;
  final List<String> authors;
  final String sourceUrl;
  final String sourceName;
  final String? sourceLogoUrl;
  final String? sourceFaviconUrl;
  final String? sourcePublicationId;
  final List<RelatedTopic> relatedTopics;
  final List<NewsArticle> subArticles;

  const NewsArticle({
    required this.articleId,
    required this.title,
    required this.link,
    required this.snippet,
    this.photoUrl,
    this.thumbnailUrl,
    required this.publishedDatetimeUtc,
    this.authors = const [],
    required this.sourceUrl,
    required this.sourceName,
    this.sourceLogoUrl,
    this.sourceFaviconUrl,
    this.sourcePublicationId,
    this.relatedTopics = const [],
    this.subArticles = const [],
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      articleId: json['article_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
      snippet: json['snippet']?.toString() ?? '',
      photoUrl: json['photo_url']?.toString(),
      thumbnailUrl: json['thumbnail_url']?.toString(),
      publishedDatetimeUtc: json['published_datetime_utc']?.toString() ?? '',
      authors: (json['authors'] as List<dynamic>?)
              ?.map((author) => author.toString())
              .toList() ??
          [],
      sourceUrl: json['source_url']?.toString() ?? '',
      sourceName: json['source_name']?.toString() ?? '',
      sourceLogoUrl: json['source_logo_url']?.toString(),
      sourceFaviconUrl: json['source_favicon_url']?.toString(),
      sourcePublicationId: json['source_publication_id']?.toString(),
      relatedTopics: (json['related_topics'] as List<dynamic>?)
              ?.map((topic) => RelatedTopic.fromJson(topic))
              .toList() ??
          [],
      subArticles: (json['sub_articles'] as List<dynamic>?)
              ?.map((article) => NewsArticle.fromJson(article))
              .toList() ??
          [],
    );
  }

  DateTime? get publishedDateTime {
    try {
      return DateTime.parse(publishedDatetimeUtc);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
        articleId,
        title,
        link,
        snippet,
        photoUrl,
        thumbnailUrl,
        publishedDatetimeUtc,
        authors,
        sourceUrl,
        sourceName,
        sourceLogoUrl,
        sourceFaviconUrl,
        sourcePublicationId,
        relatedTopics,
        subArticles,
      ];
}

class RelatedTopic extends Equatable {
  final String topicId;
  final String topicName;

  const RelatedTopic({
    required this.topicId,
    required this.topicName,
  });

  factory RelatedTopic.fromJson(Map<String, dynamic> json) {
    return RelatedTopic(
      topicId: json['topic_id']?.toString() ?? '',
      topicName: json['topic_name']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [topicId, topicName];
}

class NewsResponse extends Equatable {
  final String status;
  final String requestId;
  final List<NewsArticle> articles;

  const NewsResponse({
    required this.status,
    required this.requestId,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      status: json['status']?.toString() ?? '',
      requestId: json['request_id']?.toString() ?? '',
      articles: (json['data'] as List<dynamic>?)
              ?.map((article) => NewsArticle.fromJson(article))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [status, requestId, articles];
}
