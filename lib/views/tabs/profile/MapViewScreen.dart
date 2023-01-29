import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelter/models/StoreModel.dart';
import 'package:shelter/providers/posts_provider.dart';
import 'package:shelter/views/common/common_ui.dart';

//*************************************************************************************/
//**************************************MapViewScreen**********************************/
//*************************************************************************************/

class MapViewScreen extends ConsumerWidget {
  const MapViewScreen({Key? key, required this.lat, required this.long})
      : super(key: key);
  final double lat;
  final double long;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CommonUi.appbar(context, bcColor: Colors.transparent),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ref.read(clinicsAndStoreRefPovider).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                var docs = snapshot.data?.docs ?? [];
                return GoogleMap(
                  markers: Set<Marker>.of(
                    docs.map((doc) {
                      StoreModel store = StoreModel.fromJson(doc.data());
                      return Marker(
                        markerId: MarkerId(store.name ?? ''),
                        position:
                            LatLng(store.location?.first, store.location?.last),
                      );
                    }),
                  ),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, long),
                    zoom: 12,
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
