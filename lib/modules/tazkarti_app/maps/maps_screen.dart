import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StadiumLocationScreen extends StatefulWidget {

  final double latitude;
  final double longitude;

  const StadiumLocationScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);


  @override
  _MyAppState createState() => _MyAppState(latitude, longitude);
}

class _MyAppState extends State<StadiumLocationScreen> {

  late double latitude;
  late double longitude;

  _MyAppState(this.latitude,this.longitude);

  late GoogleMapController mapController;


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final LatLng stdLocation =  LatLng(latitude, longitude);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],

        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: MapType.terrain,
          // compassEnabled: true,
          // scrollGesturesEnabled: true,
          // tiltGesturesEnabled: true,
          // rotateGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: stdLocation,
            zoom: 17,
          ),
        ),
      ),
    );
  }

}
