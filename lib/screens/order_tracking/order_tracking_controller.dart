import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../constants.dart';

class OrderTrackingController extends GetxController {
  @override
  void onInit() {
    getCurrentLocation();
    setCustomMarkerIcon();
    getPolylinePoint();
    super.onInit();
  }

  final Completer<GoogleMapController> completer = Completer();

  LatLng sourceLocation = const LatLng(37.4221, -122.0841);
  LatLng destination = const LatLng(37.4116, -122.0713);

  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
      update();
    });

    GoogleMapController mapController = await completer.future;

    location.onLocationChanged.listen((newLocation) {
      currentLocation = newLocation;
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 15.5,
            target: LatLng(
              newLocation.latitude!,
              newLocation.longitude!,
            ),
          ),
        ),
      );
      update();
    });

    update();
  }

  List<LatLng> polylineCoordinates = [];

  void getPolylinePoint() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (polylineResult.points.isNotEmpty) {
      polylineResult.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );

      update();
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/Pin_source.png')
        .then((icon) {
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/Pin_destination.png')
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/Pin_current_location.png')
        .then((icon) {
      currentLocationIcon = icon;
    });
  }
}
