import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/models/ClinicModel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/AssetsKeys.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/CommonWidgets.dart';
import 'package:shelter/views/common/ImageLoader.dart';

//*************************************************************************************/
//**************************************ClinicCard*************************************/
//*************************************************************************************/

/// this is the clinic card shows in clinic screen
class ClinicCard extends ConsumerWidget {
  const ClinicCard({
    Key? key,
    required this.doc,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>>? doc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ClinicModel clinic = ClinicModel.fromJson(doc?.data() ?? {});
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        shape: Style.roundedRectangleBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        navgationManager
                            .navigatePush(ShowProfileRoute(uid: doc?.id ?? ''));
                      },
                      child: ClipOval(
                        child: ImageLoader(
                          path: clinic.image.toString().isEmpty ||
                                  clinic.image == null
                              ? ImageAssets.placeholder
                              : clinic.image,
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
                        Text(clinic.name ?? ""),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                clinic.description ?? '',
                style: Style.getFont(context).subtitle2,
              ),
            ),
            clinic.image?.isEmpty ?? false
                ? Container()
                : CardImage(url: clinic.image ?? ''),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      !clinic.likes
                              .contains(FirebaseAuth.instance.currentUser?.uid)
                          ? InkWell(
                              onTap: () {
                                doc?.reference.update({
                                  'likes': FieldValue.arrayUnion(
                                      [FirebaseAuth.instance.currentUser?.uid])
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
                                  'likes': FieldValue.arrayRemove(
                                      [FirebaseAuth.instance.currentUser?.uid])
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
                        clinic.likes.length.toString(),
                        style: Style.getFont(context).subtitle1,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      navgationManager.lunchPhone(
                          phoneNumber: clinic.phoneNumber ?? '');
                    },
                    child: Row(children: [
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        LineIcons.phone,
                        color: Style.secondary,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        LocaleKeys.call_now.tr(),
                        style: Style.getFont(context).subtitle1,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}