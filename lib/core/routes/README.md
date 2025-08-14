# App Routing System

This routing system has been implemented to reduce the number of `setState` calls throughout the app and provide a centralized, maintainable navigation solution.

## Overview

The routing system consists of several components:

1. **AppRoutes** - Route constants
2. **RouteGenerator** - Route generation logic
3. **NavigationService** - Centralized navigation methods
4. **BaseRoute** - Base class for route pages
5. **RouteManager** - Advanced route management with history tracking

## Benefits

- **Reduced setState calls**: Navigation state is managed centrally
- **Centralized navigation**: All navigation logic in one place
- **Type-safe routing**: Route names are constants, reducing typos
- **Easier maintenance**: Route changes only need to be made in one place
- **Better state management**: Loading states and navigation states are managed automatically

## Usage

### Basic Navigation

Instead of using `Navigator.push` directly:

```dart
// Old way (requires setState)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => HomePage(
      selectedBank: selectedBank!,
      amount: widget.amount,
      customerName: '',
    ),
  ),
);

// New way (no setState needed)
await NavigationService.goToHome(
  selectedBank: selectedBank!,
  amount: widget.amount,
  customerName: '',
);
```

### Using BaseRoute

Extend `BaseRoute` instead of `StatefulWidget` to get automatic loading state management:

```dart
class MyPage extends BaseRoute {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends BaseRouteState<MyPage> {
  @override
  void onInit() {
    super.onInit();
    // Initialize data here
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Text('My Page Content'),
        ElevatedButton(
          onPressed: () async {
            showLoading(); // Shows loading indicator
            await Future.delayed(Duration(seconds: 2));
            hideLoading(); // Hides loading indicator
            
            await navigateToHome(
              selectedBank: 'Bank Name',
              amount: '100.00',
              customerName: 'Customer Name',
            );
          },
          child: Text('Navigate'),
        ),
      ],
    );
  }
}
```

### Route Constants

Use route constants instead of hardcoded strings:

```dart
// Old way
Navigator.pushNamed(context, '/home');

// New way
NavigationService.goToHome(
  selectedBank: selectedBank,
  amount: amount,
  customerName: customerName,
);
```

### Advanced Route Management

Use `RouteManager` for advanced features like history tracking:

```dart
final routeManager = RouteManager();

// Navigate with history tracking
await routeManager.navigateTo(
  context,
  AppRoutes.home,
  arguments: {'key': 'value'},
);

// Check route history
print('Current route: ${routeManager.currentRoute}');
print('Can go back: ${routeManager.canGoBack()}');

// Pop until specific route
await routeManager.popUntilRoute(context, AppRoutes.userData);
```

## Migration Guide

### Step 1: Update imports

Replace direct Navigator imports with routing system imports:

```dart
// Old imports
import 'package:flutter/material.dart';

// New imports
import 'package:flutter/material.dart';
import '../../../core/routes/navigation_service.dart';
import '../../../core/routes/app_routes.dart';
```

### Step 2: Replace Navigator calls

Replace all `Navigator.push`, `Navigator.pushReplacement`, etc. with NavigationService methods.

### Step 3: Extend BaseRoute (optional)

For pages that need loading states or navigation helpers, extend `BaseRoute` instead of `StatefulWidget`.

### Step 4: Update route names

Replace hardcoded route strings with `AppRoutes` constants.

## Available Navigation Methods

- `NavigationService.goToUserData()`
- `NavigationService.goToSaveFingerprint()`
- `NavigationService.goToChooseBank(firsttime: bool, amount: String)`
- `NavigationService.goToPayment()`
- `NavigationService.goToHome(selectedBank: String, amount: String, customerName: String)`
- `NavigationService.goToFingerprint()`

## Route History

The `RouteManager` automatically tracks route history, allowing you to:

- Check if you can go back
- Get the previous route
- Pop until a specific route
- Clear the entire route stack

## Error Handling

The routing system includes built-in error handling and loading states. Use the `showLoading()`, `hideLoading()`, and snackbar methods from `BaseRouteState` for consistent user experience.

## Best Practices

1. **Always use route constants** instead of hardcoded strings
2. **Use NavigationService methods** instead of direct Navigator calls
3. **Extend BaseRoute** for pages that need loading states
4. **Handle async operations** properly with loading states
5. **Use the route manager** for complex navigation scenarios

## Example Migration

Here's a complete example of migrating from the old system to the new one:

```dart
// Before (with setState)
class OldPage extends StatefulWidget {
  @override
  _OldPageState createState() => _OldPageState();
}

class _OldPageState extends State<OldPage> {
  bool isLoading = false;

  void navigateToHome() {
    setState(() {
      isLoading = true;
    });
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          selectedBank: 'Bank',
          amount: '100',
          customerName: 'Name',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading 
        ? CircularProgressIndicator()
        : ElevatedButton(
            onPressed: navigateToHome,
            child: Text('Go Home'),
          ),
    );
  }
}

// After (no setState needed)
class NewPage extends BaseRoute {
  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends BaseRouteState<NewPage> {
  void navigateToHome() async {
    showLoading();
    await NavigationService.replaceWithHome(
      selectedBank: 'Bank',
      amount: '100',
      customerName: 'Name',
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return ElevatedButton(
      onPressed: navigateToHome,
      child: Text('Go Home'),
    );
  }
}
```

This new system significantly reduces the need for `setState` calls and provides a much cleaner, more maintainable navigation architecture. 