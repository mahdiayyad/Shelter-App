import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/tabs/clinics/clinics_screen.dart';
import 'package:shelter/views/tabs/posts/posts_screen.dart';
import 'package:shelter/views/tabs/profile/profile_screen.dart';
import 'package:shelter/views/tabs/stores/stores_screen.dart';
//*************************************************************************************/
//**************************************HomeScreen*************************************/
//*************************************************************************************/
final tabIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final getTapProvider = StateProvider<Widget>((ref) {
  final int index = ref.watch(tabIndexProvider);
  switch (index) {
    case 0:
      return const PostsScreen();
    case 1:
      return const StoresScreen();
    case 2:
      return const ClinicsScreen();
    default:
      return const ProfileScreen();
  }
});

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);
  final icon = CupertinoIcons.moon_stars;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime currentBackPressTime = DateTime.now();
    final int activeIndex = ref.watch(tabIndexProvider);
    final Widget body = ref.watch(getTapProvider);
    return WillPopScope(
        onWillPop: () {
          final DateTime now = DateTime.now();
          if (now.difference(currentBackPressTime) >
              const Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(
              msg: tr("message_exit"),
            );

            return Future.value(false);
          }

          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: Style.appbarColor,
          body: body,
          bottomNavigationBar: buildBottomNav(activeIndex, ref),
        ));
  }

  Widget buildBottomNav(int index, WidgetRef ref) {
    return FancyBottomNavigation(
      initialSelection: index,
      circleColor: Colors.white,
      activeIconColor: Style.secondary,
      inactiveIconColor: Colors.white,
      barBackgroundColor: Style.secondary,
      textColor: Colors.white,
      tabs: [
        TabData(
          iconData: LineIcons.globeWithAsiaShown,
          title: LocaleKeys.home.tr(),
        ),
        TabData(
          iconData: Icons.storefront_outlined,
          title: LocaleKeys.store.tr(),
        ),
        TabData(
          iconData: LineIcons.stethoscope,
          title: LocaleKeys.clinic.tr(),
        ),
        TabData(
          iconData: LineIcons.user,
          title: LocaleKeys.profile.tr(),
        ),
      ],
      onTabChangedListener: (position) {
        ref.read(tabIndexProvider.state).state = position;
      },
    );
  }
}
