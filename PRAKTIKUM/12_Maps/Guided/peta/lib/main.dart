import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final LatLng _kMapCenter = LatLng(-17.535000, -149.569595);
  static final CameraPosition _kInitialPosition = CameraPosition(
    target: _kMapCenter,
    zoom: 11.0,
  );

  GoogleMapController? _mapController;

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
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          mapType: MapType.normal,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
