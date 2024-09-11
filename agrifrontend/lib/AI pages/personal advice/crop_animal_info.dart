import 'dart:convert';
import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/home_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CropAnimalInfo extends StatefulWidget {
  const CropAnimalInfo({super.key});
  @override
  _CropAnimalInfoState createState() => _CropAnimalInfoState();
}

class _CropAnimalInfoState extends State<CropAnimalInfo> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () {
              Navigator.pop(context);
          },
        ),
            title: Text(
              'Animal & Crop Information',
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "Animal"),
                    Tab(text: "Crop"),
                  ],
                  labelColor: Colors.green,
                  indicatorColor: Colors.green,
                  unselectedLabelColor: Colors.black54,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      AnimalTabContent(),
                      CropTabContent(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
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
                label: 'AI',
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
        ),
      ),
    );
  }
}

class AnimalTabContent extends StatefulWidget {
  @override
  _AnimalTabContentState createState() => _AnimalTabContentState();
}

class _AnimalTabContentState extends State<AnimalTabContent> {
  String animalInfo = "";

  void fetchAnimalInfo() {
    setState(() {
      // Replace with actual data fetching logic
      animalInfo =
          "Sample data: Animal analysis information for the given input.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter animal name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: fetchAnimalInfo,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Get Animal Info'),
          ),
          SizedBox(height: 16),
          Text(
            animalInfo,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class CropTabContent extends StatefulWidget {
  @override
  _CropTabContentState createState() => _CropTabContentState();
}

class _CropTabContentState extends State<CropTabContent> {
  final TextEditingController _cropController = TextEditingController();
  String cropInfo = "";
  String warningMessage = "";
  bool isLoading = false;

  Future<void> fetchCropInfo() async {
    final cropName = _cropController.text.trim();
    if (cropName.isEmpty) {
      setState(() {
        warningMessage = "Please enter a crop name.";
        cropInfo = ""; // Clear the previous info
        isLoading = false; // Ensure loading state is false
      });
      return;
    }

    final url = 'http://37.187.29.19:6932/crop-info/$cropName';

    setState(() {
      isLoading = true;
      warningMessage = ""; // Clear the warning message
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          cropInfo = '''
          Crop Name: ${data['crop_name']}
          Scientific Name: ${data['scientific_name']}
          Description: ${data['description']}
          Planting Information:
          - Optimal Planting Time: ${data['planting_information']['optimal_planting_time']}
          - Seeding Rate: ${data['planting_information']['seeding_rate']}
          - Planting Depth: ${data['planting_information']['planting_depth']}
          Growth Cycle:
          - Germination Period: ${data['growth_cycle']['germination_period']}
          - Vegetative Stage: ${data['growth_cycle']['vegetative_stage']}
          - Flowering Period: ${data['growth_cycle']['flowering_period']}
          - Maturation Period: ${data['growth_cycle']['maturation_period']}
          Pests and Diseases:
          ${data['pests_and_diseases'].map((item) => '''
          - ${item['name']} (${item['type']}): ${item['symptoms']}
            Prevention: ${item['prevention']}
            Treatment: ${item['treatment']}
          ''').join('\n')}
          Watering Requirements:
          - Frequency: ${data['watering_requirements']['frequency']}
          - Method: ${data['watering_requirements']['method'].join(', ')}
          - Amount: ${data['watering_requirements']['amount']}
          Nutrient Requirements:
          ${data['nutrient_requirements']['fertilizer_type'].map((item) => '''
          - ${item['name']}: ${item['application_rate']}
          ''').join('\n')}
          - Soil pH: ${data['nutrient_requirements']['soil_pH']}
          Harvesting Information:
          - Harvest Time: ${data['harvesting_information']['harvest_time']}
          - Indicators: ${data['harvesting_information']['indicators']}
          - Methods: ${data['harvesting_information']['methods']}
          Storage Information:
          - Conditions: ${data['storage_information']['conditions']}
          - Shelf Life: ${data['storage_information']['shelf_life']}
          - Pests: ${data['storage_information']['pests'].join(', ')}
          Market Information:
          - Average Yield: ${data['market_information']['average_yield']}
          - Market Price: ${data['market_information']['market_price']}
          - Demand Trends: ${data['market_information']['demand_trends']}
          Related Crops: ${data['related_crops'].join(', ')}
          Additional Resources:
          ${data['additional_resources'].map((item) => '''
          - ${item['type']}: ${item['link']}
          ${item['title'] != null ? 'Title: ${item['title']}' : ''}
          ''').join('\n')}
          ''';
        });
      } else {
        setState(() {
          warningMessage = "Failed to load crop information.";
          cropInfo = ""; // Clear the previous info
        });
      }
    } catch (e) {
      setState(() {
        warningMessage = "Error fetching data: $e";
        cropInfo = ""; // Clear the previous info
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          TextField(
            controller: _cropController,
            decoration: InputDecoration(
              labelText: 'Enter crop name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: fetchCropInfo,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Get Crop Info'),
          ),
          SizedBox(height: 16),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            )
          else if (warningMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                warningMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            )
          else
            Text(
              cropInfo,
              style: TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }
}
