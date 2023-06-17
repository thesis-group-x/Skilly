import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user-profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import './feed/pages/home_page.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MaterialApp(
    home: Complete(),
  ));
}

class Complete extends StatefulWidget {
  const Complete({Key? key}) : super(key: key);

  @override
  _CompleteState createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  String _selectedGender = 'Gender';
  String _selectedLocation = 'Location';
  String? _imageUrl;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  File? _selectedImage;

  Future<void> sendUpdateRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    print(FirebaseAuth.instance.currentUser);

    if (user != null) {
      final userId = user.email;
      final String name = nameController.text;
      final int age = int.tryParse(ageController.text) ?? 0;
      final String gender = _selectedGender;
      final String location = _selectedLocation;
      final String bio = detailsController.text;

      Future<void> sendUpdateRequest() async {
        // Check if all fields are filled
        if (name.isEmpty ||
            age <= 0 ||
            gender == 'Gender' ||
            location == 'Location' ||
            bio.isEmpty) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Missing Information'),
              content: const Text('Please fill in all the fields.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
          //  Exit the function if any information is missing
        }
      }

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        'name': name,
        'age': age,
        'gender': gender,
        'address': location,
        'details': bio,
      };

      if (_imageUrl != null) {
        requestBody['imageUrl'] = _imageUrl;
        // Add the image URL to the request body
      }

