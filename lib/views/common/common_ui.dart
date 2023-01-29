import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/style/Style.dart';
//*************************************************************************************/
//**************************************common_ui**************************************/
//*************************************************************************************/



/// this is the appbar that has [arrow_back] and [title]
class CommonUi {
  static appbar(BuildContext context,
      {String? title, Color? iconColor, Color? bcColor}) {
    return AppBar(
      backgroundColor: bcColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded,
            color: iconColor ?? Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: title != null
            ? Text(
                title.tr(),
                style: Style.getFont(context)
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
            : Container(),
      ),
    );
  }

  /// this is the alert that shows to the user
  static Future<void> alert(BuildContext context,
      {String title = '',
      String msg = '',
      String msgcontent = '',
      String? ok,
      String? cancle,
      Widget? content,
      Function? onDone,
      Function? onDismiss}) async {
    /// flutter defined function
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        /// return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: content ?? Text(msg),
          actions: <Widget>[
            /// usually buttons at the bottom of the dialog
            TextButton(
              child: Text(ok ?? LocaleKeys.ok.tr()),
              onPressed: () {
                if (onDone != null) {
                  onDone();
                }
              },
            ),
            TextButton(
              child: Text(cancle ?? LocaleKeys.cancel.tr()),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
    /// print(ondismiss);
    if (onDismiss != null) {
      onDismiss();
    }
  }
}
