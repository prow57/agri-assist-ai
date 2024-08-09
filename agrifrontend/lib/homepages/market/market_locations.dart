import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class YourExistingPage extends StatefulWidget {
  @override
  _YourExistingPageState createState() => _YourExistingPageState();
}

class _YourExistingPageState extends State<YourExistingPage> {
  GoogleMapController? _controller;

  final LatLng _initialPosition = LatLng(-33.865143, 151.209900);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Page with Map'),
      ),
      body: Column(
        children: [
          // Other widgets can be added here
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 12,
              ),
              onMapCreated: (controller) {
                setState(() {
                  _controller = controller;
                });
              },
              markers: {
                Marker(
                  markerId: MarkerId('market1'),
                  position: LatLng(-33.868820, 151.209296),
                  infoWindow: InfoWindow(title: 'Market 1'),
                ),
                // Add more markers here
              },
            ),
          ),
          // Other widgets below the map can be added here
        ],
      ),
    );
  }
}
