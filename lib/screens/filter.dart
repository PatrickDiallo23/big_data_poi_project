import 'package:flutter/material.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  RangeValues _currentRangeValues = const RangeValues(0, 5);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120,
                    maxWidth: 200,
                    maxHeight: 65,
                  ),
                  child: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    ),
                    child: const Text('Hotels'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120,
                    maxWidth: 200,
                    maxHeight: 65,
                  ),
                  child: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    ),
                    child: const Text('Hotels'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120,
                    maxWidth: 200,
                    maxHeight: 65,
                  ),
                  child: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    ),
                    child: const Text('Hotels'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120,
                    maxWidth: 200,
                    maxHeight: 65,
                  ),
                  child: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    ),
                    child: const Text('Hotels'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120,
                    maxWidth: 200,
                    maxHeight: 65,
                  ),
                  child: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    ),
                    child: const Text('Hotels'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 120,
                    maxWidth: 200,
                    maxHeight: 65,
                  ),
                  child: ElevatedButton(
                    onPressed: null,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                    ),
                    child: const Text('Hotelssssss'),
                  ),
                ),
              ],
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
              'Review range between 0 and 5',
              textAlign: TextAlign.center,
              style: TextStyle(
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
              child: RangeSlider(
                values: _currentRangeValues,
                max: 5,
                divisions: 5,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
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
              onPressed: null,
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(2),
                padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
              ),
              child: const Text('Open'),
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
              onPressed: null,
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(2),
                padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
              ),
              child: const Text('Close by(2km)'),
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
              onPressed: null,
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(2),
                padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
              ),
              child: const Text('Revert to default'),
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
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
