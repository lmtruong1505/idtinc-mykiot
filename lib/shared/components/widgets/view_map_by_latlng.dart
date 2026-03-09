import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../style_app/init_style.dart';

class ViewMapByLatLng extends StatelessWidget {
  final MapLatLng latLng;
  const ViewMapByLatLng({
    super.key,
    required this.latLng,
  });

  @override
  Widget build(BuildContext context) {
    
    return SfMaps(
      layers: [
        MapTileLayer(
          initialFocalLatLng: latLng,
          initialZoomLevel: 15,
          initialMarkersCount: 1,
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          markerBuilder: (BuildContext context, int index) {
            return MapMarker(
              latitude: latLng.latitude,
              longitude: latLng.longitude,
              size: const Size(20, 20),
              child: Container(
                //padding: Dimensions.sp8.pading,
                decoration: BoxDecoration(
                  color: ColorApp.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.circle,
                  size: 10,
                  color: ColorApp.teal,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
