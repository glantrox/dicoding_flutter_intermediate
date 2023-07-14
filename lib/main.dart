import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_intermediate/core/api/auth_repository.dart';
import 'package:submission_intermediate/core/api/repository.dart';

import 'package:submission_intermediate/providers/auth_provider.dart';
import 'package:submission_intermediate/providers/file_provider.dart';
import 'package:submission_intermediate/providers/stories_provider.dart';
import 'package:submission_intermediate/router/router_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthProvider _authProvider;
  late MyRouterDelegate _myRouterDelegate;

  @override
  void initState() {
    final AuthRepository authRepository = AuthRepository();
    final Repository repository = Repository();
    _authProvider = AuthProvider(authRepository);
    _myRouterDelegate = MyRouterDelegate(
      authRepository,
      repository,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FileProvider()),
        ChangeNotifierProvider(create: (context) => StoriesProvider()),
        ChangeNotifierProvider(create: (context) => _authProvider)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Router(
          routerDelegate: _myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
