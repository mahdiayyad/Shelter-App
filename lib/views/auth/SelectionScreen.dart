import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/Core/managers/Session.dart';
import 'package:shelter/Core/managers/SharedPreferencesManager.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/common_ui.dart';


//*************************************************************************************/
//**************************************SelectionScreen********************************/
//*************************************************************************************/

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonUi.appbar(context,
            title: LocaleKeys.who_you_are.tr(), iconColor: Style.secondary),
        body: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  SharedPreferencesManager().setUserType(UserType.customer);
                  navgationManager.navigatePush(RegistrationRoute());
                },
                child: Card(
                  shape: Style.roundedRectangleBorder,
                  color: Style.secondaryVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      children: [
                        Icon(
                          LineIcons.user,
                          color: Style.secondary,
                          size: 56,
                        ),
                        Text(
                          LocaleKeys.customer.tr(),
                          style: Style.getFont(context)
                              .subtitle1
                              ?.copyWith(color: Style.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  SharedPreferencesManager().setUserType(UserType.store);
                  navgationManager.navigatePush(RegistrationRoute());
                },
                child: Card(
                  shape: Style.roundedRectangleBorder,
                  color: Style.secondaryVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      children: [
                        Icon(
                          LineIcons.store,
                          color: Style.secondary,
                          size: 56,
                        ),
                        Text(
                          LocaleKeys.store.tr(),
                          style: Style.getFont(context)
                              .subtitle1
                              ?.copyWith(color: Style.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  SharedPreferencesManager().setUserType(UserType.clinic);
                  navgationManager.navigatePush(RegistrationRoute());
                },
                child: Card(
                  shape: Style.roundedRectangleBorder,
                  color: Style.secondaryVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      children: [
                        Icon(
                          LineIcons.medicalClinic,
                          color: Style.secondary,
                          size: 56,
                        ),
                        Text(
                          LocaleKeys.clinic.tr(),
                          style: Style.getFont(context)
                              .subtitle1
                              ?.copyWith(color: Style.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
