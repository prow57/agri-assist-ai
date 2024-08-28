import 'package:agrifrontend/scan.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class ScanHistoryPage extends StatefulWidget {
  const ScanHistoryPage({super.key});

  @override
  _ScanHistoryPageState createState() => _ScanHistoryPageState();
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  late Box<Scan> scanBox;

  @override
  void initState() {
    super.initState();
    scanBox = Hive.box<Scan>('scans');
  }

  void _removeScan(int index) {
    final removedScan = scanBox.getAt(index);
    scanBox.deleteAt(index);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Scan removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            if (removedScan != null) {
              scanBox.add(removedScan);
              setState(() {});
            }
          },
        ),
      ),
    );
  }

  void _archiveScan(int index) {
    final archivedScan = scanBox.getAt(index);
    scanBox.deleteAt(index);
    // Handle archiving logic here (e.g., move to another box)
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scan archived')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan History"),
        backgroundColor: Colors.green,
      ),
      body: ValueListenableBuilder(
        valueListenable: scanBox.listenable(),
        builder: (context, Box<Scan> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text("No scans available"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final scan = box.getAt(index);

              return Dismissible(
                key: Key(scan!.date),
                direction: DismissDirection.horizontal,
                background: Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: const Icon(Icons.archive, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    _removeScan(index);
                  } else if (direction == DismissDirection.startToEnd) {
                    _archiveScan(index);
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: Icon(Icons.local_florist, color: Colors.green[700], size: 40),
                    title: Text(
                      scan.plantName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Common Name: ${scan.commonName}"),
                        Text("Disease: ${scan.disease}"),
                        Text("Date: ${scan.date}"),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.green),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedResultPage(scan: scan),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailedResultPage extends StatelessWidget {
  final Scan scan;

  const DetailedResultPage({required this.scan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Details"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scan.plantName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildInfoRow(Icons.local_florist, "Common Name", scan.commonName),
            _buildInfoRow(Icons.nature, "Disease", scan.disease),
            _buildInfoRow(Icons.date_range, "Date Scanned", scan.date),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              onPressed: () {
                // Add action here
              },
              icon: const Icon(Icons.info_outline),
              label: const Text("View Disease Information"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
