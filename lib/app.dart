import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

import 'library.dart';

final GlobalKey<ScaffoldMessengerState> messenger = GlobalKey<ScaffoldMessengerState>();

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final ExceptionService _exceptionService = ExceptionImplementation();

  @override
  void initState() {
    _exceptionService.handleException();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        navigatorKey: Navigate.navigatorKey,
        defaultTransition: Transition.fade,
        theme: MainTheme.light,
        darkTheme: MainTheme.dark,
        themeMode: Database.themeMode,
        title: "Nearby",
        color: CommonColors.darkTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: ParentLayout.route,
        unknownRoute: GetPage(
          name: PageNotFoundLayout.route,
          page: () => const PageNotFoundLayout(),
          transition: Transition.size,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        useInheritedMediaQuery: true,
        getPages: Routes.all,
        routingCallback: MainConfiguration.data.updateRoute,
        builder: (context, child) {
          return ToastificationConfigProvider(
            config: const ToastificationConfig(
              alignment: Alignment.center,
              animationDuration: Duration(milliseconds: 500),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}