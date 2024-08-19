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

  @override
  void initState() {
    super.initState();
    _futureCommodities = MarketService().fetchMarketPrices(widget.marketId);
    _currentDate = DateFormat('EEEE, MMMM d, yyyy')
        .format(DateTime.now()); // Format the current date
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
      body: FutureBuilder<List<Commodity>>(
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
                            xValueMapper: (Commodity data, _) => data.cropName,
                            yValueMapper: (Commodity data, _) => data.price,
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
                          name:
                              '${commodity.cropName}',
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
