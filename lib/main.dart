import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:maps_launcher/maps_launcher.dart';

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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> controller1 = Completer<GoogleMapController>();
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
  Position demoPosition = Position(
      longitude: 26.036140,
      latitude: 44.414230,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);
  List<Marker> myPois = [];
  double myRating = 3.5;
  bool selected1 = false;
  bool selected2 = false;
  bool selected3 = false;
  double radius = 0.5;
  dynamic openNow;
  List<String> categories = [];
  String selectedCategory = "";

  void getCategories() async {
    const url = 'http://localhost:8000/pois/get-categories';
    try {
      final response = await http.get(Uri.parse(url));
      final jsonData = jsonDecode(response.body) as List;
      if (kDebugMode) {
        print('getCategories is called');
        print(jsonData);
        print(jsonData.length);
        print('a mers?');
      }
      for (int i = 0; i < jsonData.length; i++) {
        setState(() {
          categories.add(jsonData[i]['category']!.toString());
        });
      }
      if (kDebugMode) {
        print(categories);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    if (kDebugMode) {
      print("\n\n\n");
    }
  }

  Future<Map<dynamic, dynamic>> getPoiInfo(double lat, double long) async {
    const url = 'http://localhost:8000/pois/get-poi-info';

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode({"latitude": lat, "longitude": long}));
      final json = jsonDecode(response.body) as Map<dynamic, dynamic>;
      if (kDebugMode) {
        print('getPoiInfo() is called');
        print(json);
        print("\n\n\n");
      }
      return json;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return {};
    }
  }

  void getPois(double lat, double long, double radius, dynamic open, List categories, double rating) async {
    const url = 'http://localhost:8000/pois/get-pois';

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode({
            "latitude": lat,
            "longitude": long,
            "radius": radius,
            "open_now": open,
            "categories": categories,
            "rating": rating
          }));

      final pois2 = jsonDecode(response.body) as List;
      if (kDebugMode) {
        print('\n/n');
        print('\n/n');
        print('\n/n');
        print(pois2);
        print(pois2.length);
      }

      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        "assets/map-pin.jpeg",
      );

      for (int i = 0; i < pois2.length; i++) {
        if (pois2[i]['category'].toString() == 'Aeroport') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/airport.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Agentie de turism' ||
            pois2[i]['category'].toString() == 'Agentie imobiliara' ||
            pois2[i]['category'].toString() == 'Institutie publica' ||
            pois2[i]['category'].toString() == 'Travel agency' ||
            pois2[i]['category'].toString() == 'Consultant') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/travel-agency.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Alternative fuel station' ||
            pois2[i]['category'].toString() == 'Benzinarie' ||
            pois2[i]['category'].toString() == 'Companie de petrol si gaze naturale' ||
            pois2[i]['category'].toString() == 'Electric vehicle charging station') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/gas-station.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Ambasada' ||
            pois2[i]['category'].toString() == 'Business center' ||
            pois2[i]['category'].toString() == 'Organizatie') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/local-government.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Amusement park ride' ||
            pois2[i]['category'].toString() == 'Parc' ||
            pois2[i]['category'].toString() == 'Playground') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/playground.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Apartament in regim hotelier' ||
            pois2[i]['category'].toString() == 'Hostel' ||
            pois2[i]['category'].toString() == 'hotels' ||
            pois2[i]['category'].toString() == 'Motel' ||
            pois2[i]['category'].toString() == 'Pensiune') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/place.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'ATM' || pois2[i]['category'].toString() == 'Banca') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/bank.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'attractions' ||
            pois2[i]['category'].toString() == 'Galerie de arta' ||
            pois2[i]['category'].toString() == 'Monument' ||
            pois2[i]['category'].toString() == 'museums' ||
            pois2[i]['category'].toString() == 'Opera' ||
            pois2[i]['category'].toString() == 'Sala de evenimente' ||
            pois2[i]['category'].toString() == 'statuie') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/point-of-interest.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Auto parts store' ||
            pois2[i]['category'].toString() == 'Centru comercial' ||
            pois2[i]['category'].toString() == 'Clothing store' ||
            pois2[i]['category'].toString() == 'Companie de software' ||
            pois2[i]['category'].toString() == 'Electrician' ||
            pois2[i]['category'].toString() == 'Electronics store' ||
            pois2[i]['category'].toString() == 'Energy supplier' ||
            pois2[i]['category'].toString() == 'Furniture store' ||
            pois2[i]['category'].toString() == 'Parfumerie' ||
            pois2[i]['category'].toString() == 'Toy store' ||
            pois2[i]['category'].toString() == 'Warehouse' ||
            pois2[i]['category'].toString() == 'service auto') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/store.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Bacanie' ||
            pois2[i]['category'].toString() == 'Cofetarie' ||
            pois2[i]['category'].toString() == 'coffee shops' ||
            pois2[i]['category'].toString() == ' Hypermarket' ||
            pois2[i]['category'].toString() == 'Ice cream shop' ||
            pois2[i]['category'].toString() == 'restaurants' ||
            pois2[i]['category'].toString() == 'Supermarket' ||
            pois2[i]['category'].toString() == 'Patiserie' ||
            pois2[i]['category'].toString() == 'Piata') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/food.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'bars' || pois2[i]['category'].toString() == 'Wine store') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/night-club.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Barber shop' ||
            pois2[i]['category'].toString() == 'Beauty salon' ||
            pois2[i]['category'].toString() == 'SPA') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/beauty-salon.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Biblioteca' ||
            pois2[i]['category'].toString() == 'Librarie' ||
            pois2[i]['category'].toString() == 'scoala' ||
            pois2[i]['category'].toString() == 'Universitate') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/book-store.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Biserica' || pois2[i]['category'].toString() == 'Catedrala') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/church.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Car dealer' ||
            pois2[i]['category'].toString() == 'Car rental' ||
            pois2[i]['category'].toString() == 'Car wash' ||
            pois2[i]['category'].toString() == 'Vulcanizare') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/car-rental.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Cazino') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/casino.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Companie farmaceutica' ||
            pois2[i]['category'].toString() == 'Hospital' ||
            pois2[i]['category'].toString() == 'Pharmacy') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/doctor.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Farmacie veterinara' ||
            pois2[i]['category'].toString() == 'Medic veterinar' ||
            pois2[i]['category'].toString() == 'pet shop') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/pet-store.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'fitness') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/gym.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Florarie') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/florist.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Gara' ||
            pois2[i]['category'].toString() == 'Statie de autobuz' ||
            pois2[i]['category'].toString() == 'Statie de metrou' ||
            pois2[i]['category'].toString() == 'Statie de tramvai') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/train-station.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Jewelry store') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/jewelry-store.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Parking lot') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/parking.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Taxi') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/taxi-stand.jpeg",
          );
          setState(() {});
        } else if (pois2[i]['category'].toString() == 'Club sportiv' || pois2[i]['category'].toString() == 'Stadion') {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/stadium.jpeg",
          );
          setState(() {});
        } else {
          markerbitmap = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/map-pin.jpeg",
          );
          setState(() {});
        }
        setState(() {
          myPois.add(Marker(
            markerId: MarkerId(pois2[i]['name'].toString()),
            position:
                LatLng(double.parse(pois2[i]['latitude'].toString()), double.parse(pois2[i]['longitude'].toString())),
            infoWindow: InfoWindow(title: pois2[i]['name'].toString()),
            icon: markerbitmap,
            onTap: () async {
              Map<dynamic, dynamic> thePoi = {};
              thePoi = await getPoiInfo(
                  double.parse(pois2[i]['latitude'].toString()), double.parse(pois2[i]['longitude'].toString()));
              showModalBottomSheet(
                context: context,
                builder: (context) => poiInfo(thePoi),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
          ));
        });
      }
      setState(() {
        myPois.add(
          Marker(
            markerId: const MarkerId('demo'),
            position: LatLng(currentPosition.latitude, currentPosition.longitude),
            draggable: false,
          ),
        );
      });
      if (kDebugMode) {
        print('getPois() is called');
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    if (kDebugMode) {
      print("\n\n\n");
    }
  }

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
        currentPosition = Position(
            longitude: value.longitude,
            latitude: value.latitude,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0);
      });

      if (kDebugMode) {
        print("${currentPosition.longitude} ${currentPosition.latitude}");
      }
      getPois(currentPosition.latitude, currentPosition.longitude, 0.5, null, [], myRating);
      getCategories();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LatLng myPosition = LatLng(currentPosition.latitude, currentPosition.longitude);
    LatLng demosPosition = LatLng(demoPosition.latitude, demoPosition.longitude);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('POI app'),
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 60,
              ),
              const Center(
                child: Text(
                  'Filters',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Center(
                child: Text(
                  'Categories',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DropdownSearch<String>(
                  selectedItem: selectedCategory,
                  items: categories,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Category selection",
                      hintText: "Choose category",
                    ),
                  ),
                  onChanged: (selectedItem) {
                    setState(() {
                      selectedCategory = selectedItem!;
                    });
                    if (kDebugMode) {
                      print(selectedCategory);
                    }
                  },
                  popupProps: const PopupProps.menu(
                    // title: Text('Category'),
                    showSearchBox: true,
                    showSelectedItems: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Divider(
                color: Colors.black26,
                height: 3,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Review bigger than $myRating',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  child: RatingBar.builder(
                    initialRating: myRating,
                    minRating: 0,
                    itemSize: 45,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                    itemCount: 5,
                    allowHalfRating: true,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        myRating = rating;
                      });
                    },
                    updateOnDrag: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Divider(
                color: Colors.black26,
                height: 3,
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Do you want to see only open POIs?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 145,
                  maxHeight: 65,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selected1 = !selected1;
                    });
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    backgroundColor: selected1
                        ? MaterialStateProperty.all(Colors.cyanAccent)
                        : MaterialStateProperty.all(Colors.grey),
                  ),
                  child: const Text(
                    'Open',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              /*
              TODO initializeaza vertical si fa o lista cu optiunile
              final List<bool> _selectedFruits = <bool>[true, false, false];
              ToggleButtons(
                direction: vertical ? Axis.vertical : Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedFruits.length; i++) {
                      _selectedFruits[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.red[700],
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.red[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: _selectedFruits,
                children: fruits,
              ),

              **/

              const SizedBox(
                height: 25,
              ),
              const Divider(
                color: Colors.black26,
                height: 3,
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Show only POIs that are around me',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 145,
                  maxHeight: 65,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selected2 = !selected2;
                    });
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    backgroundColor: selected2
                        ? MaterialStateProperty.all(Colors.cyanAccent)
                        : MaterialStateProperty.all(Colors.grey),
                  ),
                  child: const Text(
                    'Close by(0.2km)',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              /*
              Todo set curent value pe 0
              Slider(
        value: _currentSliderValue,
        max: 2,
        divisions: 20,
        label: _currentSliderValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
        },
      ),

              */
              const SizedBox(
                height: 25,
              ),
              const Divider(
                color: Colors.black26,
                height: 3,
              ),
              const SizedBox(
                height: 25,
              ),
              const Center(
                child: Text(
                  'Reset to default?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 145,
                  maxHeight: 65,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selected3 = !selected3;
                      selected2 = false;
                      selected1 = false;
                      myRating = 2.5;
                      selectedCategory = "";
                    });
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    backgroundColor: selected3
                        ? MaterialStateProperty.all(Colors.cyanAccent)
                        : MaterialStateProperty.all(Colors.grey),
                  ),
                  child: const Text(
                    'Revert to default',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 55,
                  maxWidth: 125,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    const url = 'http://localhost:8000/pois/get-pois';
                    if (myPois.isNotEmpty) {
                      setState(() {
                        myPois.clear();
                      });
                    }
                    List<String> usedCategory = [selectedCategory];
                    try {
                      final response = await http.post(Uri.parse(url),
                          headers: <String, String>{'Content-Type': 'application/json'},
                          body: jsonEncode({
                            "latitude": currentPosition.latitude,
                            "longitude": currentPosition.longitude,
                            "radius": selected2 ? 0.2 : 0.5,
                            "open_now": selected1 ? true : null,
                            "categories": (selectedCategory != "") ? usedCategory : [],
                            "rating": myRating
                          }));

                      final pois2 = jsonDecode(response.body) as List;
                      if (kDebugMode) {
                        print('\n/n');
                        print('\n/n');
                        print('\n/n');
                        print(pois2);
                        print(pois2.length);
                      }

                      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/map-pin.jpeg",
                      );

                      for (int i = 0; i < pois2.length; i++) {
                        if (pois2[i]['category'].toString() == 'Aeroport') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/airport.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Agentie de turism' ||
                            pois2[i]['category'].toString() == 'Agentie imobiliara' ||
                            pois2[i]['category'].toString() == 'Institutie publica' ||
                            pois2[i]['category'].toString() == 'Travel agency' ||
                            pois2[i]['category'].toString() == 'Consultant') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/travel-agency.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Alternative fuel station' ||
                            pois2[i]['category'].toString() == 'Benzinarie' ||
                            pois2[i]['category'].toString() == 'Companie de petrol si gaze naturale' ||
                            pois2[i]['category'].toString() == 'Electric vehicle charging station') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/gas-station.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Ambasada' ||
                            pois2[i]['category'].toString() == 'Business center' ||
                            pois2[i]['category'].toString() == 'Organizatie') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/local-government.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Amusement park ride' ||
                            pois2[i]['category'].toString() == 'Parc' ||
                            pois2[i]['category'].toString() == 'Playground') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/playground.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Apartament in regim hotelier' ||
                            pois2[i]['category'].toString() == 'Hostel' ||
                            pois2[i]['category'].toString() == 'hotels' ||
                            pois2[i]['category'].toString() == 'Motel' ||
                            pois2[i]['category'].toString() == 'Pensiune') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/place.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'ATM' ||
                            pois2[i]['category'].toString() == 'Banca') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/bank.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'attractions' ||
                            pois2[i]['category'].toString() == 'Galerie de arta' ||
                            pois2[i]['category'].toString() == 'Monument' ||
                            pois2[i]['category'].toString() == 'museums' ||
                            pois2[i]['category'].toString() == 'Opera' ||
                            pois2[i]['category'].toString() == 'Sala de evenimente' ||
                            pois2[i]['category'].toString() == 'statuie') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/point-of-interest.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Auto parts store' ||
                            pois2[i]['category'].toString() == 'Centru comercial' ||
                            pois2[i]['category'].toString() == 'Clothing store' ||
                            pois2[i]['category'].toString() == 'Companie de software' ||
                            pois2[i]['category'].toString() == 'Electrician' ||
                            pois2[i]['category'].toString() == 'Electronics store' ||
                            pois2[i]['category'].toString() == 'Energy supplier' ||
                            pois2[i]['category'].toString() == 'Furniture store' ||
                            pois2[i]['category'].toString() == 'Parfumerie' ||
                            pois2[i]['category'].toString() == 'Toy store' ||
                            pois2[i]['category'].toString() == 'Warehouse' ||
                            pois2[i]['category'].toString() == 'service auto') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/store.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Bacanie' ||
                            pois2[i]['category'].toString() == 'Cofetarie' ||
                            pois2[i]['category'].toString() == 'coffee shops' ||
                            pois2[i]['category'].toString() == ' Hypermarket' ||
                            pois2[i]['category'].toString() == 'Ice cream shop' ||
                            pois2[i]['category'].toString() == 'restaurants' ||
                            pois2[i]['category'].toString() == 'Supermarket' ||
                            pois2[i]['category'].toString() == 'Patiserie' ||
                            pois2[i]['category'].toString() == 'Piata') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/food.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'bars' ||
                            pois2[i]['category'].toString() == 'Wine store') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/night-club.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Barber shop' ||
                            pois2[i]['category'].toString() == 'Beauty salon' ||
                            pois2[i]['category'].toString() == 'SPA') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/beauty-salon.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Biblioteca' ||
                            pois2[i]['category'].toString() == 'Librarie' ||
                            pois2[i]['category'].toString() == 'scoala' ||
                            pois2[i]['category'].toString() == 'Universitate') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/book-store.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Biserica' ||
                            pois2[i]['category'].toString() == 'Catedrala') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/church.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Car dealer' ||
                            pois2[i]['category'].toString() == 'Car rental' ||
                            pois2[i]['category'].toString() == 'Car wash' ||
                            pois2[i]['category'].toString() == 'Vulcanizare') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/car-rental.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Cazino') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/casino.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Companie farmaceutica' ||
                            pois2[i]['category'].toString() == 'Hospital' ||
                            pois2[i]['category'].toString() == 'Pharmacy') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/doctor.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Farmacie veterinara' ||
                            pois2[i]['category'].toString() == 'Medic veterinar' ||
                            pois2[i]['category'].toString() == 'pet shop') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/pet-store.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'fitness') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/gym.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Florarie') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/florist.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Gara' ||
                            pois2[i]['category'].toString() == 'Statie de autobuz' ||
                            pois2[i]['category'].toString() == 'Statie de metrou' ||
                            pois2[i]['category'].toString() == 'Statie de tramvai') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/train-station.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Jewelry store') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/jewelry-store.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Parking lot') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/parking.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Taxi') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/taxi-stand.jpeg",
                          );
                          setState(() {});
                        } else if (pois2[i]['category'].toString() == 'Club sportiv' ||
                            pois2[i]['category'].toString() == 'Stadion') {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/stadium.jpeg",
                          );
                          setState(() {});
                        } else {
                          markerbitmap = await BitmapDescriptor.fromAssetImage(
                            const ImageConfiguration(),
                            "assets/map-pin.jpeg",
                          );
                          setState(() {});
                        }
                        setState(() {
                          myPois.add(Marker(
                            markerId: MarkerId(pois2[i]['name'].toString()),
                            position: LatLng(double.parse(pois2[i]['latitude'].toString()),
                                double.parse(pois2[i]['longitude'].toString())),
                            infoWindow: InfoWindow(title: pois2[i]['name'].toString()),
                            icon: markerbitmap,
                            onTap: () async {
                              Map<dynamic, dynamic> thePoi = {};
                              thePoi = await getPoiInfo(double.parse(pois2[i]['latitude'].toString()),
                                  double.parse(pois2[i]['longitude'].toString()));
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => poiInfo(thePoi),
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                              );
                            },
                          ));
                        });
                      }
                      if (kDebugMode) {
                        print('getPois() is called');
                      }
                      setState(() {
                        myPois.add(
                          Marker(
                            markerId: const MarkerId('demo'),
                            position: LatLng(currentPosition.latitude, currentPosition.longitude),
                            draggable: false,
                          ),
                        );
                      });
                      if (scaffoldKey.currentState!.isDrawerOpen) {
                        scaffoldKey.currentState!.closeDrawer();
                        //close drawer, if drawer is open
                      }
                    } catch (err) {
                      if (kDebugMode) {
                        print(err);
                      }
                    }
                    if (kDebugMode) {
                      print("\n\n\n");
                    }
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(2),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
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
              onMapCreated: (GoogleMapController controller) async {
                controller1.complete(controller);
                controller.setMapStyle(json);
                getPois(currentPosition.latitude, currentPosition.longitude, 0.5, null, [], myRating);
              },
              initialCameraPosition: CameraPosition(target: demosPosition, zoom: 15),
              markers: myPois.toSet(),
              myLocationButtonEnabled: false,
              buildingsEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              onCameraMove: (cameraPosition) async {
                const url = 'http://localhost:8000/pois/get-pois';
                if (myPois.isNotEmpty) {
                  setState(() {
                    myPois.clear();
                  });
                }

                try {
                  final response = await http.post(Uri.parse(url),
                      headers: <String, String>{'Content-Type': 'application/json'},
                      body: jsonEncode({
                        "latitude": cameraPosition.target.latitude,
                        "longitude": cameraPosition.target.longitude,
                        "radius": selected2 ? 0.2 : 0.5,
                        "open_now": selected1 ? true : null,
                        "categories": (selectedCategory != "") ? [selectedCategory] : [],
                        "rating": myRating
                      }));

                  final pois2 = jsonDecode(response.body) as List;
                  if (kDebugMode) {
                    print('\n/n');
                    print('\n/n');
                    print('\n/n');
                    print(pois2);
                    print(pois2.length);
                  }

                  BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
                    const ImageConfiguration(),
                    "assets/map-pin.jpeg",
                  );

                  for (int i = 0; i < pois2.length; i++) {
                    if (pois2[i]['category'].toString() == 'Aeroport') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/airport.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Agentie de turism' ||
                        pois2[i]['category'].toString() == 'Agentie imobiliara' ||
                        pois2[i]['category'].toString() == 'Institutie publica' ||
                        pois2[i]['category'].toString() == 'Travel agency' ||
                        pois2[i]['category'].toString() == 'Consultant') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/travel-agency.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Alternative fuel station' ||
                        pois2[i]['category'].toString() == 'Benzinarie' ||
                        pois2[i]['category'].toString() == 'Companie de petrol si gaze naturale' ||
                        pois2[i]['category'].toString() == 'Electric vehicle charging station') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/gas-station.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Ambasada' ||
                        pois2[i]['category'].toString() == 'Business center' ||
                        pois2[i]['category'].toString() == 'Organizatie') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/local-government.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Amusement park ride' ||
                        pois2[i]['category'].toString() == 'Parc' ||
                        pois2[i]['category'].toString() == 'Playground') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/playground.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Apartament in regim hotelier' ||
                        pois2[i]['category'].toString() == 'Hostel' ||
                        pois2[i]['category'].toString() == 'hotels' ||
                        pois2[i]['category'].toString() == 'Motel' ||
                        pois2[i]['category'].toString() == 'Pensiune') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/place.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'ATM' || pois2[i]['category'].toString() == 'Banca') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/bank.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'attractions' ||
                        pois2[i]['category'].toString() == 'Galerie de arta' ||
                        pois2[i]['category'].toString() == 'Monument' ||
                        pois2[i]['category'].toString() == 'museums' ||
                        pois2[i]['category'].toString() == 'Opera' ||
                        pois2[i]['category'].toString() == 'Sala de evenimente' ||
                        pois2[i]['category'].toString() == 'statuie') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/point-of-interest.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Auto parts store' ||
                        pois2[i]['category'].toString() == 'Centru comercial' ||
                        pois2[i]['category'].toString() == 'Clothing store' ||
                        pois2[i]['category'].toString() == 'Companie de software' ||
                        pois2[i]['category'].toString() == 'Electrician' ||
                        pois2[i]['category'].toString() == 'Electronics store' ||
                        pois2[i]['category'].toString() == 'Energy supplier' ||
                        pois2[i]['category'].toString() == 'Furniture store' ||
                        pois2[i]['category'].toString() == 'Parfumerie' ||
                        pois2[i]['category'].toString() == 'Toy store' ||
                        pois2[i]['category'].toString() == 'Warehouse' ||
                        pois2[i]['category'].toString() == 'service auto') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/store.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Bacanie' ||
                        pois2[i]['category'].toString() == 'Cofetarie' ||
                        pois2[i]['category'].toString() == 'coffee shops' ||
                        pois2[i]['category'].toString() == ' Hypermarket' ||
                        pois2[i]['category'].toString() == 'Ice cream shop' ||
                        pois2[i]['category'].toString() == 'restaurants' ||
                        pois2[i]['category'].toString() == 'Supermarket' ||
                        pois2[i]['category'].toString() == 'Patiserie' ||
                        pois2[i]['category'].toString() == 'Piata') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/food.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'bars' ||
                        pois2[i]['category'].toString() == 'Wine store') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/night-club.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Barber shop' ||
                        pois2[i]['category'].toString() == 'Beauty salon' ||
                        pois2[i]['category'].toString() == 'SPA') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/beauty-salon.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Biblioteca' ||
                        pois2[i]['category'].toString() == 'Librarie' ||
                        pois2[i]['category'].toString() == 'scoala' ||
                        pois2[i]['category'].toString() == 'Universitate') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/book-store.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Biserica' ||
                        pois2[i]['category'].toString() == 'Catedrala') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/church.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Car dealer' ||
                        pois2[i]['category'].toString() == 'Car rental' ||
                        pois2[i]['category'].toString() == 'Car wash' ||
                        pois2[i]['category'].toString() == 'Vulcanizare') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/car-rental.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Cazino') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/casino.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Companie farmaceutica' ||
                        pois2[i]['category'].toString() == 'Hospital' ||
                        pois2[i]['category'].toString() == 'Pharmacy') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/doctor.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Farmacie veterinara' ||
                        pois2[i]['category'].toString() == 'Medic veterinar' ||
                        pois2[i]['category'].toString() == 'pet shop') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/pet-store.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'fitness') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/gym.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Florarie') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/florist.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Gara' ||
                        pois2[i]['category'].toString() == 'Statie de autobuz' ||
                        pois2[i]['category'].toString() == 'Statie de metrou' ||
                        pois2[i]['category'].toString() == 'Statie de tramvai') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/train-station.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Jewelry store') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/jewelry-store.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Parking lot') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/parking.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Taxi') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/taxi-stand.jpeg",
                      );
                      setState(() {});
                    } else if (pois2[i]['category'].toString() == 'Club sportiv' ||
                        pois2[i]['category'].toString() == 'Stadion') {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/stadium.jpeg",
                      );
                      setState(() {});
                    } else {
                      markerbitmap = await BitmapDescriptor.fromAssetImage(
                        const ImageConfiguration(),
                        "assets/map-pin.jpeg",
                      );
                      setState(() {});
                    }
                    setState(() {
                      myPois.add(Marker(
                        markerId: MarkerId(pois2[i]['name'].toString()),
                        position: LatLng(double.parse(pois2[i]['latitude'].toString()),
                            double.parse(pois2[i]['longitude'].toString())),
                        infoWindow: InfoWindow(title: pois2[i]['name'].toString()),
                        icon: markerbitmap,
                        onTap: () async {
                          Map<dynamic, dynamic> thePoi = {};
                          thePoi = await getPoiInfo(double.parse(pois2[i]['latitude'].toString()),
                              double.parse(pois2[i]['longitude'].toString()));
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => poiInfo(thePoi),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        },
                      ));
                    });
                  }
                  if (kDebugMode) {
                    print('getPois() is called');
                  }
                  setState(() {
                    myPois.add(
                      Marker(
                        markerId: const MarkerId('demo'),
                        position: LatLng(currentPosition.latitude, currentPosition.longitude),
                        draggable: false,
                      ),
                    );
                  });
                } catch (err) {
                  if (kDebugMode) {
                    print(err);
                  }
                }
                if (kDebugMode) {
                  print("\n\n\n");
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoogleMapController controller = await controller1.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 16)));
          if (kDebugMode) {
            print('moved');
          }
        },
        child: const Icon(Icons.near_me),
      ),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget poiInfo(Map<dynamic, dynamic> poi) {
    // Map<dynamic, dynamic> thePoi = {};
    // thePoi = await getPoiInfo(lat, long);
    //Todo: to do controller DraggableScrollableSheet
    return makeDismissible(
        child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (_, controller) => Container(
                  decoration: const BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        const Center(
                          child: SizedBox(
                            width: 100,
                            height: 5,
                            child: Divider(
                              color: Colors.black26,
                              thickness: 3,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: Text(
                          "- ${poi['name']} -",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Colors.black26,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          "Category: ${poi['category']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Colors.black26,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          "Address: ${poi['full_address']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Colors.black26,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Center(child: Text("name ${poi['city']}")),

                        Center(
                            child: Text(
                          "Rating: ${double.parse(poi['average_rating']).toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Colors.black26,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          "Schedule: ${poi['working_hours']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        )),
                        const SizedBox(
                          height: 30,
                        ),
                        ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 135,
                              minHeight: 55,
                            ),
                            child: ElevatedButton(
                                onPressed: () async {
                                  MapsLauncher.launchCoordinates(double.parse(poi['latitude'].toString()),
                                      double.parse(poi['longitude'].toString()), poi['name'].toString());
                                },
                                child: const Text(
                                  'Go to location',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ))),
                      ],
                    ),
                  ),
                )));
  }
}
