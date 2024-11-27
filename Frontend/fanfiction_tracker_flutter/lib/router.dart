import 'package:fanfiction_tracker_flutter/common/widgets/bottom_bar.dart';
import 'package:fanfiction_tracker_flutter/features/auth/screens/auth_screen.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/screens/add_fanfic_screen.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/screens/fanfic_with_review_display.dart';
import 'package:fanfiction_tracker_flutter/features/fanfic_related/screens/home_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(initialPage: 0),
      );
    case AddFanficScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddFanficScreen(),
      );
    case FanficWithReviewDisplay.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const FanficWithReviewDisplay(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist'),
          ),
        ),
      );
  }
}
