import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/Core/tools/ImageHelper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/models/StoreItemModel.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/CommonWidgets.dart';
import 'package:shelter/views/common/ImageLoader.dart';
import 'package:shelter/views/common/common_ui.dart';

//*************************************************************************************/
//**************************************addStoreItemScreen*****************************/
//*************************************************************************************/

var _formKey = GlobalKey<FormBuilderState>();

final itemImagePathProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

class AddStoreItemScreen extends ConsumerWidget {
  const AddStoreItemScreen({
    this.isEdit = false,
    Key? key,
    this.initData,
    this.itemRef,
  }) : super(key: key);
  final StoreItemModel? initData;
  final bool isEdit;
  final DocumentReference? itemRef;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String path = ref.watch(itemImagePathProvider);
    return Scaffold(
      appBar: CommonUi.appbar(
        context,
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        LocaleKeys.add_new_item.tr(),
                        style: Style.getFont(context)
                            .headline4
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderField<String>(
                          initialValue: initData?.image,
                          valueTransformer: (value) {
                            return path;
                          },
                          builder: (field) {
                            return field.value != null &&
                                    (field.value?.isNotEmpty ?? false)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Stack(
                                      children: [
                                        ImageLoader(
                                          path: field.value,
                                          fit: BoxFit.cover,
                                          height: 300,
                                          width: double.maxFinite,
                                        ),
                                        Positioned(
                                            top: 4,
                                            right: 4,
                                            child: ClipOval(
                                              child: Container(
                                                color: Colors.white60,
                                                child: IconButton(
                                                    hoverColor:
                                                        Colors.tealAccent,
                                                    onPressed: () {
                                                      field.didChange(null);
                                                      ref
                                                          .read(
                                                              itemImagePathProvider
                                                                  .state)
                                                          .state = '';
                                                    },
                                                    icon: Icon(Icons.close)),
                                              ),
                                            )),
                                      ],
                                      alignment: Alignment.center,
                                    ),
                                  )
                                : Column(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            ImageHelper(
                                                context: context,
                                                onImage: (XFile file) {
                                                  field.didChange(file.path);
                                                  ref
                                                      .read(
                                                          itemImagePathProvider
                                                              .state)
                                                      .update(
                                                          (state) => file.path);
                                                }).selectImage();
                                          },
                                          child: DottedBorder(
                                            color: Style.secondary,
                                            radius: Radius.circular(32),
                                            strokeWidth: 2,
                                            dashPattern: [5, 5],
                                            strokeCap: StrokeCap.round,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(32.0),
                                              child: Icon(
                                                LineIcons.image,
                                                color: Style.secondary,
                                                size: 56,
                                              ),
                                            ),
                                          )),
                                      field.hasError
                                          ? Text(
                                              field.errorText ?? '',
                                              style: Style.getFont(context)
                                                  .subtitle1
                                                  ?.copyWith(color: Colors.red),
                                            )
                                          : Container(),
                                    ],
                                  );
                          },
                          name: 'image'),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          keyboardType: TextInputType.multiline,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: LocaleKeys.description.tr()),
                            FormBuilderValidators.minLength(context, 3,
                                errorText: LocaleKeys.enter_valid_name.tr()),
                          ]),
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.center,
                          initialValue: initData?.description,
                          decoration:
                              Style.inAppInputDecoration(context).copyWith(
                            hintText: LocaleKeys.description.tr(),
                          ),
                          name: 'description',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          initialValue: initData?.price,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: 'price'.tr()),
                            FormBuilderValidators.minLength(context, 2,
                                errorText: LocaleKeys.enter_valid_name.tr()),
                          ]),
                          textInputAction: TextInputAction.done,
                          decoration:
                              Style.inAppInputDecoration(context).copyWith(
                            hintText: LocaleKeys.price.tr(),
                          ),
                          name: 'price',
                        ),
                      ),
                    ],
                  ),

                  CommonButton(
                      text: LocaleKeys.save,
                      width: double.maxFinite,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          var val = _formKey.currentState?.value;
                          additem(val, ref);
                        }
                      }),
                ],
              ),
            )),
      ),
    );
  }

  /// this will add the item in database
  Future<void> additem(Map<String, dynamic>? val, WidgetRef ref) async {
    EasyLoading.show(status: LocaleKeys.loading.tr());
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Map<String, dynamic> temp = {};
    temp.addAll(val ?? {});
    if (isEdit) {
      temp.addAll({
        'is_approved': false,
      });
    } else {
      temp.addAll({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'is_approved': false,
        'likes': [],
        'type': 'item',
      });
    }

    if (temp['image'] != null && temp['image'].toString().isNotEmpty) {
      if (initData?.image != temp['image']) {
        await deleteFileFromLink();
        var tempFile = File(temp['image']);
        var imageref = await FirebaseStorage.instance
            .ref('images/items/${tempFile.hashCode}.png')
            .putFile(tempFile);
        var link = await imageref.ref.getDownloadURL();
        temp['image'] = link;
      }
    } else {
      await deleteFileFromLink();
    }

    if (isEdit) {
      await itemRef?.update(temp);
    } else {
      await firebaseFirestore.collection("items").doc().set(temp);
    }

    EasyLoading.dismiss();
    Fluttertoast.showToast(msg: LocaleKeys.post_added.tr());
    navgationManager.pop();
  }

  Future<void> deleteFileFromLink() async {
    if (initData?.image != null && (initData?.image?.isNotEmpty ?? false)) {
      await FirebaseStorage.instance.refFromURL(initData!.image!).delete();
    }
    return;
  }
}
