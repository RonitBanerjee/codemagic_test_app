// This is a basic smoke test to ensure the app builds without errors.
//
// More comprehensive tests are in:
// - test/models/news_model_test.dart
// - test/bloc/news_bloc_test.dart
// - test/widgets/news_list_page_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:playground/main.dart';

void main() {
  setUpAll(() async {
    // Load .env file before running tests
    TestWidgetsFlutterBinding.ensureInitialized();
    dotenv.testLoad(fileInput: '''
RAPIDAPI_KEY=test_key
RAPIDAPI_HOST=real-time-news-data.p.rapidapi.com
RAPIDAPI_BASE_URL=https://real-time-news-data.p.rapidapi.com
''');
  });

  testWidgets('App builds without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app bar is present with the correct title
    expect(find.text('Latest News'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);

    // Verify that we have a Scaffold
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
