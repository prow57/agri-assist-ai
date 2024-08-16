// market_place_page.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'market_service.dart';
import 'commodity.dart'; // Import your Commodity model

class MarketPlacePage extends StatefulWidget {
  final int marketId;

  MarketPlacePage({required this.marketId});

  @override
  _MarketPlacePageState createState() => _MarketPlacePageState();
}

class _MarketPlacePageState extends State<MarketPlacePage> {
  late Future<List<Commodity>> _futureCommodities;

  @override
  void initState() {
    super.initState();
    _futureCommodities = MarketService().fetchMarketPrices(widget.marketId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Market Place',
          style: TextStyle(color: Colors.white),
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
                    const Text(
                      'Supply and Demand',
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
                            xValueMapper: (Commodity data, _) => data.name,
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
                            name: commodity.name,
                            price: commodity.price.toString());
                      },
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Top Selling Commodities',
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
                            name: commodity.name,
                            price: commodity.price.toString());
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
