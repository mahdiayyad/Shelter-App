import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:shelter/models/StorePetModel.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/CommonWidgets.dart';
import 'package:shelter/views/common/ImageLoader.dart';
import 'package:shelter/views/common/common_ui.dart';
import 'package:toggle_switch/toggle_switch.dart';

var _formKey = GlobalKey<FormBuilderState>();

final petImagePathProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

class AddStorePetScreen extends ConsumerWidget {
  const AddStorePetScreen({
    this.isEdit = false,
    Key? key,
    this.initData,
    this.petRef,
  }) : super(key: key);
  final StorePetModel? initData;
  final bool isEdit;
  final DocumentReference? petRef;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String path = ref.watch(petImagePathProvider);
    List<FormBuilderFieldOption<String>> options = [
      FormBuilderFieldOption(value: LocaleKeys.dog.tr()),
      FormBuilderFieldOption(value: LocaleKeys.cat.tr()),
      FormBuilderFieldOption(value: LocaleKeys.bird.tr()),
      FormBuilderFieldOption(value: LocaleKeys.fish.tr()),
      FormBuilderFieldOption(value: LocaleKeys.others.tr()),
    ];
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
                        LocaleKeys.add_new_pet.tr(),
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
                                                              petImagePathProvider
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
                                                      .read(petImagePathProvider
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
                                errorText: LocaleKeys.name.tr()),
                            FormBuilderValidators.minLength(context, 3,
                                errorText: LocaleKeys.enter_valid_name.tr()),
                          ]),
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.center,
                          initialValue: initData?.name,
                          decoration:
                              Style.inAppInputDecoration(context).copyWith(
                            hintText: LocaleKeys.name.tr(),
                          ),
                          name: 'name',
                        ),
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
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Style.secondary),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  LocaleKeys.age.tr(),
                                  style: Style.getFont(context)
                                      .subtitle1
                                      ?.copyWith(color: Style.secondary),
                                ),
                                FormBuilderSlider(
                                  valueTransformer: (value) {
                                    return value?.toInt();
                                  },
                                  numberFormat: NumberFormat('#0'),
                                  initialValue:
                                      initData?.age?.toDouble() ?? 0.0,
                                  validator: FormBuilderValidators.required(
                                      context,
                                      errorText: LocaleKeys.age.tr()),
                                  name: 'age',
                                  max: 40,
                                  min: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderChoiceChip<String>(
                          initialValue: initData?.type,
                          validator: FormBuilderValidators.required(context,
                              errorText: LocaleKeys.type.tr()),
                          backgroundColor: Style.lightGrey,
                          padding: EdgeInsets.all(8),
                          selectedColor: Style.secondary,
                          spacing: 8,
                          disabledColor: Style.secondaryVariant,
                          labelStyle: Style.getFont(context)
                              .subtitle1
                              ?.copyWith(color: Colors.white),
                          elevation: 2,
                          decoration:
                              Style.inAppInputDecoration(context).copyWith(
                            hintText: LocaleKeys.type.tr(),
                          ),
                          name: 'type',
                          options: options,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderField<String>(
                          validator: FormBuilderValidators.required(context,
                              errorText: LocaleKeys.name.tr()),
                          name: 'gender',
                          builder: (FormFieldState<String> field) {
                            return ToggleSwitch(
                                minWidth: 90.0,
                                cornerRadius: 20.0,
                                activeBgColors: [
                                  [Style.secondary],
                                  [Style.secondary]
                                ],
                                activeFgColor: Colors.white,
                                inactiveBgColor: Style.lightGrey,
                                inactiveFgColor: Colors.white,
                                initialLabelIndex: field.value == 'M' ? 0 : 1,
                                totalSwitches: 2,
                                labels: ['M', 'F'],
                                radiusStyle: true,
                                onToggle: (index) {
                                  if (index == 0) {
                                    field.didChange('M');
                                  } else {
                                    field.didChange('F');
                                  }
                                });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FormBuilderTextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          initialValue: initData?.price,
                          validator: FormBuilderValidators.required(context,
                              errorText: LocaleKeys.price.tr()),
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
      });
    }

    if (temp['image'] != null && temp['image'].toString().isNotEmpty) {
      if (initData?.image != temp['image']) {
        await deleteFileFromLink();
        var tempFile = File(temp['image']);
        var imageref = await FirebaseStorage.instance
            .ref('images/pets/${tempFile.hashCode}.png')
            .putFile(tempFile);
        var link = await imageref.ref.getDownloadURL();
        temp['image'] = link;
      }
    } else {
      await deleteFileFromLink();
    }
    if (isEdit) {
      await petRef?.update(temp);
    } else {
      await firebaseFirestore.collection("pets").doc().set(temp);
    }

    EasyLoading.dismiss();
    Fluttertoast.showToast(msg: LocaleKeys.pet_added.tr());
    navgationManager.pop();
  }

  Future<void> deleteFileFromLink() async {
    if (initData?.image != null && (initData?.image?.isNotEmpty ?? false)) {
      await FirebaseStorage.instance.refFromURL(initData!.image!).delete();
    }
    return;
  }
}
