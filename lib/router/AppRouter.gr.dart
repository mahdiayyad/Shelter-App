// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i20;
import 'package:cloud_firestore/cloud_firestore.dart' as _i23;
import 'package:flutter/material.dart' as _i21;

import '../models/PostModel.dart' as _i22;
import '../models/StoreItemModel.dart' as _i25;
import '../models/StorePetModel.dart' as _i24;
import '../views/auth/LoginScreen.dart' as _i5;
import '../views/auth/RegistrationScreen.dart' as _i4;
import '../views/auth/ResetScreen.dart' as _i6;
import '../views/auth/SelectionScreen.dart' as _i3;
import '../views/HomeScreen.dart' as _i15;
import '../views/ImagesFullViewScreen.dart' as _i14;
import '../views/IntroductionScreen.dart' as _i2;
import '../views/ShowProfileScreen.dart' as _i12;
import '../views/SplashScreen.dart' as _i1;
import '../views/tabs/clinics/clinics_screen.dart' as _i17;
import '../views/tabs/posts/add_post_screen.dart' as _i7;
import '../views/tabs/posts/posts_screen.dart' as _i16;
import '../views/tabs/profile/EditAccountScreen.dart' as _i10;
import '../views/tabs/profile/MapViewScreen.dart' as _i11;
import '../views/tabs/profile/profile_screen.dart' as _i19;
import '../views/tabs/stores/add_store_item_screen.dart' as _i9;
import '../views/tabs/stores/add_store_item_selection.dart' as _i13;
import '../views/tabs/stores/add_store_pet_screen.dart' as _i8;
import '../views/tabs/stores/stores_screen.dart' as _i18;

