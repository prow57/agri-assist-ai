import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'driver_service.dart'; // Import the DriverService
import 'driver.dart'; // Import your Driver model
import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/settings_page.dart';

class DriverListPage extends StatefulWidget {
  final int marketId;

  DriverListPage({required this.marketId});

  @override
  _DriverListPageState createState() => _DriverListPageState();
}

class _DriverListPageState extends State<DriverListPage> {
  late Future<List<Driver>> _futureDrivers;
  List<Driver> _drivers = [];
  List<Driver> _filteredDrivers = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch drivers by market ID
    _futureDrivers = DriverService().fetchDriversByMarket(widget.marketId);
    _futureDrivers.then((drivers) {
      setState(() {
        _drivers = drivers;
        _filteredDrivers = drivers;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        _drivers = []; // Handle error by setting an empty list
        _filteredDrivers = [];
      });
    });

    // Trigger filtering as the user types
    _searchController.addListener(() {
      _filterDrivers();
    });
  }

  void _filterDrivers() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredDrivers = _drivers;
      } else {
        _filteredDrivers = _drivers.where((driver) {
          return driver.firstName.toLowerCase().contains(query) ||
              driver.lastName.toLowerCase().contains(query) ||
              driver.phone1.toLowerCase().contains(query) ||
              driver.phone2.toLowerCase().contains(query) ||
              driver.carType.toLowerCase().contains(query); // Add carType filtering
        }).toList();
      }
    });
  }

  // Add this method to handle phone dialing
  void _dialNumber(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle error or show a message if the phone dialer is not available
      print('Could not open dialer.');
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Ignore tap if already on the selected tab

    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AllCoursesPage(),
          ),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AllCoursesPage(),
          ),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PersonalizedAdvicePage(),
          ),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Drivers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search drivers...',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterDrivers(); // Trigger filtering after clearing the text field
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredDrivers.isEmpty
                    ? Center(child: Text('No drivers found'))
                    : ListView.builder(
                        itemCount: _filteredDrivers.length,
                        itemBuilder: (context, index) {
                          final driver = _filteredDrivers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Icon(Icons.person,
                                  size: 40, color: Colors.green),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${driver.firstName} ${driver.lastName}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    driver.carType,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _dialNumber(driver.phone1),
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text(driver.phone1, style: TextStyle(color: Colors.grey[600])),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16), // Add spacing before the second phone number
                                  GestureDetector(
                                    onTap: () => _dialNumber(driver.phone2),
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text(driver.phone2, style: TextStyle(color: Colors.grey[600])),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Handle driver selection if needed
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the current index
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Ai',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green[300],
        showUnselectedLabels: false,
        selectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
