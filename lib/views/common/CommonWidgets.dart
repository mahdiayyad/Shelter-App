import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/ImageLoader.dart';

//*************************************************************************************/
//**************************************CommonWidgets********************************/
//*************************************************************************************/


/// this is the common button that we use in the app
class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
  }) : super(key: key);
  final String text;
  final double? width;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Style.secondary,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: width ?? 250,
          onPressed: onPressed,
          child: Text(text.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))),
    );
  }
}


/// this is the secondary button that we use in the app
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
  }) : super(key: key);
  final String text;
  final double? width;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      // borderRadius: BorderRadius.circular(30),
      color: Style.secondary,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: width ?? 250,
          onPressed: onPressed,
          child: Text(text.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))),
    );
  }
}

class CardImage extends StatelessWidget {
  const CardImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            navgationManager.navigatePush(
                ImageFullViewRoute(url: url));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ImageLoader(
              path: url,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height / 3 - 30,
              width: double.maxFinite,
            ),
          ),
        ),
      );
  }
}
