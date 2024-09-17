import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:flutter/material.dart';
import 'market_service.dart';
import 'market.dart'; // Import your Market model
import 'market_place.dart'; // Import the MarketPlacePage

class MarketSelectionPage extends StatefulWidget {
  const MarketSelectionPage({super.key});

  @override
  _MarketSelectionPageState createState() => _MarketSelectionPageState();
}

class _MarketSelectionPageState extends State<MarketSelectionPage> {
  late Future<List<Market>> _futureMarkets;
  List<Market> _markets = [];
  List<Market> _filteredMarkets = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _futureMarkets = MarketService().fetchMarkets();
    _futureMarkets.then((markets) {
      setState(() {
        _markets = markets;
        _filteredMarkets = markets;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
        _markets = []; // Handle error by setting an empty list
        _filteredMarkets = [];
      });
    });

    // Trigger filtering as the user types
    _searchController.addListener(() {
      _filterMarkets();
    });
  }

  void _filterMarkets() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredMarkets = _markets;
      } else {
        _filteredMarkets = _markets.where((market) {
          return market.name.toLowerCase().contains(query) ||
              market.location.toLowerCase().contains(query);
        }).toList();
      }
    });
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
          'Select Market',
          style: TextStyle(color: Colors.white),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search markets...',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterMarkets(); // Trigger filtering after clearing the text field
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
                ? const Center(child: CircularProgressIndicator())
                : _filteredMarkets.isEmpty
                    ? const Center(child: Text('No markets found'))
                    : ListView.builder(
                        itemCount: _filteredMarkets.length,
                        itemBuilder: (context, index) {
                          final market = _filteredMarkets[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: const Icon(Icons.store,
                                  size: 40, color: Colors.green),
                              title: Text(
                                market.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                market.location,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MarketPlacePage(
                                      marketId: market.id,
                                      marketName: market.name,
                                      marketLocation: market.location,
                                    ),
                                  ),
                                );
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
