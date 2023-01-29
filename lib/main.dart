import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/Core/managers/SharedPreferencesManager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shelter/style/Style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'router/AppRouter.gr.dart';
//*************************************************************************************/
//**************************************main*************************************/
//*************************************************************************************/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await EasyLocalization.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SharedPreferencesManager().initState();
  OneSignal.shared.setAppId("e27f1d0f-c0bc-4e0f-bdd3-b2bd8ff29700");

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
  });

  runApp(ProviderScope(
    child: EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/lang', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        child: MyApp()),
  ));
}

class MyApp extends HookConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppRouter appRouter = ref.watch(appRouterProvider);
    navgationManager.appRouter = appRouter;
    ref.watch(langProvider);
    var focus = useFocusNode();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focus);
      },
      child: MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        theme: Style.appTheme(context),
        locale: context.locale,
        builder: EasyLoading.init(),
        routerDelegate: appRouter.delegate(
          navigatorObservers: () {
            final List<NavigatorObserver> obs = [];
            obs.addAll(AutoRouterDelegate.defaultNavigatorObserversBuilder());
            return obs;
          },
        ),
        routeInformationParser: appRouter.defaultRouteParser(),
      ),
    );
  }
}

final langProvider = StateProvider<Locale>((ref) {
  return Locale('en');
});
