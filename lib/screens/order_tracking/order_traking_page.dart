import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_mao/constants.dart';
import 'package:google_mao/screens/order_tracking/order_tracking_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderTrackingController>(
      init: OrderTrackingController(),
      builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Track order",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: controller.currentLocation == null
            ? const Center(
                child: Text('Loading'),
              )
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      controller.currentLocation!.latitude!, controller.currentLocation!.longitude!),
                  zoom: 15.5,
                ),
                onMapCreated: (mapController) {
                  controller.completer.complete(mapController);
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("route"),
                    points:controller. polylineCoordinates,
                    color: primaryColor,
                    width: 6,
                  )
                },
                markers: {
                  Marker(
                    icon: controller.currentLocationIcon,
                    markerId: const MarkerId('currentLocation'),
                    position: LatLng(controller.currentLocation!.latitude!,
                        controller.currentLocation!.longitude!),
                  ),
                  Marker(
                    icon: controller.sourceIcon,
                    markerId: const MarkerId('source'),
                    position: controller.sourceLocation,
                  ),
                  Marker(
                    icon: controller.destinationIcon,
                    markerId: const MarkerId('desination'),
                    position: controller.destination,
                  ),
                },
              ),
      );
    });
  }
}
