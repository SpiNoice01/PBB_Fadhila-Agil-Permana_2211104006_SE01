import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final LatLng _kMapCenter = LatLng(-17.535000, -149.569595);
  static final CameraPosition _kInitialPosition = CameraPosition(
    target: _kMapCenter,
    zoom: 11.0,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Google Maps Demo'),
          centerTitle: true,
        ),
        body: GoogleMap(
          initialCameraPosition: _kInitialPosition,
          myLocationEnabled: true,
          mapType: MapType.normal, 
        ),
      ),
    );
  }
}
