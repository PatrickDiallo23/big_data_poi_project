import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> controller1 = Completer();
  String json =
      '[{"featureType": "poi","stylers": [{"visibility": "off"}]}, {"featureType": "transit", "stylers": [{"visibility": "off"}]}]';
  Position currentPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition().then((value) {
      setState(() {
        currentPosition = value;
      });

      if (kDebugMode) {
        print("${currentPosition.longitude} ${currentPosition.latitude}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    LatLng myPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
    return Scaffold(
      appBar: AppBar(
        title: const Text('POI app'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search))
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                controller1.complete(controller);
                controller.setMapStyle(json);
              },
              initialCameraPosition: CameraPosition(target: myPosition, zoom: 5),
              markers: {
                Marker(markerId: const MarkerId('demo'), position: myPosition, draggable: false),
              },
              myLocationButtonEnabled: false,
              buildingsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoogleMapController controller = await controller1.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(currentPosition.latitude, currentPosition.longitude), zoom: 17)));
          if (kDebugMode) {
            print('moved');
          }
        },
        child: const Icon(Icons.near_me),
      ),
    );
  }
}
