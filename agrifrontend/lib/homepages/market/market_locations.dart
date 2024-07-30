import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarketLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Locations'),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0), // Set the initial map location
          zoom: 10,
        ),
        markers: {
          Marker(
            markerId: MarkerId('market1'),
            position: LatLng(0, 0), // Replace with actual market location
            infoWindow: InfoWindow(title: 'Market 1'),
          ),
          // Add more markers here
        },
      ),
    );
  }
}
