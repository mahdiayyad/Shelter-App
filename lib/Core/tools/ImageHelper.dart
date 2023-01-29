
import 'package:app_settings/app_settings.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/views/common/common_ui.dart';

class ImageHelper {
  Function(XFile) onImage;
  ImageHelper({
    required this.context,
    required this.onImage,
  });
  List<XFile> resultList = [];
  BuildContext context;
  List<XFile> images = [];

  selectImage() async {
    // if (!kIsWeb) {
    //   AndroidDeviceInfo? androidInfo;
    //   try {
    //     if (Platform.isAndroid) {
    //       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //       androidInfo = await deviceInfo.androidInfo;
    //     }
    //   // ignore: empty_catches
    //   } catch (e) {}
    //   showModalBottomSheet(
    //       context: context,
    //       builder: (_) {
    //         return _bottomSheet(androidInfo?.version.sdkInt ?? 23);
    //       });
    // }
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return _bottomSheet(23);
        });
  }

  Future _getImage(ImageSource source) async {
    FocusScope.of(context).requestFocus(FocusNode());

    try {
      var image = await ImagePicker().pickImage(
          source: source,
          imageQuality: 60, // <- Reduce Image quality
          maxHeight: 1024, // <- reduce the image size
          maxWidth: 1024);
      if (image != null) {
        onImage(image);
      }
    } on PlatformException catch (e) {
      if (e.code == LocaleKeys.photo_access_denied.tr() || e.code == LocaleKeys.camera_access_denied.tr()) {
        CommonUi.alert(context,
            title: LocaleKeys.photo_access_denied.tr(),
            msg: LocaleKeys.photo_access_denied.tr(),
            ok: LocaleKeys.yes.tr(),
            cancle: LocaleKeys.no.tr(),
            onDone: () => {AppSettings.openAppSettings()});
      }
    }
  }

  Widget _bottomSheet(int sdk) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(LocaleKeys.choosefrom.tr()),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // sdk < 29
              //     ?

              TextButton.icon(
                onPressed: () {
                  _getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.camera),
                label: Text(LocaleKeys.camera.tr()),
              ),
              // : Container(),
              TextButton.icon(
                onPressed: () {
                  _getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.image),
                label: Text(LocaleKeys.gallery.tr()),
              )
            ],
          )
        ],
      ),
    );
  }
}
