import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ShowMap extends StatelessWidget {
  final MapController mapController;
  final LatLng selectedLocation;
  final bool interactive;
  const ShowMap({
    super.key,
    required this.mapController,
    required this.selectedLocation,
    this.interactive = false,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: selectedLocation,
        initialZoom: 13,
        interactionOptions: InteractionOptions(
          flags: interactive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c', 'd'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: selectedLocation,
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
