import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/routes/index.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Local Auth';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: AppRoutes.initial,
        onGenerateRoute: RouteGenerator.generateRoute,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Cairo',
        ),
      );
}
