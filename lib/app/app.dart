import 'package:test/ui/views/home/home_screen.dart';
import 'package:test/ui/views/Bottomnav/Bottomview.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: BottomNavView),
    MaterialRoute(page: HomeScreen),

    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
)
class App {}
