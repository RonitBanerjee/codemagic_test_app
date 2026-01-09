# Codemagic CI/CD Setup Guide

This guide will help you set up Codemagic for your Flutter news app.

## Overview

This project includes a complete `codemagic.yaml` configuration with 5 workflows:

1. **Development** - Runs on push to `develop` branch
2. **Production Android** - Builds APK/AAB on push to `main` branch
3. **Production iOS** - Builds iOS app on push to `main` branch
4. **Pull Request Check** - Validates PRs with tests and analysis
5. **Manual Test** - Builds debug APKs for feature/bugfix branches

## Step 1: Sign Up for Codemagic

1. Go to [https://codemagic.io](https://codemagic.io)
2. Sign up using your GitHub account
3. Grant Codemagic access to your repositories

## Step 2: Add Your Repository

1. In Codemagic dashboard, click **"Add application"**
2. Select **GitHub** as your repository source
3. Find and select `codemagic_test_app`
4. Click **"Finish: Add application"**

## Step 3: Configure the App

### Enable codemagic.yaml

1. In your app settings, go to **Workflow settings**
2. Select **"Use codemagic.yaml"**
3. Codemagic will automatically detect the `codemagic.yaml` file

### Set Up Environment Variables

1. Go to **App settings** > **Environment variables**
2. Create a new variable group called `env_vars`
3. Add these variables:
   - `RAPIDAPI_KEY` - Your RapidAPI key (secure)
   - `RAPIDAPI_HOST` - `real-time-news-data.p.rapidapi.com`
   - `RAPIDAPI_BASE_URL` - `https://real-time-news-data.p.rapidapi.com`

**Note:** Mark `RAPIDAPI_KEY` as secure to encrypt it.

## Step 4: Create Branch Structure

Create a `develop` branch for development workflow:

```bash
cd /Users/ronitbanerjee/projects/codemagic_test_app/playground
git checkout -b develop
git push -u origin develop
```

## Step 5: Trigger Your First Build

### Option A: Push to Develop
```bash
git checkout develop
# Make a small change
git add .
git commit -m "test: Trigger Codemagic development workflow"
git push
```

### Option B: Create a Pull Request
1. Create a feature branch
2. Make changes and push
3. Open a PR to `main` or `develop`
4. Watch the PR validation workflow run

### Option C: Manual Trigger
1. Go to Codemagic dashboard
2. Select your app
3. Choose a workflow
4. Click **"Start new build"**

## Understanding the Workflows

### 1. Development Workflow

**Triggers:** Push to `develop` branch

**What it does:**
- Installs Flutter dependencies
- Runs code analysis (`flutter analyze`)
- Runs all tests with coverage
- Checks code formatting (`dart format`)
- Generates coverage reports

**Use case:** Daily development and testing

### 2. Production Android Workflow

**Triggers:**
- Push to `main` branch
- Git tags like `v1.0.0`

**What it does:**
- Runs all tests
- Builds release APK
- Builds App Bundle (AAB)
- Emails build artifacts

**Use case:** Production releases for Google Play Store

### 3. Production iOS Workflow

**Triggers:**
- Push to `main` branch
- Git tags like `v1.0.0`

**What it does:**
- Installs CocoaPods dependencies
- Runs all tests
- Builds iOS release (unsigned)
- Emails build artifacts

**Use case:** Production releases for App Store

### 4. Pull Request Validation

**Triggers:** Any pull request

**What it does:**
- Runs code analysis
- Checks formatting
- Runs all tests with coverage
- Builds debug APK

**Use case:** Validate code quality before merging

### 5. Manual Test Workflow

**Triggers:** Push to `feature/*` or `bugfix/*` branches

**What it does:**
- Runs tests
- Builds debug APK
- Emails APK for manual testing

**Use case:** Feature development and QA testing

## Running Tests Locally

Before pushing, run tests locally:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/bloc/news_bloc_test.dart

# Run code analysis
flutter analyze

# Check formatting
dart format --set-exit-if-changed .
```

## View Test Coverage

After running tests with coverage:

```bash
# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser (macOS)
open coverage/html/index.html
```

## Advanced Configuration

### Email Notifications

Edit `codemagic.yaml` to customize email recipients:

```yaml
publishing:
  email:
    recipients:
      - your-email@example.com
    notify:
      success: true
      failure: true
```

### Add Code Signing for iOS

1. Go to **App settings** > **Code signing identities**
2. Upload your iOS certificate and provisioning profile
3. Create a variable group called `app_store_credentials`
4. Update the iOS workflow to use proper signing

### Add Google Play Publishing

1. Set up Google Play API access
2. Add service account JSON to Codemagic
3. Create variable group `google_play`
4. Add publishing configuration to Android workflow

## Monitoring Builds

### View Build Status

1. Go to Codemagic dashboard
2. Select your app
3. View all builds and their status
4. Click on any build to see logs

### Build Badges

Add build badges to your README:

```markdown
[![Codemagic build status](https://api.codemagic.io/apps/<app-id>/status_badge.svg)](https://codemagic.io/apps/<app-id>/latest_build)
```

Replace `<app-id>` with your Codemagic app ID.

## Test Structure

```
test/
├── bloc/
│   └── news_bloc_test.dart       # Bloc unit tests
├── models/
│   └── news_model_test.dart      # Model unit tests
└── widgets/
    └── news_list_page_test.dart  # Widget tests
```

### Test Coverage Goals

- **Models:** 100% coverage (data parsing and equality)
- **Bloc:** 100% coverage (all states and events)
- **Widgets:** 80%+ coverage (key user interactions)
- **Overall:** 80%+ coverage

## Troubleshooting

### Build Fails on Dependencies

**Issue:** `flutter pub get` fails

**Solution:** Check `pubspec.yaml` for correct dependencies

### Tests Fail in CI but Pass Locally

**Issue:** Environment differences

**Solution:** Ensure `.env` file is properly configured in Codemagic

### Code Analysis Errors

**Issue:** `flutter analyze` finds issues

**Solution:** Run locally and fix:
```bash
flutter analyze
```

### Formatting Check Fails

**Issue:** Code not properly formatted

**Solution:** Format code:
```bash
dart format .
```

## Best Practices

1. **Always run tests locally** before pushing
2. **Keep the develop branch stable** - use feature branches
3. **Write tests for new features** before merging
4. **Monitor build failures** and fix promptly
5. **Use semantic versioning** for tags (v1.0.0, v1.1.0)
6. **Keep environment variables secure** - never commit secrets
7. **Review code analysis warnings** regularly

## Next Steps

1. ✅ Set up Codemagic account
2. ✅ Configure workflows
3. ✅ Add environment variables
4. ✅ Trigger first build
5. 📝 Add code signing for production
6. 📝 Set up Google Play publishing
7. 📝 Add Slack/Discord notifications
8. 📝 Set up automated releases

## Resources

- [Codemagic Documentation](https://docs.codemagic.io)
- [Flutter Testing](https://docs.flutter.dev/testing)
- [Bloc Testing](https://bloclibrary.dev/#/testing)
- [YAML Configuration Reference](https://docs.codemagic.io/yaml/yaml-getting-started/)

## Support

If you need help:
- Check [Codemagic Docs](https://docs.codemagic.io)
- Visit [Codemagic Community](https://github.com/codemagic-ci-cd/codemagic-docs/discussions)
- Email support@codemagic.io
