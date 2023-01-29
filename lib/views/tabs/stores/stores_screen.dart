import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/Core/managers/Session.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/providers/posts_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/tabs/stores/pet_store_card.dart';
import 'package:shelter/views/tabs/stores/store_card.dart';
//*************************************************************************************/
//**************************************StoreScreen*************************************/
//*************************************************************************************/
class StoresScreen extends ConsumerWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              TabBar(
                labelColor: Style.secondary,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 32),
                indicatorColor: Style.secondary,
                tabs: [
                  Tab(
                    child: Text(
                      LocaleKeys.items.tr(),
                      style: Style.getFont(context).headline6?.copyWith(
                          color: Style.secondary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      LocaleKeys.pets.tr(),
                      style: Style.getFont(context).headline6?.copyWith(
                          color: Style.secondary, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
                padding: EdgeInsets.all(0),
              ),
              Expanded(
                child: TabBarView(children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: ref.read(itemsRefPovider).snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
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
                                  itemCount: snapshot.data?.docs.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return StoreCard(
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: ref.read(petsRefPovider).snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
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
                                  itemCount: snapshot.data?.docs.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return PetStoreCard(
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
          floatingActionButton: Session.userType == UserType.store
              ? FloatingActionButton(
                  onPressed: () {
                    navgationManager.navigatePush(AddStoreItemSelection());
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : Container(),
        ),
      ),
    );
  }
}
