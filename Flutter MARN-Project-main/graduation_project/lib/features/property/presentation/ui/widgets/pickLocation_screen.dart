import 'package:MARN/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:MARN/features/property/presentation/ui/models/property_form_state.dart';

class PickLocationScreen extends StatefulWidget {
  final PropertyFormState property;
  const PickLocationScreen({super.key, required this.property});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  late LatLng selected;

  @override
  void initState() {
    super.initState();
    if (widget.property.latitude != null && widget.property.longitude != null) {
      selected = LatLng(
        widget.property.latitude!.toDouble(),
        widget.property.longitude!.toDouble(),
      );
    } else {
      selected = const LatLng(30.0444, 31.2357);
    }
  }

  void onMapTap(TapPosition tap, LatLng point) {
    setState(() {
      selected = point;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: selected,
          initialZoom: 13,
          onTap: onMapTap,
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
                point: selected,
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
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selected);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.check),
      ),
    );
  }
}
