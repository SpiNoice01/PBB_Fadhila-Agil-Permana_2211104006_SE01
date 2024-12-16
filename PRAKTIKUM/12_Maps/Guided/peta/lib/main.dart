import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  static const LatLng _kMapCenter = LatLng(-17.535000, -149.569595);
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: _kMapCenter,
    zoom: 11.0,
  );

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Maps Demo'),
          centerTitle: true,
        ),
        body: const GoogleMap(
          initialCameraPosition: _kInitialPosition,
          myLocationEnabled: true,
          mapType: MapType.normal, 
        ),
      ),
    );
  }
}
