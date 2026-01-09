# Codemagic Test App

A Flutter news application that displays the latest news articles using the RapidAPI Real-Time News Data API with Bloc state management.

## Features

- 📰 Real-time news from multiple US sources
- 🎨 Clean Material Design 3 UI
- 🖼️ Rich images with thumbnails
- 🔄 Pull-to-refresh functionality
- 📱 Responsive card-based layout
- 🔍 Detailed article view with related articles
- ⏰ Relative time display (e.g., "2h ago")
- 🏷️ Related topics as chips
- 🌐 Source attribution with logos

## Architecture

This app follows the BLoC (Business Logic Component) pattern for state management:

- **Bloc**: State management layer (`lib/bloc/`)
- **Models**: Data models (`lib/models/`)
- **Services**: API services (`lib/services/`)
- **Pages**: UI screens (`lib/pages/`)

## Dependencies

- `flutter_bloc`: ^8.1.3 - State management
- `http`: ^1.1.0 - API calls
- `flutter_dotenv`: ^5.1.0 - Environment configuration
- `equatable`: ^2.0.5 - Value equality

## Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/codemagic_test_app.git
   cd codemagic_test_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. The `.env` file is included with the API credentials for testing purposes

4. Run the app:
   ```bash
   flutter run
   ```

## API

This app uses the [RapidAPI Real-Time News Data API](https://rapidapi.com/letscrape-6bRBa3QguO5/api/real-time-news-data) to fetch news articles.

## Project Structure

```
lib/
├── bloc/
│   ├── event_bloc.dart       # News Bloc
│   ├── event_event.dart      # News Events
│   └── event_state.dart      # News States
├── models/
│   └── news_model.dart       # Data models
├── pages/
│   ├── news_list_page.dart   # Main listing page
│   └── news_detail_page.dart # Detail view
├── services/
│   └── event_api_service.dart # API service
└── main.dart                  # App entry point
```

## Screenshots

(Add screenshots here)

## License

This project is created for testing purposes.
