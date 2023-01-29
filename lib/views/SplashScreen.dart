import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/Core/tools/otherTools.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/AssetsKeys.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/ImageLoader.dart';
//*************************************************************************************/
//**************************************SplashScreen*************************************/
//*************************************************************************************/
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    postDelayed(
        callbak: () async {
          if (FirebaseAuth.instance.currentUser?.uid != null) {
            await navgationManager.navigateRoot(const HomeRoute());
          } else {
            await navgationManager.navigateRoot(const IntroRoute());
          }
        },
        milliseconds: 5000);
  }

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Style.secondary,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageLoader(path: SvgAssets.appIcon, width: 80, height: 80),
                Text(tr("app_name"),
                    style: Style.rudaTextTheme.headline2
                        ?.copyWith(color: Style.primary)),
              ],
            ),
          ),
        );
      },
    );
  }
}
