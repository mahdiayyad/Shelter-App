import 'package:auto_route/annotations.dart';
import 'package:shelter/views/HomeScreen.dart';
import 'package:shelter/views/ImagesFullViewScreen.dart';
import 'package:shelter/views/IntroductionScreen.dart';
import 'package:shelter/views/ShowProfileScreen.dart';
import 'package:shelter/views/auth/SelectionScreen.dart';
import 'package:shelter/views/SplashScreen.dart';
import 'package:shelter/views/auth/LoginScreen.dart';
import 'package:shelter/views/auth/RegistrationScreen.dart';
import 'package:shelter/views/auth/ResetScreen.dart';
import 'package:shelter/views/tabs/clinics/clinics_screen.dart';
import 'package:shelter/views/tabs/posts/add_post_screen.dart';
import 'package:shelter/views/tabs/posts/posts_screen.dart';
import 'package:shelter/views/tabs/profile/EditAccountScreen.dart';
import 'package:shelter/views/tabs/profile/MapViewScreen.dart';
import 'package:shelter/views/tabs/profile/profile_screen.dart';
import 'package:shelter/views/tabs/stores/add_store_item_screen.dart';
import 'package:shelter/views/tabs/stores/add_store_item_selection.dart';
import 'package:shelter/views/tabs/stores/add_store_pet_screen.dart';
import 'package:shelter/views/tabs/stores/stores_screen.dart';

//cmd  flutter packages pub run build_runner build --delete-conflicting-outputs

//*************************************************************************************/
//**************************************AppRouter**************************************/
//*************************************************************************************/

/// Routing for screens
@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashScreen, initial: true),
    AutoRoute(page: IntroScreen),
    AutoRoute(page: SelectionScreen),
    AutoRoute(page: RegistrationScreen),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: ResetScreen),
    AutoRoute(page: AddPostScreen),
    AutoRoute(page: AddStorePetScreen),
    AutoRoute(page: AddStoreItemScreen),
    AutoRoute(page: EditAccountScreen),
    AutoRoute(page: MapViewScreen),
    AutoRoute(page: ShowProfileScreen),
    AutoRoute(page: AddStoreItemSelection),
    AutoRoute(page: ImageFullViewScreen),
    AutoRoute(page: HomeScreen, children: [
      AutoRoute(page: PostsScreen),
      AutoRoute(page: ClinicsScreen),
      AutoRoute(page: StoresScreen),
      AutoRoute(page: ProfileScreen),
    ]),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $AppRouter {}
