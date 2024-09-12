import 'dart:convert';
import 'package:agrifrontend/AI%20pages/personal%20advice/all_courses.dart';
import 'package:agrifrontend/AI%20pages/personal%20advice/personalized_advice_page.dart';
import 'package:agrifrontend/home/home_page.dart';
import 'package:agrifrontend/home/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
              icon:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
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
  Map<String, dynamic>? cropData; // Allow null values to handle no data
  String warningMessage = "";
  bool isLoading = false;

  Future<void> fetchCropInfo() async {
    final cropName = _cropController.text.trim();
    if (cropName.isEmpty) {
      setState(() {
        warningMessage = "Please enter a crop name.";
        cropData = null; // Clear the previous data
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
          cropData = data; // Assign the fetched data to cropData
        });
      } else {
        setState(() {
          warningMessage = "Failed to load crop information.";
          cropData = null; // Clear the previous data
        });
      }
    } catch (e) {
      setState(() {
        warningMessage = "Error fetching data: $e";
        cropData = null; // Clear the previous data
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // Assigning the controller to the TextField
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

            // Show the loader while fetching the crop data
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (cropData == null)
              Text(
                warningMessage.isNotEmpty
                    ? warningMessage
                    : "No data available.",
                style: TextStyle(color: Colors.red),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crop Name: ${cropData!["crop_name"]}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Scientific Name: ${cropData!["scientific_name"]}',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    cropData!["description"],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Planting Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildPlantingInfo(cropData!["planting_information"]),
                  SizedBox(height: 16),
                  Text(
                    'Growth Cycle',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildGrowthCycle(cropData!["growth_cycle"]),
                  SizedBox(height: 16),
                  Text(
                    'Pests and Diseases',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildPestsAndDiseases(cropData!["pests_and_diseases"]),
                  SizedBox(height: 16),
                  Text(
                    'Watering Requirements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildWateringRequirements(
                      cropData!["watering_requirements"]),
                  SizedBox(height: 16),
                  Text(
                    'Nutrient Requirements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildNutrientRequirements(
                      cropData!["nutrient_requirements"]),
                  SizedBox(height: 16),
                  MarkdownBody(
                    data: '### Additional Resources:\n' +
                        cropData!["additional_resources"]
                            .map<String>((resource) =>
                                '[${resource["title"]}](${resource["link"]})')
                            .join("\n"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantingInfo(Map<String, dynamic> plantingInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Optimal Planting Time: ${plantingInfo["optimal_planting_time"]}'),
        ...plantingInfo["geographic_location"].map<Widget>((location) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Region: ${location["region"]}'),
              Text('Climate Type: ${location["climate_type"]}'),
              Text('Soil Type: ${location["soil_type"]}'),
              Text(
                  'Recommended Varieties: ${location["recommended_varieties"].join(", ")}'),
            ],
          );
        }).toList(),
        Text('Seeding Rate: ${plantingInfo["seeding_rate"]}'),
        Text('Planting Depth: ${plantingInfo["planting_depth"]}'),
      ],
    );
  }

  Widget _buildGrowthCycle(Map<String, dynamic> growthCycle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Germination Period: ${growthCycle["germination_period"]}'),
        Text('Vegetative Stage: ${growthCycle["vegetative_stage"]}'),
        Text('Flowering Period: ${growthCycle["flowering_period"]}'),
        Text('Maturation Period: ${growthCycle["maturation_period"]}'),
      ],
    );
  }

  Widget _buildPestsAndDiseases(List<dynamic> pestsAndDiseases) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pestsAndDiseases.map<Widget>((pest) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${pest["name"]} (${pest["type"]})'),
            Text('Symptoms: ${pest["symptoms"]}'),
            Text('Prevention: ${pest["prevention"]}'),
            Text('Treatment: ${pest["treatment"]}'),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildWateringRequirements(Map<String, dynamic> wateringRequirements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Frequency: ${wateringRequirements["frequency"]}'),
        Text('Method: ${wateringRequirements["method"].join(", ")}'),
        Text('Amount: ${wateringRequirements["amount"]}'),
      ],
    );
  }

  Widget _buildNutrientRequirements(Map<String, dynamic> nutrientRequirements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          nutrientRequirements["fertilizer_type"].map<Widget>((fertilizer) {
        return Text('${fertilizer["name"]}: ${fertilizer["application_rate"]}');
      }).toList(),
    );
  }
}
