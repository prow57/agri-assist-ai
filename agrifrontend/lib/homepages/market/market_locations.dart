import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MarketLocation extends StatefulWidget {
  @override
  _MarketLocationState createState() => _MarketLocationState();
}

class _MarketLocationState extends State<MarketLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map of Malawi'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-13.2543, 34.3015), // Center on Malawi
          zoom: 6.0, // Set zoom level
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoicHJvdyIsImEiOiJjbTA2bGtwdDgwdHlmMmlzMjdzYnRvY250In0.Zk6PlpPy_A4lcceroLJM4g",
            additionalOptions: const {
              'accessToken':
                  'pk.eyJ1IjoicHJvdyIsImEiOiJjbTA2bGtwdDgwdHlmMmlzMjdzYnRvY250In0.Zk6PlpPy_A4lcceroLJM4g',
              'id': 'mapbox.mapbox-streets-v7',
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(-13.9626, 33.7741),
                builder: (ctx) => const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
              Marker(
                point: LatLng(-15.7861, 35.0058),
                builder: (ctx) => const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
