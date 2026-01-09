import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../models/news_model.dart';
import 'news_detail_page.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsInitial) {
            context.read<NewsBloc>().add(const LoadNews());
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            if (state.articles.isEmpty) {
              return const Center(child: Text('No news found'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(const LoadNews());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return NewsCard(
                    article: article,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => NewsDetailPage(article: article),
                      //   ),
                      // );
                    },
                  );
                },
              ),
            );
          } else if (state is NewsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NewsBloc>().add(const LoadNews());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.article, required this.onTap});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.photoUrl != null && article.photoUrl!.isNotEmpty)
              Image.network(
                article.photoUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (article.snippet.isNotEmpty) ...[
                    Text(
                      article.snippet,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      if (article.sourceFaviconUrl != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(
                            article.sourceFaviconUrl!,
                            width: 16,
                            height: 16,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox(),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          article.sourceName,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(article.publishedDateTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  if (article.authors.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'By ${article.authors.join(", ")}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
