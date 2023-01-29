import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'helpers/GenNotifier.dart';
import 'helpers/GenState.dart';

//*************************************************************************************/
//************************************Providers****************************************/
//*************************************************************************************/

/// Gets the data of the post by collection ordered by the time where isApproved = true
final postsRefPovider = StateProvider<Query<Map<String, dynamic>>>((ref) {
  var resRef = FirebaseFirestore.instance
      .collection("posts")
      .orderBy("timestamp", descending: true)
      .where("is_approved", isEqualTo: true);
  return resRef;
});

/// Gets the data of the clinics by collection ordered by the name
final clinicsRefPovider = StateProvider<Query<Map<String, dynamic>>>((ref) {
  var resRef = FirebaseFirestore.instance
      .collection("users")
      .orderBy("name", descending: true)
      .where("is_approved", isEqualTo: true)
      .where("userType", isEqualTo: 'clinic');
  return resRef;
});

/// Gets the data of the clinics and stores by collections ordered where isApproved = true
final clinicsAndStoreRefPovider =
    StateProvider<Query<Map<String, dynamic>>>((ref) {
  var resRef = FirebaseFirestore.instance
      .collection("users")
      .where("userType", isNotEqualTo: 'customer')
      .where("is_approved", isEqualTo: true);
  return resRef;
});

/// Gets the data of the clinics and stores by collections ordered where isApproved = true
final itemsRefPovider = StateProvider<Query<Map<String, dynamic>>>((ref) {
  var resRef = FirebaseFirestore.instance
      .collection("items")
      .orderBy("timestamp", descending: true)
      .where("is_approved", isEqualTo: true);
  return resRef;
});

final petsRefPovider = StateProvider<Query<Map<String, dynamic>>>((ref) {
  var resRef = FirebaseFirestore.instance
      .collection("pets")
      .orderBy("timestamp", descending: true)
      .where("is_approved", isEqualTo: true);
  return resRef;
});

final itemsRefUidPovider =
    StateProvider.family<Query<Map<String, dynamic>>, String?>((ref, uid) {
  var resRef = FirebaseFirestore.instance
      .collection("items")
      .orderBy("timestamp", descending: true)
      .where("is_approved", isEqualTo: true)
      .where("userId", isEqualTo: uid ?? FirebaseAuth.instance.currentUser?.uid);
  return resRef;
});

final postsRefUidPovider =
    StateProvider.family<Query<Map<String, dynamic>>, String?>((ref, uid) {
  var resRef = FirebaseFirestore.instance
      .collection("posts")
      .orderBy("timestamp", descending: true)
      .where("is_approved", isEqualTo: true)
      .where("userId", isEqualTo: uid ?? FirebaseAuth.instance.currentUser?.uid);
  return resRef;
});

/// Gets the data of the posts by collection ordered by the time where isApproved = true
final petsRefUidPovider =
    StateProvider.family<Query<Map<String, dynamic>>, String?>((ref, uid) {
  var resRef = FirebaseFirestore.instance
      .collection("pets")
      .orderBy("timestamp", descending: true)
      .where("is_approved", isEqualTo: true)
      .where("userId", isEqualTo: uid ?? FirebaseAuth.instance.currentUser?.uid);
  return resRef;
});

/// gets the details of the user by [uid]
final userDetailsPorvider = StateNotifierProvider.family.autoDispose<
    GenNotifier<GenState<DocumentSnapshot<Map<String, dynamic>>>>,
    GenState<DocumentSnapshot<Map<String, dynamic>>>,
    String>((ref, uid) {
  return GenNotifier<GenState<DocumentSnapshot<Map<String, dynamic>>>>(
      GenState<DocumentSnapshot<Map<String, dynamic>>>(), (notifier) {
    notifier.setState(GenState<DocumentSnapshot<Map<String, dynamic>>>());
    var resRef = FirebaseFirestore.instance.collection("users").doc(uid);
    resRef.get().catchError((error, stackTrace) {
      notifier.setState(GenState<DocumentSnapshot<Map<String, dynamic>>>(
          isloading: false, errorMsg: error.toString()));
    }).then((value) {
      notifier.setState(GenState<DocumentSnapshot<Map<String, dynamic>>>(
          isloading: false, object: value));
    });
  });
});

final profileDetailsStreamProvider =
    StateProvider<DocumentReference<Map<String, dynamic>>>((ref) {
  var resRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid);
  return resRef;
});
