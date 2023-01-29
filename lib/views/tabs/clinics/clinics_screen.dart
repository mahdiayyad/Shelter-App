import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/providers/posts_provider.dart';
import 'package:shelter/views/tabs/clinics/ClinicCard.dart';

//*************************************************************************************/
//**************************************clinics_screen*************************************/
//*************************************************************************************/


/// this is the clinic screen 
class ClinicsScreen extends ConsumerWidget {
  const ClinicsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: ref.read(clinicsRefPovider).snapshots(),
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
                        return ClinicCard(
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
    );
  }
}
