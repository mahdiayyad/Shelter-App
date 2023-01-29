import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/CommonWidgets.dart';
import 'package:shelter/views/common/ImageLoader.dart';
import 'package:lottie/lottie.dart';

//*************************************************************************************/
//**************************************IntroductionScreen*****************************/
//*************************************************************************************/
final getStartedButton = CommonButton(
    onPressed: () {
      navgationManager.navigatePush(LoginRoute());
    },
    text: LocaleKeys.get_started.tr());

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: LocaleKeys.shelter_intro.tr(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Style.secondary),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    navgationManager.navigatePush(LoginRoute());
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return ImageLoader(
      path: 'assets/images/$assetName',
      width: width,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 14.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Style.primary,
      globalHeader: Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: _buildImage('logo.png', 75),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: SecondaryButton(
          text: LocaleKeys.goRightAway.tr(),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
            title: LocaleKeys.shelter_intro.tr(),
            body: LocaleKeys.shelter_intro_desc.tr(),
            image: Lottie.asset('assets/animation/LottieIntroLogo.json'),
            decoration: pageDecoration),
        PageViewModel(
          title: LocaleKeys.what_we_provide.tr(),
          body: LocaleKeys.what_we_provide_desc.tr(),
          image: Lottie.asset('assets/animation/LottieSecondIntroLogo.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: LocaleKeys.our_mission.tr(),
          body: LocaleKeys.our_mission_desc.tr(),
          image: Lottie.asset('assets/animation/goal-achieved.json'),
          decoration: pageDecoration.copyWith(bodyFlex: 2),
        ),
        PageViewModel(
          title: LocaleKeys.clinic.tr(),
          body: LocaleKeys.clinic_desc.tr(),
          image: Lottie.asset('assets/animation/clinic.json'),
          decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 16),
              imageFlex: 2),
        ),
        PageViewModel(
          title: LocaleKeys.store.tr(),
          body: LocaleKeys.store_desc.tr(),
          image: Lottie.asset('assets/animation/store.json'),
          footer: getStartedButton,
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text(LocaleKeys.skip.tr()),
      next: Icon(Icons.arrow_forward),
      done: Text(LocaleKeys.done.tr(),
          style: TextStyle(fontWeight: FontWeight.w600)),
      color: Style.secondary,
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Style.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
