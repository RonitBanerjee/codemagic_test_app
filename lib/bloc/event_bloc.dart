import 'package:flutter_bloc/flutter_bloc.dart';
import 'event_event.dart';
import 'event_state.dart';
import '../services/event_api_service.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsApiService newsApiService;

  NewsBloc({required this.newsApiService}) : super(NewsInitial()) {
    on<LoadNews>(_onLoadNews);
  }

  Future<void> _onLoadNews(
    LoadNews event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      final response = await newsApiService.getNews(query: event.query);
      emit(NewsLoaded(response.articles));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}
