import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:url_launcher/url_launcher.dart';

final appRouterProvider = Provider((ref) => AppRouter());
class NavgationManager {
  static final NavgationManager _navgationManager =
      NavgationManager._internal();

  factory NavgationManager() {
    return _navgationManager;
  }
  NavgationManager._internal();

  AppRouter? appRouter;
  /// this will pop all the screens from stack until the first screen
  void popUntilfirst() {
    return appRouter?.popUntil((route) => route.isFirst);
  }

  /// keeps poping routes until predicate is satisfied
  void popUntil(PageRouteInfo routein) {
    appRouter?.popUntil((route) => routein.routeName == route.settings.name);
  }


  /// pops the last page unless stack has 1 entry
  void pop() {
    appRouter?.pop();
  }


  /// adds a new entry to the pages stack
  Future<Object?> navigatePush(PageRouteInfo route) {
    try {
      return appRouter!.push(route);
    } on Exception catch (e) {
      Logger().e(e);
    }
    return Future.value(null);
  }


  /// removes last entry in stack and pushs provided route
  /// -- if last entry == provided route page will just be updated    
  Future<Object?> navigateReplace(PageRouteInfo route) {
    return appRouter!.popAndPush(route);
  }

  /// pops all routes down to the root 
  Future<Object?> navigateRoot(PageRouteInfo route) {
    appRouter!.popUntilRoot();
    return appRouter!.replace(route);
  }

  Future<void> launchLocation(String lat, String lng) async {
    final String googleMapsUrl = "comgooglemaps://?center=$lat,$lng";
    final String appleMapsUrl = "https://maps.apple.com/?q=$lat,$lng";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
      return;
    }
    if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl, forceSafariVC: false);
    } else {
      Logger().d('Could not launch location');
    }
  }

  Future<bool> launchURL({required String url}) async {
    if (await canLaunch(url)) {
      final b = await launch(url);
      return b;
    } else {
      Logger().d('Could not launch $url');
      return false;
    }
  }

  /// pushes the screen to the dialer
  void lunchPhone({required String phoneNumber}) {
    launchURL(url: "tel:$phoneNumber");
  }
}

NavgationManager navgationManager = NavgationManager();
