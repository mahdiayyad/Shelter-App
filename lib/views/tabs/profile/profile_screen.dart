import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/Core/managers/Session.dart';
import 'package:shelter/models/ClinicModel.dart';
import 'package:shelter/models/StoreModel.dart';
import 'package:shelter/models/UserModel.dart';
import 'package:shelter/providers/posts_provider.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/views/tabs/clinics/ClinicProfile.dart';
import 'package:shelter/views/tabs/stores/StoreProfile.dart';
import 'customer_profile.dart';

//*************************************************************************************/
//**************************************profile_screen*********************************/
//*************************************************************************************/

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Scaffold(body: Text(snapshot.error.toString()));
          case ConnectionState.waiting:
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          default:
            var data = snapshot.data?.data() ?? {};
            var store = StoreModel.fromJson(data);
            return Scaffold(
              floatingActionButton: Session.userType != UserType.customer
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: FloatingActionButton(
                        onPressed: () {
                          navgationManager.navigatePush(MapViewRoute(
                              lat: store.location?.first,
                              long: store.location?.last));
                        },
                        child:
                            Icon(LineIcons.locationArrow, color: Colors.white),
                      ),
                    )
                  : null,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Builder(
                  builder: (context) {
                    switch (EnumToString.fromString<UserType>(
                        UserType.values, data['userType'])) {
                      case UserType.clinic:
                        return Column(
                          children: [
                            ClinicProfile(
                              clinicModel: ClinicModel.fromJson(data),
                              showEditButton: true,
                            ),
                          ],
                        );

                      case UserType.store:
                        return StoreProfile(
                          storeModel: StoreModel.fromJson(data),
                          showEditButton: true,
                        );
                      // break;
                      default:
                        return CustomerProfile(
                          customerModel: UserModel.fromJson(data),
                          showEditButton: true,
                        );
                    }
                  },
                ),
              ),
            );
        }
      },
      stream: ref.watch(profileDetailsStreamProvider).snapshots(),
    );
  }
}
