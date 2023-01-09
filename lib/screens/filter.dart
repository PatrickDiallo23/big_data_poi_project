import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  double myRating = 0;
  bool selected1 = false;
  bool selected2 = false;
  bool selected3 = false;
  List<String> categories = [];
  String selectedCategory = '';
  Map<String, dynamic> testMap = {};
  List<Marker> myPois = [];
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  backgroundColor:
                      selected1 ? MaterialStateProperty.all(Colors.cyanAccent) : MaterialStateProperty.all(Colors.grey),
                ),
                child: const Text(
                  'Open',
                  style: TextStyle(color: Colors.black),
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
                  backgroundColor:
                      selected2 ? MaterialStateProperty.all(Colors.cyanAccent) : MaterialStateProperty.all(Colors.grey),
                ),
                child: const Text(
                  'Close by(0.2km)',
                  style: TextStyle(color: Colors.black),
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
                  });
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                  backgroundColor:
                      selected3 ? MaterialStateProperty.all(Colors.cyanAccent) : MaterialStateProperty.all(Colors.grey),
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
                onPressed: null,
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
    );
  }
}
