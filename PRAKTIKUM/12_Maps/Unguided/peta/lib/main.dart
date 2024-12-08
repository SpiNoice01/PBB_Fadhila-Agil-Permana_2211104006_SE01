import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late GoogleMapController _mapController;
  MapType _mapType = MapType.normal;
  CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(-17.535000, -149.569595),
    zoom: 11.0,
  );
  // ignore: unused_field
  LatLng _lastMapPosition = const LatLng(-17.535000, -149.569595);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Demo'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              setState(() {
                _mapType = _mapType == MapType.normal
                    ? MapType.satellite
                    : MapType.normal;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_searching),
            onPressed: () {
              _handlePressButton();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: _mapType,
            initialCameraPosition: _cameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onCameraMove: (CameraPosition position) {
              _lastMapPosition = position.target;
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handlePressButton() async {
    final LatLng latLng = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Place Picker')),
          body: const Center(child: Text('Place Picker Placeholder')),
        ),
      ),
    );

    setState(() {
      _cameraPosition = CameraPosition(
        target: latLng,
        zoom: 11.0,
      );
    });
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }
}
