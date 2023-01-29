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
import 'package:shelter/models/PostModel.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/CommonWidgets.dart';
import 'package:shelter/views/common/ImageLoader.dart';
import 'package:shelter/views/common/common_ui.dart';

var _formKey = GlobalKey<FormBuilderState>();

final postImagePathProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({
    this.isEdit = false,
    Key? key,
    this.initData,
    this.postRef,
  }) : super(key: key);
  final PostModel? initData;
  final bool isEdit;
  final DocumentReference? postRef;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CommonUi.appbar(context, title: LocaleKeys.add_new_post.tr()),
      body: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormBuilderTextField(
                  name: 'description',
                  initialValue: initData?.description,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                  validator: FormBuilderValidators.required(context,
                      errorText: LocaleKeys.description_not_empty.tr()),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: Style.getFont(context).subtitle1?.copyWith(
                          color: Style.lightGrey,
                        ),
                    hintText: LocaleKeys.what_is_on_your_mind.tr(),
                  ),
                ),
                ImageCustomPicker(
                  initData: initData?.image,
                ),

                CommonButton(
                    text: LocaleKeys.save,
                    width: double.maxFinite,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        var val = _formKey.currentState?.value;
                        addPost(val, ref);
                      }
                    }),
                // FormBuilderImagePicker(
                //   name: 'image',
                //   bottomSheetPadding: EdgeInsets.all(16),
                //   cameraIcon: Icon(LineIcons.camera),
                // ),
              ],
            ),
          )),
    );
  }

  Future<void> addPost(Map<String, dynamic>? val, WidgetRef ref) async {
    // calling our firestore
    // calling our user model
    // sending these values
    EasyLoading.show(status: LocaleKeys.loading.tr());
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // writing all the values
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
    /// Saves the images on the storage of the firebase
    if (temp['image'] != null && temp['image'].toString().isNotEmpty) {
      if (initData?.image != temp['image']) {
        await deleteFileFromLink();
        var tempFile = File(temp['image']);
        var imageref = await FirebaseStorage.instance
            .ref('images/posts/${tempFile.hashCode}.png')
            .putFile(tempFile);
        var link = await imageref.ref.getDownloadURL();
        temp['image'] = link;
      }
    } else {
      await deleteFileFromLink();
    }

    if (isEdit) {
      await postRef?.update(temp);
    } else {
      await firebaseFirestore.collection("posts").doc().set(temp);
    }

    EasyLoading.dismiss();
    Fluttertoast.showToast(msg: LocaleKeys.post_added.tr());
    // ref.refresh(postsProvider.notifier);
    // navgationManager.popUntil();
    navgationManager.pop();
  }

  /// Deletes the image from storage
  Future<void> deleteFileFromLink() async {
    if (initData?.image != null && (initData?.image?.isNotEmpty ?? false)) {
      await FirebaseStorage.instance.refFromURL(initData!.image!).delete();
    }
    return;
  }
}

class ImageCustomPicker extends ConsumerWidget {
  const ImageCustomPicker({
    Key? key,
    required this.initData,
  }) : super(key: key);

  final String? initData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilderField<String>(
        initialValue: initData,
        builder: (field) {
          return field.value != null && (field.value?.isNotEmpty ?? false)
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
                                  hoverColor: Colors.tealAccent,
                                  onPressed: () {
                                    field.didChange(null);
                                    ref
                                        .read(postImagePathProvider.state)
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
                                    .read(postImagePathProvider.state)
                                    .update((state) => file.path);
                              }).selectImage();
                        },
                        child: DottedBorder(
                          color: Style.lightGrey,
                          radius: Radius.circular(32),
                          strokeWidth: 2,
                          dashPattern: [5, 5],
                          strokeCap: StrokeCap.round,
                          borderType: BorderType.RRect,
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Icon(
                              LineIcons.image,
                              color: Style.lightGrey,
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
        name: 'image');
  }
}
