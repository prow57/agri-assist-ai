import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'market_service.dart';
import 'commodity.dart'; // Import your Commodity model

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
  late String _currentDate; // Variable to hold the formatted date
  String _selectedCategory = 'Crop Products'; // Track the selected category

  @override
  void initState() {
    super.initState();
    _currentDate = DateFormat('EEEE, MMMM d, yyyy')
        .format(DateTime.now()); // Format the current date
    _fetchData(); // Initial data fetch
  }

  void _fetchData() {
    setState(() {
      if (_selectedCategory == 'Crop') {
        _futureCommodities = MarketService().fetchCropPrices(widget.marketId);
      } else if (_selectedCategory == 'Animal') {
        _futureCommodities = MarketService().fetchAnimalPrices(widget.marketId);
      } else if (_selectedCategory == 'Crop Products') {
        _futureCommodities = MarketService().fetchCropProductPrices(widget.marketId);
      } else if (_selectedCategory == 'Animal Products') {
        _futureCommodities = MarketService().fetchAnimalProductPrices(widget.marketId);
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
        title: Text(
          '${widget.marketName}, ${widget.marketLocation}', // Display market name and location
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
            child: DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                  _fetchData(); // Fetch new data based on the selected option
                });
              },
              items: <String>[
                'Crop Products',
                'Animal Products',
                'Crop and Animal'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Commodity>>(
              future: _futureCommodities,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentDate, // Display the current date
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            height: 200.0,
                            child: SfCircularChart(
                              legend: Legend(isVisible: true),
                              series: <PieSeries>[
                                PieSeries<Commodity, String>(
                                  dataSource: snapshot.data!,
                                  xValueMapper: (Commodity data, _) =>
                                      data.cropName,
                                  yValueMapper: (Commodity data, _) =>
                                      data.price,
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Commodities and Prices',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final commodity = snapshot.data![index];
                              return CommodityTile(
                                name: commodity.cropName,
                                price: 'Mk ${commodity.price.toString()}',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MarketLocationPage()),
          );
        },
        child: const Icon(Icons.location_on, color: Colors.white),
        backgroundColor: Colors.green,
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

class CommodityTile extends StatelessWidget {
  final String name;
  final String price;

  const CommodityTile({
    required this.name,
    required this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          price,
          style: const TextStyle(color: Colors.green),
        ),
      ),
    );
  }
}

class MarketLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Locations'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('Map of Market Locations Here'),
      ),
    );
  }
}
