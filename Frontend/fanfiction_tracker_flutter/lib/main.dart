import 'package:fanfiction_tracker_flutter/common/widgets/bottom_bar.dart';
import 'package:fanfiction_tracker_flutter/constants/global_variables.dart';
import 'package:fanfiction_tracker_flutter/features/auth/screens/auth_screen.dart';
import 'package:fanfiction_tracker_flutter/features/auth/services/auth_service.dart';
import 'package:fanfiction_tracker_flutter/providers/user_provider.dart';
import 'package:fanfiction_tracker_flutter/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fanfiction Tracker',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: false,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? const BottomBar(initialPage: 0)
          : const AuthScreen(),
    );
  }
}
