import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/models/UserModel.dart';

import 'package:shelter/providers/posts_provider.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/style/Style.dart';
import 'package:shelter/views/tabs/posts/PostCard.dart';

class PostsScreen extends ConsumerWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: ref.read(profileDetailsStreamProvider).snapshots(),
            builder: (context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.data()?.isEmpty ?? true) {
                  return Container();
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Welcome ${snapshot.data?.data()?["name"]}",
                    style: Style.getFont(context)
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
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
          StreamBuilder(
            stream: ref.read(postsRefPovider).snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navgationManager.navigatePush(AddPostRoute());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
