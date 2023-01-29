import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/common_ui.dart';
//*************************************************************************************/
//**************************************AddStoreItemSelection**************************/
//*************************************************************************************/
class AddStoreItemSelection extends StatelessWidget {
  const AddStoreItemSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonUi.appbar(context,title:  LocaleKeys.choose_to_add.tr()),
        body: Center(
          child: Wrap(
            children: [
              InkWell(
                onTap: () {
                  navgationManager.navigatePush(AddStoreItemRoute());
                },
                child: Card(
                  shape: Style.roundedRectangleBorder,
                  color: Style.secondaryVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          LineIcons.bone,
                          color: Style.secondary,
                          size: 56,
                        ),
                        Text(
                          LocaleKeys.item.tr(),
                          style: Style.getFont(context)
                              .headline6
                              ?.copyWith(color: Style.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  navgationManager.navigatePush(AddStorePetRoute());
                },
                child: Card(
                  shape: Style.roundedRectangleBorder,
                  color: Style.secondaryVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          LineIcons.dog,
                          color: Style.secondary,
                          size: 56,
                        ),
                        Text(
                          LocaleKeys.pet.tr(),
                          style: Style.getFont(context)
                              .headline6
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
