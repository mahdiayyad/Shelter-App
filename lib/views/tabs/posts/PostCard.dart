import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shelter/models/UserModel.dart';
import 'package:shelter/views/common/CommonWidgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/models/PostModel.dart';
import 'package:shelter/providers/posts_provider.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/AssetsKeys.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/ImageLoader.dart';

class PostCard extends ConsumerWidget {
  const PostCard({
    Key? key,
    required this.doc,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>>? doc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostModel post = PostModel.fromJson(doc?.data() ?? {});
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        shape: Style.roundedRectangleBorder,
        child: ref.watch(userDetailsPorvider(post.userId)).when(
            data: (value) {
              var user = UserModel.fromJson(value.object?.data() ?? {});

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              navgationManager.navigatePush(ShowProfileRoute(
                                  uid: value.object?.id ?? ''));
                            },
                            child: ClipOval(
                              child: ImageLoader(
                                path: user.image.toString().isEmpty ||
                                        user.image == null
                                    ? ImageAssets.placeholder
                                    : user.image,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name ?? ""),
                              Text(
                                timeago.format(post.timestamp.toDate(),
                                    locale: 'en_short'),
                                style: Style.getFont(context)
                                    .subtitle2
                                    ?.copyWith(color: Style.lightGrey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      post.userId == (FirebaseAuth.instance.currentUser?.uid)
                          ? PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Text(LocaleKeys.edit_post.tr()),
                                    value: 1,
                                  ),
                                  PopupMenuItem(
                                    child: Text(LocaleKeys.delete_post.tr()),
                                    value: 2,
                                  ),
                                ];
                              },
                              onSelected: (value) async {
                                if (value == 1) {
                                  navgationManager.navigatePush(AddPostRoute(
                                      initData: post,
                                      isEdit: true,
                                      postRef: doc?.reference));
                                } else if (value == 2) {
                                  var result = await showOkCancelAlertDialog(
                                    okLabel: LocaleKeys.yes.tr(),
                                    cancelLabel: LocaleKeys.no.tr(),
                                    context: context,
                                    title: LocaleKeys.alert.tr(),
                                    message:
                                        LocaleKeys.are_you_sure_delete.tr(),
                                  );
                                  if (result.index == 0) {
                                    doc?.reference.delete();
                                    // ref.refresh(postsProvider.notifier);
                                  }
                                }
                              },
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      post.description,
                      style: Style.getFont(context).subtitle2,
                    ),
                  ),
                  post.image?.isEmpty ?? false
                      ? Container()
                      : CardImage(url: post.image ?? ''),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        !post.likes.contains(
                                FirebaseAuth.instance.currentUser?.uid)
                            ? InkWell(
                                onTap: () {
                                  doc?.reference.update({
                                    'likes': FieldValue.arrayUnion([
                                      FirebaseAuth.instance.currentUser?.uid
                                    ])
                                  });
                                },
                                child: Icon(
                                  LineIcons.thumbsUp,
                                  color: Style.lightGrey,
                                  size: 26,
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  doc?.reference.update({
                                    'likes': FieldValue.arrayRemove([
                                      FirebaseAuth.instance.currentUser?.uid
                                    ])
                                  });
                                },
                                child: Icon(
                                  LineIcons.thumbsUpAlt,
                                  color: Style.secondary,
                                  size: 26,
                                )),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          post.likes.length.toString(),
                          style: Style.getFont(context).subtitle1,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => Column(children: [CircularProgressIndicator()]),
            error: (msg) => Text(msg)),
      ),
    );
  }
}
