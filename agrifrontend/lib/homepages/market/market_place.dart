import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MarketPlacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Place'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                  series: <LineSeries>[
                    LineSeries<ChartData, double>(
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
                  CommodityTile(name: 'Wheat', price: '1000 KSH'),
                  CommodityTile(name: 'Maize', price: '800 KSH'),
                  CommodityTile(name: 'Rice', price: '1200 KSH'),
                  CommodityTile(name: 'Beans', price: '900 KSH'),
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
                  CommodityTile(name: 'Maize', price: '800 KSH'),
                  CommodityTile(name: 'Wheat', price: '1000 KSH'),
                  CommodityTile(name: 'Beans', price: '900 KSH'),
                ],
              ),
            ],
          ),
        ),
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
        title: Text(name),
        trailing: Text(price),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final double x;
  final double y;
}
