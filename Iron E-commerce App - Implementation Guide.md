# Iron E-commerce App - Implementation Guide

This document provides detailed instructions for implementing and extending the Iron E-commerce App.

## Development Environment Setup

1. **Flutter SDK Installation**
   - Download and install Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Add Flutter to your PATH
   - Run `flutter doctor` to verify installation

2. **IDE Setup**
   - Install Android Studio or VS Code
   - Install Flutter and Dart plugins
   - Configure Flutter SDK path in IDE

3. **Dependencies**
   - The app uses the following key dependencies:
     - `provider`: For state management
     - `http`: For API communication
     - `shared_preferences`: For local storage
   - All dependencies are listed in `pubspec.yaml`

## Code Structure and Organization

### Models

The app uses the following data models:

1. **Product Model (`product_model.dart`)**
   - Represents iron products with industry-specific attributes
   - Includes technical specifications, dimensions, and certifications
   - Handles serialization/deserialization for API communication

2. **User Model (`user_model.dart`)**
   - Manages user authentication and profile information
   - Supports both individual and business accounts
   - Stores shipping addresses and order history

3. **Cart Model (`cart_model.dart`)**
   - Handles shopping cart functionality
   - Calculates pricing based on quantity and volume discounts
   - Manages shipping and tax calculations

### Screens

The app includes the following screens:

1. **Splash Screen**
   - Initial loading screen with company logo
   - Handles authentication check and navigation

2. **Login/Registration Screens**
   - User authentication with email/password
   - Business account registration with additional fields

3. **Home Screen**
   - Main navigation hub with product categories
   - Featured products and promotions
   - Quick access to industry-specific tools

4. **Product Screens**
   - Product listing with filtering and sorting
   - Detailed product view with technical specifications
   - Related products and accessories

5. **Cart and Checkout Screens**
   - Shopping cart management
   - Multi-step checkout process
   - Order confirmation and tracking

6. **Account Management**
   - User profile and settings
   - Order history and tracking
   - Address and payment method management

7. **Industry-Specific Tools**
   - Steel weight calculator
   - Material requirement estimator
   - Technical reference guides

### Services

The app uses the following services:

1. **API Service (`api_service.dart`)**
   - Handles communication with backend API
   - Manages authentication tokens
   - Provides methods for product and order operations

2. **Local Storage Service**
   - Manages persistent data storage
   - Caches product information for offline access
   - Stores user preferences and settings

## Extending the App

### Adding New Product Types

To add new iron product types:

1. Update the `Product` class in `product_model.dart` to include any new attributes
2. Add the new product type to the category list in the home screen
3. Create appropriate UI components for displaying the new product type
4. Update the technical specifications widget to handle the new product type

### Implementing New Features

To add new features to the app:

1. Create new widget classes in the `widgets` directory
2. Add new screen classes in the `screens` directory
3. Update the navigation routes in `main.dart`
4. Add any necessary API endpoints to the `ApiService` class

### Customizing the UI

To customize the app appearance:

1. Update the theme configuration in `main.dart`
2. Modify the color scheme and typography
3. Replace logo and icon assets in the `assets` directory
4. Customize widget styles in their respective files

## Backend Integration

The app is designed to work with a RESTful API backend. To integrate with your backend:

1. Update the `baseUrl` in `api_service.dart` to point to your API server
2. Ensure your API endpoints match the expected format
3. Update the data models if your API uses different JSON structures
4. Implement any additional authentication requirements

## Testing

The app includes the following testing strategies:

1. **Unit Tests**
   - Tests for individual components and functions
   - Located in the `test` directory
   - Run with `flutter test`

2. **Widget Tests**
   - Tests for UI components and interactions
   - Located in the `test/widget_test.dart` file
   - Run with `flutter test`

3. **Integration Tests**
   - End-to-end tests for complete features
   - Located in the `integration_test` directory
   - Run with `flutter test integration_test`

## Deployment

### Android Deployment

1. Update the application ID in `android/app/build.gradle`
2. Configure signing keys in `android/app/build.gradle`
3. Build the release APK with `flutter build apk --release`
4. Upload to Google Play Store

### iOS Deployment

1. Update the bundle identifier in `ios/Runner.xcodeproj`
2. Configure signing certificates in Xcode
3. Build the release IPA with `flutter build ios --release`
4. Upload to Apple App Store

## Troubleshooting

Common issues and solutions:

1. **Build Errors**
   - Run `flutter clean` and then `flutter pub get`
   - Ensure Flutter SDK is up to date with `flutter upgrade`

2. **API Connection Issues**
   - Verify the API server is running and accessible
   - Check network permissions in app manifests
   - Inspect API responses for error messages

3. **UI Rendering Issues**
   - Use Flutter DevTools to inspect the widget tree
   - Check for overflow errors in the console
   - Test on different screen sizes and orientations

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design Guidelines](https://material.io/design)
- [Provider Package Documentation](https://pub.dev/packages/provider)
