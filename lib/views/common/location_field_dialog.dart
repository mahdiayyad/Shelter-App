import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//*************************************************************************************/
//**************************************location_field_dialog**************************/
//*************************************************************************************/

class LocationFieldDialog extends StatefulWidget {
  final CameraPosition? initialCameraPosition;
  final IconData? markerIcon;
  final double? markerIconSize;
  final Color? markerIconColor;
  final MapType? mapType;
  final bool? myLocationButtonEnabled;
  final bool? myLocationEnabled;
  final bool? zoomGesturesEnabled;
  final Set<Marker>? markers;
  final void Function(LatLng)? onTap;
  final EdgeInsets? padding;
  final bool? buildingsEnabled;
  final CameraTargetBounds? cameraTargetBounds;
  final Set<Circle>? circles;
  final bool? compassEnabled;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
  final bool? indoorViewEnabled;
  final bool? mapToolbarEnabled;
  final MinMaxZoomPreference? minMaxZoomPreference;
  final void Function()? onCameraIdle;
  final void Function()? onCameraMoveStarted;
  final void Function(LatLng)? onLongPress;
  final Set<Polygon>? polygons;
  final Set<Polyline>? polylines;
  final bool? rotateGesturesEnabled;
  final bool? scrollGesturesEnabled;
  final bool? tiltGesturesEnabled;
  final bool? trafficEnabled;
  final bool? zoomControlsEnabled;
  final bool? liteModeEnabled;
  final CameraPositionCallback? onCameraMove;
  final MapCreatedCallback? onMapCreated;

  const LocationFieldDialog({
    Key? key,
    this.initialCameraPosition,
    this.mapType,
    this.markerIcon,
    this.markerIconSize,
    this.markerIconColor,
    this.myLocationButtonEnabled,
    this.myLocationEnabled,
    this.zoomGesturesEnabled,
    this.markers,
    this.onTap,
    this.padding,
    this.buildingsEnabled,
    this.cameraTargetBounds,
    this.circles,
    this.compassEnabled,
    this.gestureRecognizers,
    this.indoorViewEnabled,
    this.mapToolbarEnabled,
    this.minMaxZoomPreference,
    this.onCameraIdle,
    this.onCameraMoveStarted,
    this.onLongPress,
    this.polygons,
    this.polylines,
    this.rotateGesturesEnabled,
    this.scrollGesturesEnabled,
    this.tiltGesturesEnabled,
    this.trafficEnabled,
    this.zoomControlsEnabled,
    this.liteModeEnabled,
    this.onCameraMove,
    this.onMapCreated,
  }) : super(key: key);

  @override
  _LocationFieldDialogState createState() => _LocationFieldDialogState();
}

class _LocationFieldDialogState extends State<LocationFieldDialog> {
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  CameraPosition? _value;
  late CameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = widget.initialCameraPosition ??
        CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        );
    _value = _initialCameraPosition;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check, color: Colors.white),
        onPressed: () => Navigator.pop(context, _value),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.biggest.width;
          final maxHeight = constraints.biggest.height;

          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                height: maxHeight,
                width: maxWidth,
                child: GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controllerCompleter.isCompleted) {
                      _controllerCompleter.complete(controller);
                    }
                    widget.onMapCreated?.call(controller);
                  },
                  onCameraMove: (CameraPosition newPosition) {
                    _value = newPosition;
                    widget.onCameraMove?.call(newPosition);
                  },
                  mapType: widget.mapType ?? MapType.normal,
                  myLocationButtonEnabled:
                      widget.myLocationButtonEnabled ?? true,
                  myLocationEnabled: widget.myLocationEnabled ?? false,
                  zoomGesturesEnabled: widget.zoomGesturesEnabled ?? true,
                  markers: widget.markers ?? <Marker>{},
                  onTap: widget.onTap,
                  padding: widget.padding ?? const EdgeInsets.all(0),
                  buildingsEnabled: widget.buildingsEnabled ?? true,
                  cameraTargetBounds:
                      widget.cameraTargetBounds ?? CameraTargetBounds.unbounded,
                  circles: widget.circles ?? const <Circle>{},
                  compassEnabled: widget.compassEnabled ?? true,
                  gestureRecognizers: widget.gestureRecognizers ??
                      const <Factory<OneSequenceGestureRecognizer>>{},
                  indoorViewEnabled: widget.indoorViewEnabled ?? false,
                  mapToolbarEnabled: widget.mapToolbarEnabled ?? true,
                  minMaxZoomPreference: widget.minMaxZoomPreference ??
                      MinMaxZoomPreference.unbounded,
                  onCameraIdle: widget.onCameraIdle,
                  onCameraMoveStarted: widget.onCameraMoveStarted,
                  onLongPress: widget.onLongPress,
                  polygons: widget.polygons ?? const <Polygon>{},
                  polylines: widget.polylines ?? const <Polyline>{},
                  rotateGesturesEnabled: widget.rotateGesturesEnabled ?? true,
                  scrollGesturesEnabled: widget.scrollGesturesEnabled ?? true,
                  tiltGesturesEnabled: widget.tiltGesturesEnabled ?? true,
                  trafficEnabled: widget.trafficEnabled ?? false,
                  liteModeEnabled: widget.liteModeEnabled ?? false,
                  zoomControlsEnabled: widget.zoomControlsEnabled ?? true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      child: Icon(
                        Icons.close,
                        color: theme.textTheme.bodyText1?.color,
                      ),
                      onPressed: () => Navigator.pop(context),
                      mini: true,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: maxHeight / 2,
                right: (maxWidth - (widget.markerIconSize ?? 16)) / 2,
                child: Container(
                  // key: Key(),
                  child: Icon(
                    widget.markerIcon,
                    size: widget.markerIconSize,
                    color: widget.markerIconColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
