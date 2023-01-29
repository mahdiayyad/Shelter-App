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
import 'package:shelter/views/common/common_ui.dart';
import 'package:shelter/views/tabs/clinics/ClinicProfile.dart';
import 'package:shelter/views/tabs/profile/customer_profile.dart';
import 'package:shelter/views/tabs/stores/StoreProfile.dart';

//*************************************************************************************/
//**************************************ShowProfileScreen*************************************/
//*************************************************************************************/
class ShowProfileScreen extends ConsumerWidget {
  const ShowProfileScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsPorvider(uid)).when(
        error: (msg) => Scaffold(body: Text(msg)),
        loading: () =>
            Scaffold(body: Center(child: CircularProgressIndicator())),
        data: (value) {
          var data = value.object?.data() ?? {};
          var store = StoreModel.fromJson(data);
          return Scaffold(
            floatingActionButton: EnumToString.fromString(
                        UserType.values, store.userType ?? '') !=
                    UserType.customer
                ? FloatingActionButton(
                    onPressed: () {
                      navgationManager.navigatePush(MapViewRoute(
                          lat: store.location?.first,
                          long: store.location?.last));
                    },
                    child: Icon(LineIcons.locationArrow, color: Colors.white),
                  )
                : null,
            backgroundColor: Colors.white,
            appBar: CommonUi.appbar(context, title: 'Profile'),
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
                            showEditButton: false,
                            uid: uid,
                          ),
                        ],
                      );

                    case UserType.store:
                      return StoreProfile(
                        storeModel: StoreModel.fromJson(data),
                        showEditButton: false,
                        uid: uid,
                      );
                    default:
                      return CustomerProfile(
                        customerModel: UserModel.fromJson(data),
                        showEditButton: false,
                        uid: uid,
                      );
                  }
                },
              ),
            ),
          );
        });
  }
}
