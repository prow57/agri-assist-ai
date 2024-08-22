import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MarketLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Malawi Market Locations'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-13.2543, 34.3015),
          zoom: 7.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://api.mapbox.com/styles/v1/prow/clh9jmy6d001501qe6i8us3ep/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}",
            additionalOptions: {
              'access_token': 'pk.eyJ1IjoicHJvdyIsImEiOiJjbTA1MTFwOGIwZzVwMmlzZDUzNzh2YnRxIn0.lXsl2BkrTYO168oBeXUZgQ',
            },
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(-13.9626, 33.7741),
                builder: (ctx) => const Icon(
                  Icons.location_on,
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
