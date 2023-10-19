import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:test/app/app.locator.dart';
import 'package:test/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // to run project on edge remove this two lines
  //final appDocumentDir = await getApplicationDocumentsDirectory();
  //Hive.init(appDocumentDir.path);

  await Hive.openBox('todo_data'); // Replace 'myBox' with your box name
  await Hive.openBox('bottomnav_data');
  setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.bottomNavView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
    );
  }
}
