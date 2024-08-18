import 'package:agrifrontend/homepages/market/market_place.dart';
import 'package:flutter/material.dart';
import 'market_service.dart';
import 'market.dart'; // Import your Market model

class MarketSelectionPage extends StatefulWidget {
  @override
  _MarketSelectionPageState createState() => _MarketSelectionPageState();
}

class _MarketSelectionPageState extends State<MarketSelectionPage> {
  late Future<List<Market>> _futureMarkets;

  @override
  void initState() {
    super.initState();
    _futureMarkets = MarketService().fetchMarkets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Market',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Set icon color to white
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Market>>(
        future: _futureMarkets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No markets available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final market = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(Icons.store, size: 40, color: Colors.green),
                    title: Text(
                      market.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Market ID: ${market.id}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MarketPlacePage(marketId: market.id),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
