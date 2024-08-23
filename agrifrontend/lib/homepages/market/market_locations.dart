import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map of Malawi'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-13.2543, 34.3015), // Center on Malawi
          zoom: 6.0, // Set zoom level
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoicHJvdyIsImEiOiJjbTA2bGtwdDgwdHlmMmlzMjdzYnRvY250In0.Zk6PlpPy_A4lcceroLJM4g",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoicHJvdyIsImEiOiJjbTA2bGtwdDgwdHlmMmlzMjdzYnRvY250In0.Zk6PlpPy_A4lcceroLJM4g',
              'id': 'mapbox.mapbox-streets-v7'
            },
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(-13.9626, 33.7741),
                builder: (ctx) => Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(-15.7861, 35.0058),
                builder: (ctx) => Icon(
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