      final response = await http.put(
        Uri.parse('http://10.0.2.2:3001/up/updateuser/$userId'),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Update successful
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Update failed
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Update Failed'),
            content: const Text('Unable to update user profile.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> uploadImageToCloudinary(File imageFile) async {
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/dkplhzt8t/image/upload');
    final request = http.MultipartRequest('POST', url);
    request.headers['X-Upload-Preset'] = 'kusldcryyyyy';
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.transform(utf8.decoder).join();
      final data = json.decode(responseData);
      setState(() {
        _imageUrl = data['secure_url']; // Update the _imageUrl variable
      });
    } else {
      // Image upload failed
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Image Upload Failed'),
          content: const Text('Unable to upload the selected image.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });

      await uploadImageToCloudinary(
          _selectedImage!); // Upload the selected image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA), // Set the background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Complete your profile',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 50,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : null,
                  child: _selectedImage == null
                      ? Icon(Icons.person, color: Colors.white)
                      : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent, // Set the text field color
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  hintText: 'username',
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent, // Set the text field color
                  prefixIcon: Icon(
                    Icons.calendar_month,
                    color: Colors.black,
                  ),
                  hintText: ' age',
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent, // Set the dropdown color
                  prefixIcon: Icon(
                    Icons.group,
                    color: Colors.black,
                  ),
                  hintText: 'Select your gender',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                value: _selectedGender,
                items: <String>['Gender', 'Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue ?? '';
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent, // Set the dropdown color
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Colors.black,
                  ),
                  hintText: 'Select your location',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                value: _selectedLocation,
                items: <String>[
                  'Location', // Add a default value if needed
                  '🇦🇫 Afghanistan',
                  '🇦🇱 Albania',
                  '🇩🇿 Algeria',
                  '🇦🇩 Andorra',
                  '🇦🇴 Angola',
                  '🇦🇬 Antigua and Barbuda',
                  '🇦🇷 Argentina',
                  '🇦🇲 Armenia',
                  '🇦🇺 Australia',
                  '🇦🇹 Austria',
                  '🇦🇿 Azerbaijan',
                  '🇧🇸 Bahamas',
                  '🇧🇭 Bahrain',
                  '🇧🇩 Bangladesh',
                  '🇧🇧 Barbados',
                  '🇧🇾 Belarus',
                  '🇧🇪 Belgium',
                  '🇧🇿 Belize',
                  '🇧🇯 Benin',
                  '🇧🇹 Bhutan',
                  '🇧🇴 Bolivia',
                  '🇧🇦 Bosnia and Herzegovina',
                  '🇧🇼 Botswana',
                  '🇧🇷 Brazil',
                  '🇧🇳 Brunei',
                  '🇧🇬 Bulgaria',
                  '🇧🇫 Burkina Faso',
                  '🇧🇮 Burundi',
                  '🇨🇻 Cape Verde',
                  '🇰🇭 Cambodia',
                  '🇨🇲 Cameroon',
                  '🇨🇦 Canada',
                  '🇨🇫 Central African Republic',
                  '🇹🇩 Chad',
                  '🇨🇱 Chile',
                  '🇨🇳 China',
                  '🇨🇴 Colombia',
                  '🇰🇲 Comoros',
                  '🇨🇩 Congo ',
                  '🇨🇷 Costa Rica',
                  '🇭🇷 Croatia',
                  '🇨🇺 Cuba',
                  '🇨🇾 Cyprus',
                  '🇨🇿 Czech Republic',
                  '🇩🇰 Denmark',
                  '🇩🇯 Djibouti',
                  '🇩🇲 Dominica',
                  '🇩🇴 Dominican Republic',
                  '🇪🇨 Ecuador',
                  '🇪🇬 Egypt',
                  '🇸🇻 El Salvador',
                  '🇬🇶 Equatorial Guinea',
                  '🇪🇷 Eritrea',
                  '🇪🇪 Estonia',
                  '🇪🇹 Ethiopia',
                  '🇫🇯 Fiji',
                  '🇫🇮 Finland',
                  '🇫🇷 France',
                  '🇬🇦 Gabon',
                  '🇬🇲 Gambia',
                  '🇬🇪 Georgia',
                  '🇩🇪 Germany',
                  '🇬🇭 Ghana',
                  '🇬🇷 Greece',
                  '🇬🇩 Grenada',
                  '🇬🇹 Guatemala',
                  '🇬🇳 Guinea',
                  '🇬🇼 Guinea-Bissau',
                  '🇬🇾 Guyana',
                  '🇭🇹 Haiti',
                  '🇭🇳 Honduras',
                  '🇭🇺 Hungary',
                  '🇮🇸 Iceland',
                  '🇮🇳 India',
                  '🇮🇩 Indonesia',
                  '🇮🇷 Iran',
                  '🇮🇶 Iraq',
                  '🇮🇪 Ireland',
                  '🇮🇱 Israel',
                  '🇮🇹 Italy',
                  '🇯🇲 Jamaica',
                  '🇯🇵 Japan',
                  '🇯🇴 Jordan',
                  '🇰🇿 Kazakhstan',
                  '🇰🇪 Kenya',
                  '🇰🇮 Kiribati',
                  '🇰🇵 North Korea',
                  '🇰🇷 South Korea',
                  '🇰🇼 Kuwait',
                  '🇰🇬 Kyrgyzstan',
                  '🇱🇦 Laos',
                  '🇱🇻 Latvia',
                  '🇱🇧 Lebanon',
                  '🇱🇸 Lesotho',
                  '🇱🇷 Liberia',
                  '🇱🇾 Libya',
                  '🇱🇮 Liechtenstein',
                  '🇱🇹 Lithuania',
                  '🇱🇺 Luxembourg',
                  '🇲🇰 North Macedonia',
                  '🇲🇬 Madagascar',
                  '🇲🇼 Malawi',
                  '🇲🇾 Malaysia',
                  '🇲🇻 Maldives',
                  '🇲🇱 Mali',
                  '🇲🇹 Malta',
                  '🇲🇭 Marshall Islands',
                  '🇲🇷 Mauritania',
                  '🇲🇺 Mauritius',
                  '🇲🇽 Mexico',
                  '🇫🇲 Micronesia',
                  '🇲🇩 Moldova',
                  '🇲🇨 Monaco',
                  '🇲🇳 Mongolia',
                  '🇲🇪 Montenegro',
                  '🇲🇦 Morocco',
                  '🇲🇿 Mozambique',
                  '🇲🇲 Myanmar',
                  '🇳🇦 Namibia',
                  '🇳🇷 Nauru',
                  '🇳🇵 Nepal',
                  '🇳🇱 Netherlands',
                  '🇳🇿 New Zealand',
                  '🇳🇮 Nicaragua',
                  '🇳🇪 Niger',
                  '🇳🇬 Nigeria',
                  '🇳🇴 Norway',
                  '🇴🇲 Oman',
                  '🇵🇰 Pakistan',
                  '🇵🇼 Palau',
                  '🇵🇸 Palestine',
                  '🇵🇦 Panama',
                  '🇵🇬 Papua New Guinea',
                  '🇵🇾 Paraguay',
                  '🇵🇪 Peru',
                  '🇵🇭 Philippines',
                  '🇵🇱 Poland',
                  '🇵🇹 Portugal',
                  '🇶🇦 Qatar',
                  '🇷🇴 Romania',
                  '🇷🇺 Russia',
                  '🇷🇼 Rwanda',
                  '🇰🇳 Saint Kitts and Nevis',
                  '🇱🇨 Saint Lucia',
                  '🇻🇨 Saint Vincent and the Grenadines',
                  '🇼🇸 Samoa',
                  '🇸🇲 San Marino',
                  '🇸🇹 Sao Tome and Principe',
                  '🇸🇦 Saudi Arabia',
                  '🇸🇳 Senegal',
                  '🇷🇸 Serbia',
                  '🇸🇨 Seychelles',
                  '🇸🇱 Sierra Leone',
                  '🇸🇬 Singapore',
                  '🇸🇰 Slovakia',
                  '🇸🇮 Slovenia',
                  '🇸🇧 Solomon Islands',
                  '🇸🇴 Somalia',
                  '🇿🇦 South Africa',
                  '🇸🇸 South Sudan',
                  '🇪🇸 Spain',
                  '🇱🇰 Sri Lanka',
                  '🇸🇩 Sudan',
                  '🇸🇷 Suriname',
                  '🇸🇪 Sweden',
                  '🇨🇭 Switzerland',
                  '🇸🇾 Syria',
                  '🇹🇼 Taiwan',
                  '🇹🇯 Tajikistan',
                  '🇹🇿 Tanzania',
                  '🇹🇭 Thailand',
                  '🇹🇱 Timor-Leste',
                  '🇹🇬 Togo',
                  '🇹🇴 Tonga',
                  '🇹🇹 Trinidad and Tobago',
                  '🇹🇳 Tunisia',
                  '🇹🇷 Turkey',
                  '🇹🇲 Turkmenistan',
                  '🇹🇻 Tuvalu',
                  '🇺🇬 Uganda',
                  '🇺🇦 Ukraine',
                  '🇦🇪 United Arab Emirates',
                  '🇬🇧 United Kingdom',
                  '🇺🇸 United States',
                  '🇺🇾 Uruguay',
                  '🇺🇿 Uzbekistan',
                  '🇻🇺 Vanuatu',
                  '🇻🇪 Venezuela',
                  '🇻🇳 Vietnam',
                  '🇾🇪 Yemen',
                  '🇿🇲 Zambia',
                  '🇿🇼 Zimbabwe',
                ]
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue ?? '';
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                controller: detailsController,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent, // Set the text field color
                  hintText: ' bio',
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text(
                            'Are you sure you want to finish your profile?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Close the confirmation dialog
                              sendUpdateRequest(); // Send the update request
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Close the confirmation dialog
                            },
                            child: const Text('No'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF284855), // Set the button color
                  ),
                  child: const Text('Finish'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownDialog extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownDialog({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    onChanged(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}