import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MarketPlacePage extends StatelessWidget {
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Supply and Demand',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 200.0,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  legend: Legend(isVisible: true),
                  series: <LineSeries>[
                    LineSeries<ChartData, double>(
                      name: 'Supply',
                      dataSource: [
                        ChartData(1, 3),
                        ChartData(2, 4),
                        ChartData(3, 2),
                        ChartData(4, 5),
                        ChartData(5, 3),
                      ],
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      color: Colors.green,
                    ),
                    LineSeries<ChartData, double>(
                      name: 'Demand',
                      dataSource: [
                        ChartData(1, 2),
                        ChartData(2, 3),
                        ChartData(3, 1),
                        ChartData(4, 4),
                        ChartData(5, 2),
                      ],
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Commodities and Prices',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  CommodityTile(name: 'Wheat', price: 'K 1000'),
                  CommodityTile(name: 'Maize', price: 'K 800'),
                  CommodityTile(name: 'Rice', price: 'K 1200'),
                  CommodityTile(name: 'Beans', price: 'K 900'),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Top Selling Commodities',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  CommodityTile(name: 'Maize', price: 'K 800'),
                  CommodityTile(name: 'Wheat', price: 'K 1000'),
                  CommodityTile(name: 'Beans', price: 'K 900'),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MarketLocationPage()),
          );
        },
        child: const Icon(
          Icons.location_on,
          color: Colors.white,
        ),
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

class ChartData {
  ChartData(this.x, this.y);
  final double x;
  final double y;
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
