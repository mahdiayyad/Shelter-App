import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/Core/managers/Session.dart';
import 'package:shelter/models/ClinicModel.dart';
import 'package:shelter/providers/posts_provider.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/CommonWidgets.dart';
import 'package:shelter/views/common/common_ui.dart';
import 'package:shelter/views/common/form_builder_map_field.dart';
import 'package:shelter/views/tabs/posts/add_post_screen.dart';


//*************************************************************************************/
//**************************************EditAccountScreen******************************/
//*************************************************************************************/

final _auth = FirebaseAuth.instance;
final _formKey = GlobalKey<FormBuilderState>();

/// this is the edit account screen
class EditAccountScreen extends ConsumerWidget {
  const EditAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonUi.appbar(context,
            title: LocaleKeys.editAccount.tr(), iconColor: Style.secondary),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: ref.read(profileDetailsStreamProvider).snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());

              default:
                var user = ClinicModel.fromJson(snapshot.data?.data() ?? {});
                final editButton = CommonButton(
                  text: LocaleKeys.save.tr(),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      var data = _formKey.currentState?.value;
                      postDetailsToFirestore(data ?? {}, context, user);
                    }
                  },
                );
                final nameField = FormBuilderTextField(
                  keyboardType: TextInputType.name,
                  initialValue: user.name,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: LocaleKeys.nameNotEmpty.tr()),
                    FormBuilderValidators.minLength(context, 3,
                        errorText: LocaleKeys.enter_valid_name.tr()),
                  ]),
                  textInputAction: TextInputAction.next,
                  decoration: Style.inputDecoration(context).copyWith(
                    prefixIcon: Icon(Icons.account_circle),
                    hintText: LocaleKeys.name.tr(),
                  ),
                  name: 'name',
                );
                final descriptionField = FormBuilderTextField(
                  keyboardType: TextInputType.name,
                  initialValue: user.description,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: LocaleKeys.description_not_empty.tr()),
                    FormBuilderValidators.minLength(context, 3,
                        errorText: LocaleKeys.enter_valid_description.tr()),
                  ]),
                  textInputAction: TextInputAction.next,
                  decoration: Style.inputDecoration(context).copyWith(
                    hintText: LocaleKeys.description.tr(),
                  ),
                  name: 'description',
                );
                final phoneNumberField = FormBuilderPhoneField(
                  keyboardType: TextInputType.phone,
                  initialValue: user.phoneNumber,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: LocaleKeys.phoneNumberNotEmpty.tr()),
                  ]),
                  textInputAction: TextInputAction.next,
                  decoration: Style.inputDecoration(context).copyWith(
                    // prefixIcon: Icon(Icons.account_circle),
                    hintText: LocaleKeys.pNumber.tr(),
                  ),
                  name: 'phoneNumber',
                );
                final locationField = FormBuilderLocationField(
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  valueTransformer: (value) {
                    return value?.target.toJson();
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: LocaleKeys.locationNotEmpty.tr()),
                  ]),
                  decoration: Style.inputDecoration(context).copyWith(
                    prefixIcon: Icon(Icons.pin_drop),
                    hintText: LocaleKeys.location.tr(),
                  ),
                  initialValue: user.location != null
                      ? CameraPosition(
                          target:
                              LatLng(user.location?.first, user.location?.last))
                      : null,
                  name: 'location',
                );

                return SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ImageCustomPicker(
                              initData: user.image,
                            ),
                            SizedBox(height: 10),

                            SizedBox(height: 45),
                            nameField, SizedBox(height: 20),
                            descriptionField,
                            Session.userType != UserType.customer
                                ? Column(
                                    children: [
                                      SizedBox(height: 20),
                                      phoneNumberField,
                                      SizedBox(height: 20),
                                      locationField,
                                    ],
                                  )
                                : Container(),

                            SizedBox(height: 20),
                            editButton,
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            }
          },
        ));
  }

  postDetailsToFirestore(Map<String, dynamic> input, BuildContext context,
      ClinicModel user) async {
    EasyLoading.show(status: LocaleKeys.loading.tr());
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? userAuth = _auth.currentUser;

    Map<String, dynamic> temp = {};
    temp.addAll(input);

    if (Session.userType != UserType.customer) {
      temp.addAll({"is_approved": false});
    }
    if (temp['image'] != null && temp['image'].toString().isNotEmpty) {
      if (user.image != temp['image']) {
        await deleteFileFromLink(user);
        var tempFile = File(temp['image']);
        var imageref = await FirebaseStorage.instance
            .ref('images/posts/${tempFile.hashCode}.png')
            .putFile(tempFile);
        var link = await imageref.ref.getDownloadURL();
        temp['image'] = link;
      }
    } else {
      await deleteFileFromLink(user);
    }

    await firebaseFirestore.collection("users").doc(userAuth?.uid).update(temp);
    EasyLoading.dismiss();
    Fluttertoast.showToast(msg: LocaleKeys.account_edited.tr());
    navgationManager.pop();
  }

  Future<void> deleteFileFromLink(ClinicModel user) async {
    if (user.image != null && (user.image?.isNotEmpty ?? false)) {
      await FirebaseStorage.instance.refFromURL(user.image!).delete();
    }
    return;
  }
}