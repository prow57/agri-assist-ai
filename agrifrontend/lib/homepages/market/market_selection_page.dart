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
        title: const Text('Select Market'),
        backgroundColor: Colors.green,
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
                return ListTile(
                  title: Text(market.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarketPlacePage(marketId: market.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
