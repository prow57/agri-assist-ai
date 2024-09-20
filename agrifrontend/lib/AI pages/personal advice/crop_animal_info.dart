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
            builder: (context) => const HomePage(),
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
            builder: (context) => const SettingsPage(),
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
            title: const Text(
              'Animal & Crop Information',
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: const Padding(
            padding: EdgeInsets.all(16.0),
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
            icon: Icon(Icons.memory),
            label: 'Personalised AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.green[300],
        showUnselectedLabels: true, // Ensure labels are always shown
        selectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
        ),
      ),
    );
  }
}

class AnimalTabContent extends StatefulWidget {
  const AnimalTabContent({super.key});

  @override
  _AnimalTabContentState createState() => _AnimalTabContentState();
}

class _AnimalTabContentState extends State<AnimalTabContent> {
  final TextEditingController _animalController = TextEditingController();
  Map<String, dynamic>? animalData; // To store fetched animal data
  String warningMessage = "";
  bool isLoading = false;

  Future<void> fetchAnimalInfo() async {
    final animalName = _animalController.text.trim();
    if (animalName.isEmpty) {
      setState(() {
        warningMessage = "Please enter an animal name.";
        animalData = null; // Clear the previous data
        isLoading = false; // Ensure loading state is false
      });
      return;
    }

    final url = 'http://37.187.29.19:6932/livestock-info/$animalName';

    setState(() {
      isLoading = true;
      warningMessage = ""; // Clear the warning message
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          animalData = data; // Assign the fetched data to animalData
        });
      } else {
        setState(() {
          warningMessage = "Failed to load animal information.";
          animalData = null; // Clear the previous data
        });
      }
    } catch (e) {
      setState(() {
        warningMessage = "Error fetching data: $e";
        animalData = null; // Clear the previous data
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // TextField for animal input
            TextField(
              controller: _animalController,
              decoration: const InputDecoration(
                labelText: 'Enter animal name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: fetchAnimalInfo,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Get Animal Info'),
            ),
            const SizedBox(height: 16),

            // Show the loader while fetching the animal data
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (animalData == null)
              Text(
                warningMessage.isNotEmpty
                    ? warningMessage
                    : "No data available.",
                style: const TextStyle(color: Colors.red),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Animal Name: ${animalData!["animal_name"]}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Scientific Name: ${animalData!["scientific_name"]}',
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    animalData!["description"],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Diseases and Prevention',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildDiseasesAndPrevention(animalData!["diseases"]),
                  const SizedBox(height: 16),
                  const Text(
                    'Nutritional Requirements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildNutritionalRequirements(animalData!["nutritional_requirements"]),
                  const SizedBox(height: 16),
                  const Text(
                    'Breeding Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildBreedingInformation(animalData!["breeding_information"]),
                  const SizedBox(height: 16),
                  MarkdownBody(
                    data: '### Additional Resources:\n' +
                        animalData!["additional_resources"]
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

  Widget _buildDiseasesAndPrevention(List<dynamic> diseases) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: diseases.map<Widget>((disease) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Disease: ${disease["name"]} (${disease["type"]})'),
            Text('Symptoms: ${disease["symptoms"]}'),
            Text('Prevention: ${disease["prevention"]}'),
            Text('Treatment: ${disease["treatment"]}'),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildNutritionalRequirements(Map<String, dynamic> nutritionalRequirements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Intake: ${nutritionalRequirements["daily_intake"]}'),
        Text('Required Nutrients: ${nutritionalRequirements["required_nutrients"].join(", ")}'),
      ],
    );
  }

  Widget _buildBreedingInformation(Map<String, dynamic> breedingInformation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Breeding Season: ${breedingInformation["breeding_season"]}'),
        Text('Gestation Period: ${breedingInformation["gestation_period"]}'),
        Text('Offspring Count: ${breedingInformation["offspring_count"]}'),
      ],
    );
  }
}

class CropTabContent extends StatefulWidget {
  const CropTabContent({super.key});

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Assigning the controller to the TextField
            TextField(
              controller: _cropController,
              decoration: const InputDecoration(
                labelText: 'Enter crop name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: fetchCropInfo,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Get Crop Info'),
            ),
            const SizedBox(height: 16),

            // Show the loader while fetching the crop data
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (cropData == null)
              Text(
                warningMessage.isNotEmpty
                    ? warningMessage
                    : "No data available.",
                style: const TextStyle(color: Colors.red),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crop Name: ${cropData!["crop_name"]}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Scientific Name: ${cropData!["scientific_name"]}',
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    cropData!["description"],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Planting Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildPlantingInfo(cropData!["planting_information"]),
                  const SizedBox(height: 16),
                  const Text(
                    'Growth Cycle',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildGrowthCycle(cropData!["growth_cycle"]),
                  const SizedBox(height: 16),
                  const Text(
                    'Pests and Diseases',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildPestsAndDiseases(cropData!["pests_and_diseases"]),
                  const SizedBox(height: 16),
                  const Text(
                    'Watering Requirements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildWateringRequirements(
                      cropData!["watering_requirements"]),
                  const SizedBox(height: 16),
                  const Text(
                    'Nutrient Requirements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildNutrientRequirements(
                      cropData!["nutrient_requirements"]),
                  const SizedBox(height: 16),
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
