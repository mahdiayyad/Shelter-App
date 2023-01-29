import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shelter/models/ClinicModel.dart';
import 'package:shelter/models/UserModel.dart';
import 'package:shelter/Core/tools/StringExtension.dart';
import 'package:shelter/providers/posts_provider.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/common/profile_widget.dart';
import 'package:shelter/views/tabs/posts/PostCard.dart';
import 'package:shelter/views/tabs/stores/store_card.dart';
import 'package:toggle_switch/toggle_switch.dart';

//*************************************************************************************/
//**************************************ClinicProfile**********************************/
//*************************************************************************************/

/// this is the clinic profile
class ClinicProfile extends ConsumerWidget {
  final ClinicModel clinicModel;
  final bool showEditButton;
  final String? uid;
  const ClinicProfile(
      {Key? key,
      required this.clinicModel,
      this.showEditButton = true,
      this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 24),
          ProfileWidget(
            imagePath: clinicModel.image,
            isEdit: showEditButton,
            onClicked: () async {},
          ),
          SizedBox(height: 24),
          buildName(clinicModel),
          showEditButton
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ToggleSwitch(
                      minWidth: 90.0,
                      cornerRadius: 20.0,
                      activeBgColors: [
                        [Style.secondary],
                        [Style.secondary]
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Style.lightGrey,
                      inactiveFgColor: Colors.white,
                      initialLabelIndex:
                          context.locale.languageCode == 'ar' ? 1 : 0,
                      totalSwitches: 1,
                      labels: ['English', 'العربية'],
                      radiusStyle: true,
                      onToggle: (index) {
                        context.setLocale(
                            index == 0 ? Locale('en') : Locale('ar'));
                      }),
                )
              : Container(),
          showEditButton
              ? TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    navgationManager.navigateRoot(LoginRoute());
                  },
                  child: Text(LocaleKeys.logout.tr()))
              : Container(),
          SizedBox(
            height: 30,
          ),
          DefaultTabController(
              length: 1,
              child: Card(
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Style.secondary,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 32),
                      indicatorColor: Style.secondary,
                      tabs: [
                        Tab(
                          child: Text(
                            LocaleKeys.post.tr(),
                            style: Style.getFont(context).headline6?.copyWith(
                                color: Style.secondary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      padding: EdgeInsets.all(0),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: TabBarView(children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder(
                              stream:
                                  ref.read(postsRefUidPovider(uid)).snapshots(),
                              builder: (context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data?.docs.isEmpty ?? true) {
                                    return Center(
                                      child: Text(
                                        LocaleKeys.no_posts.tr(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }
                                  return Expanded(
                                    child: SingleChildScrollView(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            snapshot.data?.docs.length ?? 0,
                                        itemBuilder: (context, index) {
                                          return PostCard(
                                            doc: snapshot.data?.docs[index],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(snapshot.error.toString()),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget buildName(UserModel user) => Column(
        children: [
          Text(
            "${user.name}".toTitleCase(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 4),
          Text(
            user.email ?? '',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 4),
          Text(
            clinicModel.phoneNumber ?? '',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
}
