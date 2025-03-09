import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notify/notify.dart';
import 'package:smart/smart.dart';

import 'library.dart';

final GlobalKey<ScaffoldMessengerState> messenger = GlobalKey<ScaffoldMessengerState>();

NotifyAppInformation _info = NotifyAppInformation(
  androidIcon: "notification_icon",
  app: PlatformEngine.instance.notifyApp,
);

class Main extends StatefulWidget {
  final bool checkUpdate;
  final bool isBackground;
  const Main({super.key, this.checkUpdate = true, this.isBackground = false});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final ExceptionService _exceptionService = ExceptionImplementation();

  @override
  void initState() {
    _handleUpdate();
    MainConfiguration.data.isBackground.value = widget.isBackground;

    _exceptionService.handleException();
    NotificationController.instance.initialize();

    super.initState();
  }

  void _handleUpdate() {
    if(widget.checkUpdate) {
      PlatformEngine.instance.updateDevice();
    }
  }

  @override
  void didUpdateWidget(covariant Main oldWidget) {
    if(oldWidget.checkUpdate.notEquals(widget.checkUpdate)) {
      _handleUpdate();
    }

    if(oldWidget.isBackground.notEquals(widget.isBackground)) {
      MainConfiguration.data.isBackground.value = widget.isBackground;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return NotifyWrapper(
      info: _info,
      showInitializationLogs: PlatformEngine.instance.debug,
      platform: PlatformEngine.instance.notifyPlatform,
      onLaunchedByNotification: NotificationController.instance.onLaunchedByNotification,
      handler: NotificationHandler.instance.process,
      backgroundHandler: notificationTapBackground,
      child: GetMaterialApp(
        navigatorKey: Navigate.navigatorKey,
        defaultTransition: Transition.fade,
        theme: MainTheme.instance.light,
        darkTheme: MainTheme.instance.dark,
        themeMode: Database.instance.themeMode,
        title: "Nearby",
        color: CommonColors.instance.darkTheme,
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
      ),
    );
  }
}

void runNotification() {
  remoteNotification.init(
    _info,
    PlatformEngine.instance.debug,
    NotificationHandler.instance.process,
    notificationTapBackground
  );
}