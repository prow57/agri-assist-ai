import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:agrifrontend/homepages/market/driver_selection_page.dart';
import 'package:agrifrontend/homepages/market/market_locations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'market_service.dart';
import 'commodity.dart';

class MarketPlacePage extends StatefulWidget {
  final int marketId;
  final String marketName;
  final String marketLocation;

  MarketPlacePage({
    required this.marketId,
    required this.marketName,
    required this.marketLocation,
  });

  @override
  _MarketPlacePageState createState() => _MarketPlacePageState();
}

class _MarketPlacePageState extends State<MarketPlacePage> {
  late Future<List<Commodity>> _futureCommodities;
  late String _currentDate;
  String _selectedCategory = 'Animal';
  bool _isPremiumUser = false; // Track if the user is a premium user
  String _searchTerm = ''; // Store the search term
  List<Commodity> _commodities = [];
  List<Commodity> _filteredCommodities = []; // Filtered commodities
  int _selectedIndex = 0; // Track the selected index for bottom navigation
  bool _isLoading = true; // Track loading state
  String _errorMessage = ''; // Track error message

  @override
  void initState() {
    super.initState();
    _currentDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    _fetchData();
    _checkUserPremiumStatus();
  }

  void _checkUserPremiumStatus() {
    // Mock logic to determine if the user is premium
    // Replace this with actual logic (e.g., fetch from server or local storage)
    setState(() {
      _isPremiumUser = false; // Default to free user
    });
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true; // Set loading state
      _errorMessage = ''; // Clear previous error message
    });

    try {
      switch (_selectedCategory) {
        case 'Crop':
          _commodities = await MarketService().fetchCropPrices(widget.marketId);
          break;
        case 'Animal':
          _commodities =
              await MarketService().fetchAnimalPrices(widget.marketId);
          break;
        case 'Crop Products':
          _commodities =
              await MarketService().fetchCropProductPrices(widget.marketId);
          break;
        case 'Animal Products':
          _commodities =
              await MarketService().fetchAnimalProductPrices(widget.marketId);
          break;
      }
      _filterCommodities(); // Update filtered commodities
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load commodities. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  void _filterCommodities() {
    if (_searchTerm.isNotEmpty) {
      _filteredCommodities = _commodities.where((commodity) {
        return commodity.name.toLowerCase().contains(_searchTerm.toLowerCase());
      }).toList();
    } else {
      _filteredCommodities = _commodities;
    }
  }

  void _onFloatingButtonPressed(String buttonType) {
    if (_isPremiumUser) {
      if (buttonType == 'location') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MarketLocation()),
        );
      } else if (buttonType == 'car') {
        // Navigate to the DriverListPage with the market ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverListPage(marketId: widget.marketId),
          ),
        );
      }
    } else {
      _showPremiumPopup();
    }
  }

  void _showPremiumPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upgrade to Premium'),
          content: const Text('Upgrade to premium to access these features.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _upgradeToPremium();
              },
              child: const Text('Go Premium'),
            ),
          ],
        );
      },
    );
  }

  void _upgradeToPremium() {
    setState(() {
      _isPremiumUser = true; // Mark user as premium
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You have upgraded to premium!')),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MarketPlacePage(
                    marketId: widget.marketId,
                    marketName: widget.marketName,
                    marketLocation: widget.marketLocation,
                  )),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllCoursesPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PersonalizedAdvicePage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
    }
  }

  Widget buildCommodityTile(Commodity commodity) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            commodity.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            commodity.quantity,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            'MKW ${(commodity.price).toString()}',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.marketName}, ${widget.marketLocation}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                      _fetchData();
                    });
                  },
                  items: <String>[
                    'Animal',
                    'Crop',
                    'Animal Products',
                    'Crop Products'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Text(
                  _currentDate,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchTerm = value; // Update the search term
                  _filterCommodities(); // Apply search filter
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Commodities',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
                  : Expanded(
                      child: _filteredCommodities.isEmpty
                          ? Center(child: Text('No commodities found.'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: _filteredCommodities.length,
                              itemBuilder: (context, index) {
                                final commodity = _filteredCommodities[index];
                                return buildCommodityTile(commodity);
                              },
                            ),
                    ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "carBtn",
            onPressed: () {
              _onFloatingButtonPressed('car');
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.directions_car, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "locationBtn",
            onPressed: () {
              _onFloatingButtonPressed('location');
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.location_on, color: Colors.white),
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