class AppRouter extends _i20.RootStackRouter {
  AppRouter([_i21.GlobalKey<_i21.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i20.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.SplashScreen());
    },
    IntroRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: _i2.IntroScreen());
    },
    SelectionRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.SelectionScreen());
    },
    RegistrationRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.RegistrationScreen());
    },
    LoginRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.LoginScreen());
    },
    ResetRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.ResetScreen());
    },
    AddPostRoute.name: (routeData) {
      final args = routeData.argsAs<AddPostRouteArgs>(
          orElse: () => const AddPostRouteArgs());
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.AddPostScreen(
              isEdit: args.isEdit,
              key: args.key,
              initData: args.initData,
              postRef: args.postRef));
    },
    AddStorePetRoute.name: (routeData) {
      final args = routeData.argsAs<AddStorePetRouteArgs>(
          orElse: () => const AddStorePetRouteArgs());
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i8.AddStorePetScreen(
              isEdit: args.isEdit,
              key: args.key,
              initData: args.initData,
              petRef: args.petRef));
    },
    AddStoreItemRoute.name: (routeData) {
      final args = routeData.argsAs<AddStoreItemRouteArgs>(
          orElse: () => const AddStoreItemRouteArgs());
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.AddStoreItemScreen(
              isEdit: args.isEdit,
              key: args.key,
              initData: args.initData,
              itemRef: args.itemRef));
    },
    EditAccountRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.EditAccountScreen());
    },
    MapViewRoute.name: (routeData) {
      final args = routeData.argsAs<MapViewRouteArgs>();
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i11.MapViewScreen(
              key: args.key, lat: args.lat, long: args.long));
    },
    ShowProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ShowProfileRouteArgs>();
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i12.ShowProfileScreen(key: args.key, uid: args.uid));
    },
    AddStoreItemSelection.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i13.AddStoreItemSelection());
    },
    ImageFullViewRoute.name: (routeData) {
      final args = routeData.argsAs<ImageFullViewRouteArgs>();
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i14.ImageFullViewScreen(key: args.key, url: args.url));
    },
    HomeRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i15.HomeScreen());
    },
    PostsRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i16.PostsScreen());
    },
    ClinicsRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i17.ClinicsScreen());
    },
    StoresRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i18.StoresScreen());
    },
    ProfileRoute.name: (routeData) {
      return _i20.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i19.ProfileScreen());
    }
  };

  @override
  List<_i20.RouteConfig> get routes => [
        _i20.RouteConfig(SplashRoute.name, path: '/'),
        _i20.RouteConfig(IntroRoute.name, path: '/intro-screen'),
        _i20.RouteConfig(SelectionRoute.name, path: '/selection-screen'),
        _i20.RouteConfig(RegistrationRoute.name, path: '/registration-screen'),
        _i20.RouteConfig(LoginRoute.name, path: '/login-screen'),
        _i20.RouteConfig(ResetRoute.name, path: '/reset-screen'),
        _i20.RouteConfig(AddPostRoute.name, path: '/add-post-screen'),
        _i20.RouteConfig(AddStorePetRoute.name, path: '/add-store-pet-screen'),
        _i20.RouteConfig(AddStoreItemRoute.name,
            path: '/add-store-item-screen'),
        _i20.RouteConfig(EditAccountRoute.name, path: '/edit-account-screen'),
        _i20.RouteConfig(MapViewRoute.name, path: '/map-view-screen'),
        _i20.RouteConfig(ShowProfileRoute.name, path: '/show-profile-screen'),
        _i20.RouteConfig(AddStoreItemSelection.name,
            path: '/add-store-item-selection'),
        _i20.RouteConfig(ImageFullViewRoute.name,
            path: '/image-full-view-screen'),
        _i20.RouteConfig(HomeRoute.name, path: '/home-screen', children: [
          _i20.RouteConfig(PostsRoute.name,
              path: 'posts-screen', parent: HomeRoute.name),
          _i20.RouteConfig(ClinicsRoute.name,
              path: 'clinics-screen', parent: HomeRoute.name),
          _i20.RouteConfig(StoresRoute.name,
              path: 'stores-screen', parent: HomeRoute.name),
          _i20.RouteConfig(ProfileRoute.name,
              path: 'profile-screen', parent: HomeRoute.name)
        ]),
        _i20.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashRoute extends _i20.PageRouteInfo<void> {
  const SplashRoute() : super(SplashRoute.name, path: '/');

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.IntroScreen]
class IntroRoute extends _i20.PageRouteInfo<void> {
  const IntroRoute() : super(IntroRoute.name, path: '/intro-screen');

  static const String name = 'IntroRoute';
}

/// generated route for
/// [_i3.SelectionScreen]
class SelectionRoute extends _i20.PageRouteInfo<void> {
  const SelectionRoute()
      : super(SelectionRoute.name, path: '/selection-screen');

  static const String name = 'SelectionRoute';
}

/// generated route for
/// [_i4.RegistrationScreen]
class RegistrationRoute extends _i20.PageRouteInfo<void> {
  const RegistrationRoute()
      : super(RegistrationRoute.name, path: '/registration-screen');

  static const String name = 'RegistrationRoute';
}

/// generated route for
/// [_i5.LoginScreen]
class LoginRoute extends _i20.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/login-screen');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i6.ResetScreen]
class ResetRoute extends _i20.PageRouteInfo<void> {
  const ResetRoute() : super(ResetRoute.name, path: '/reset-screen');

  static const String name = 'ResetRoute';
}

/// generated route for
/// [_i7.AddPostScreen]
class AddPostRoute extends _i20.PageRouteInfo<AddPostRouteArgs> {
  AddPostRoute(
      {bool isEdit = false,
      _i21.Key? key,
      _i22.PostModel? initData,
      _i23.DocumentReference<Object?>? postRef})
      : super(AddPostRoute.name,
            path: '/add-post-screen',
            args: AddPostRouteArgs(
                isEdit: isEdit,
                key: key,
                initData: initData,
                postRef: postRef));

  static const String name = 'AddPostRoute';
}

class AddPostRouteArgs {
  const AddPostRouteArgs(
      {this.isEdit = false, this.key, this.initData, this.postRef});

  final bool isEdit;

  final _i21.Key? key;

  final _i22.PostModel? initData;

  final _i23.DocumentReference<Object?>? postRef;

  @override
  String toString() {
    return 'AddPostRouteArgs{isEdit: $isEdit, key: $key, initData: $initData, postRef: $postRef}';
  }
}

/// generated route for
/// [_i8.AddStorePetScreen]
class AddStorePetRoute extends _i20.PageRouteInfo<AddStorePetRouteArgs> {
  AddStorePetRoute(
      {bool isEdit = false,
      _i21.Key? key,
      _i24.StorePetModel? initData,
      _i23.DocumentReference<Object?>? petRef})
      : super(AddStorePetRoute.name,
            path: '/add-store-pet-screen',
            args: AddStorePetRouteArgs(
                isEdit: isEdit, key: key, initData: initData, petRef: petRef));

  static const String name = 'AddStorePetRoute';
}

class AddStorePetRouteArgs {
  const AddStorePetRouteArgs(
      {this.isEdit = false, this.key, this.initData, this.petRef});

  final bool isEdit;

  final _i21.Key? key;

  final _i24.StorePetModel? initData;

  final _i23.DocumentReference<Object?>? petRef;

  @override
  String toString() {
    return 'AddStorePetRouteArgs{isEdit: $isEdit, key: $key, initData: $initData, petRef: $petRef}';
  }
}

/// generated route for
/// [_i9.AddStoreItemScreen]
class AddStoreItemRoute extends _i20.PageRouteInfo<AddStoreItemRouteArgs> {
  AddStoreItemRoute(
      {bool isEdit = false,
      _i21.Key? key,
      _i25.StoreItemModel? initData,
      _i23.DocumentReference<Object?>? itemRef})
      : super(AddStoreItemRoute.name,
            path: '/add-store-item-screen',
            args: AddStoreItemRouteArgs(
                isEdit: isEdit,
                key: key,
                initData: initData,
                itemRef: itemRef));

  static const String name = 'AddStoreItemRoute';
}

class AddStoreItemRouteArgs {
  const AddStoreItemRouteArgs(
      {this.isEdit = false, this.key, this.initData, this.itemRef});

  final bool isEdit;

  final _i21.Key? key;

  final _i25.StoreItemModel? initData;

  final _i23.DocumentReference<Object?>? itemRef;

  @override
  String toString() {
    return 'AddStoreItemRouteArgs{isEdit: $isEdit, key: $key, initData: $initData, itemRef: $itemRef}';
  }
}

/// generated route for
/// [_i10.EditAccountScreen]
class EditAccountRoute extends _i20.PageRouteInfo<void> {
  const EditAccountRoute()
      : super(EditAccountRoute.name, path: '/edit-account-screen');

  static const String name = 'EditAccountRoute';
}

/// generated route for
/// [_i11.MapViewScreen]
class MapViewRoute extends _i20.PageRouteInfo<MapViewRouteArgs> {
  MapViewRoute({_i21.Key? key, required double lat, required double long})
      : super(MapViewRoute.name,
            path: '/map-view-screen',
            args: MapViewRouteArgs(key: key, lat: lat, long: long));

  static const String name = 'MapViewRoute';
}

class MapViewRouteArgs {
  const MapViewRouteArgs({this.key, required this.lat, required this.long});

  final _i21.Key? key;

  final double lat;

  final double long;

  @override
  String toString() {
    return 'MapViewRouteArgs{key: $key, lat: $lat, long: $long}';
  }
}

/// generated route for
/// [_i12.ShowProfileScreen]
class ShowProfileRoute extends _i20.PageRouteInfo<ShowProfileRouteArgs> {
  ShowProfileRoute({_i21.Key? key, required String uid})
      : super(ShowProfileRoute.name,
            path: '/show-profile-screen',
            args: ShowProfileRouteArgs(key: key, uid: uid));

  static const String name = 'ShowProfileRoute';
}

class ShowProfileRouteArgs {
  const ShowProfileRouteArgs({this.key, required this.uid});

  final _i21.Key? key;

  final String uid;

  @override
  String toString() {
    return 'ShowProfileRouteArgs{key: $key, uid: $uid}';
  }
}

/// generated route for
/// [_i13.AddStoreItemSelection]
class AddStoreItemSelection extends _i20.PageRouteInfo<void> {
  const AddStoreItemSelection()
      : super(AddStoreItemSelection.name, path: '/add-store-item-selection');

  static const String name = 'AddStoreItemSelection';
}

/// generated route for
/// [_i14.ImageFullViewScreen]
class ImageFullViewRoute extends _i20.PageRouteInfo<ImageFullViewRouteArgs> {
  ImageFullViewRoute({_i21.Key? key, required String url, int? index})
      : super(ImageFullViewRoute.name,
            path: '/image-full-view-screen',
            args: ImageFullViewRouteArgs(key: key, url: url, index: index));

  static const String name = 'ImageFullViewRoute';
}

class ImageFullViewRouteArgs {
  const ImageFullViewRouteArgs({this.key, required this.url, this.index});

  final _i21.Key? key;

  final String url;

  final int? index;

  @override
  String toString() {
    return 'ImageFullViewRouteArgs{key: $key, url: $url, index: $index}';
  }
}

/// generated route for
/// [_i15.HomeScreen]
class HomeRoute extends _i20.PageRouteInfo<void> {
  const HomeRoute({List<_i20.PageRouteInfo>? children})
      : super(HomeRoute.name, path: '/home-screen', initialChildren: children);

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i16.PostsScreen]
class PostsRoute extends _i20.PageRouteInfo<void> {
  const PostsRoute() : super(PostsRoute.name, path: 'posts-screen');

  static const String name = 'PostsRoute';
}

/// generated route for
/// [_i17.ClinicsScreen]
class ClinicsRoute extends _i20.PageRouteInfo<void> {
  const ClinicsRoute() : super(ClinicsRoute.name, path: 'clinics-screen');

  static const String name = 'ClinicsRoute';
}

/// generated route for
/// [_i18.StoresScreen]
class StoresRoute extends _i20.PageRouteInfo<void> {
  const StoresRoute() : super(StoresRoute.name, path: 'stores-screen');

  static const String name = 'StoresRoute';
}

/// generated route for
/// [_i19.ProfileScreen]
class ProfileRoute extends _i20.PageRouteInfo<void> {
  const ProfileRoute() : super(ProfileRoute.name, path: 'profile-screen');

  static const String name = 'ProfileRoute';
}
