// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'user-profile.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// void main() {
//   runApp(MaterialApp(
//     home: Complete(),
//   ));
// }

// class Complete extends StatefulWidget {
//   const Complete({Key? key}) : super(key: key);

//   @override
//   _CompleteState createState() => _CompleteState();
// }

// class _CompleteState extends State<Complete> {
//   String _selectedGender = 'Gender';
//   String _selectedLocation = 'Location';
//   List<String> countries = [];
//   String? _imageUrl;

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController detailsController = TextEditingController();

//   File? _selectedImage;

//   @override
//   void initState() {
//     super.initState();
//     _selectedLocation = 'Location'; // Set initial value
//     fetchCountries(); // Fetch countries when the widget initializes
//   }

//   Future<void> fetchCountries() async {
//     final response = await http.get(Uri.parse('http://10.0.2.2:3001/countries'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         countries = List<String>.from(data.map((country) => country['name']));
//       });
//     }
//   }

//   Future<void> sendUpdateRequest() async {
//     final String name = nameController.text;
//     final int age = int.tryParse(ageController.text) ?? 0;
//     final String gender = _selectedGender;
//     final String location = _selectedLocation;
//     final String bio = detailsController.text;

//     // Prepare the request body
//     final Map<String, dynamic> requestBody = {
//       'name': name,
//       'age': age,
//       'gender': gender,
//       'location': location,
//       'details': bio,
//     };

//     final response = await http.put(
//       Uri.parse('http://10.0.2.2:3001/up/updateuser/ayoubnfaidh@gmail.com'),
//       body: json.encode(requestBody),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       // Update successful
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => UserProfilePage()),
//       );
//     } else {
//       // Update failed
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text('Update Failed'),
//           content: const Text('Unable to update user profile.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

// Future<void> uploadImageToCloudinary(File imageFile) async {
//   final url = Uri.parse('https://api.cloudinary.com/v1_1/dkplhzt8t/image/upload');
//   final request = http.MultipartRequest('POST', url);
//   request.headers['X-Upload-Preset'] = '<your-upload-preset>';
//   request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

//   final response = await request.send();

//   if (response.statusCode == 200) {
//     final responseData = await response.stream.transform(utf8.decoder).join();
//     final data = json.decode(responseData);
//     setState(() {
//       _imageUrl = data['secure_url']; // Update the _imageUrl variable
//     });
//   }
// }

//   Future<void> pickImage() async {
//     final imagePicker = ImagePicker();
//     final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFAFAFA), // Set the background color
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           'Complete your profile',
//           style: TextStyle(
//             fontSize: 24,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
//               child: GestureDetector(
//                 onTap: pickImage,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.black,
//                   radius: 50,
//                   backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
//                   child: _selectedImage == null ? Icon(Icons.person, color: Colors.white) : null,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Color(0xFFFAFAFA), // Set the text field color
//                   prefixIcon: Icon(
//                     Icons.person,
//                     color: Colors.black,
//                   ),
//                   hintText: 'username',
//                   hintStyle: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: TextField(
//                 controller: ageController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Color(0xFFFAFAFA), // Set the text field color
//                   prefixIcon: Icon(
//                     Icons.calendar_month,
//                     color: Colors.black,
//                   ),
//                   hintText: ' age',
//                   hintStyle: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Color(0xFFFAFAFA), // Set the dropdown color
//                   prefixIcon: Icon(
//                     Icons.group,
//                     color: Colors.black,
//                   ),
//                   hintText: 'Select your gender',
//                   hintStyle: TextStyle(color: Colors.grey),
//                 ),
//                 value: _selectedGender,
//                 items: <String>['Gender', 'Male', 'Female', 'Other']
//                     .map<DropdownMenuItem<String>>(
//                   (String value) => DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   ),
//                 )
//                     .toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedGender = newValue ?? '';
//                   });
//                 },
//               ),
//             ),
//             SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: GestureDetector(
//                 onTap: () {
//                   // Open the dropdown manually
//                   FocusScope.of(context).unfocus();
//                   showDialog(
//                     context: context,
//                     builder: (_) => DropdownDialog(
//                       value: _selectedLocation,
//                       items: countries,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedLocation = newValue ?? '';
//                           Navigator.of(context).pop(); // Close the dialog
//                         });
//                       },
//                     ),
//                   );
//                 },
//                 child: InputDecorator(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xFFFAFAFA), // Set the dropdown color
//                     prefixIcon: Icon(
//                       Icons.location_on,
//                       color: Colors.black,
//                     ),
//                     hintText: 'Select your location',
//                     hintStyle: TextStyle(color: Colors.grey),
//                   ),
//                   isEmpty: _selectedLocation == 'Location',
//                   child: Text(_selectedLocation),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: TextField(
//                 controller: detailsController,
//                 maxLines: 5,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Color(0xFFFAFAFA), // Set the text field color
//                   hintText: ' bio',
//                   hintStyle: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30),
//               child: Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (_) => AlertDialog(
//                         title: const Text('Confirmation'),
//                         content: const Text('Are you sure you want to finish your profile?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop(); // Close the confirmation dialog
//                               sendUpdateRequest(); // Send the update request
//                             },
//                             child: const Text('Yes'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop(); // Close the confirmation dialog
//                             },
//                             child: const Text('No'),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     primary: Color(0xFF284855), // Set the button color
//                   ),
//                   child: const Text('Finish'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class DropdownDialog extends StatelessWidget {
//   final String value;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;

//   const DropdownDialog({
//     required this.value,
//     required this.items,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 final item = items[index];
//                 return ListTile(
//                   title: Text(item),
//                   onTap: () {
//                     onChanged(item);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user-profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  List<String> countries = [];
  String? _imageUrl;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedLocation = 'Location'; // Set initial value
    fetchCountries(); // Fetch countries when the widget initializes
  }

  Future<void> fetchCountries() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3001/countries'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        countries = List<String>.from(data.map((country) => country['name']));
      });
    }
  }

  Future<void> sendUpdateRequest() async {
    final String name = nameController.text;
    final int age = int.tryParse(ageController.text) ?? 0;
    final String gender = _selectedGender;
    final String location = _selectedLocation;
    final String bio = detailsController.text;

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'name': name,
      'age': age,
      'gender': gender,
      'location': location,
      'details': bio,
    };

    final response = await http.put(
      Uri.parse('http://10.0.2.2:3001/up/updateuser/ayoubnfaidh@gmail.com'),
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Update successful
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserProfilePage()),
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

  Future<void> uploadImageToCloudinary(File imageFile) async {
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/dkplhzt8t/image/upload');
    final request = http.MultipartRequest('POST', url);
    request.headers['X-Upload-Preset'] = '<your-upload-preset>';
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.transform(utf8.decoder).join();
      final data = json.decode(responseData);
      setState(() {
        _imageUrl = data['secure_url']; // Update the _imageUrl variable
      });
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
                  fillColor: Color(0xFFFAFAFA), // Set the text field color
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
                  fillColor: Color(0xFFFAFAFA), // Set the text field color
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
                  fillColor: Color(0xFFFAFAFA), // Set the dropdown color
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
              child: GestureDetector(
                onTap: () {
                  // Open the dropdown manually
                  FocusScope.of(context).unfocus();
                  showDialog(
                    context: context,
                    builder: (_) => DropdownDialog(
                      value: _selectedLocation,
                      items: countries,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLocation = newValue ?? '';
                          Navigator.of(context).pop(); // Close the dialog
                        });
                      },
                    ),
                  );
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFAFAFA), // Set the dropdown color
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    hintText: 'Select your location',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  isEmpty: _selectedLocation == 'Location',
                  child: Text(_selectedLocation),
                ),
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
                  fillColor: Color(0xFFFAFAFA), // Set the text field color
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

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'user-profile.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// void main() {
//   runApp(MaterialApp(
//     home: Complete(),
//   ));
// }

// class Complete extends StatefulWidget {
//   const Complete({Key? key}) : super(key: key);

//   @override
//   _CompleteState createState() => _CompleteState();
// }

// class _CompleteState extends State<Complete> {
//   String _selectedGender = 'Gender';
//   String _selectedLocation = 'Location';
//   List<String> countries = [];
//   String? _imageUrl;

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController detailsController = TextEditingController();

//   File? _selectedImage;

//   @override
//   void initState() {
//     super.initState();
//     _selectedLocation = 'Location'; // Set initial value
//     fetchCountries(); // Fetch countries when the widget initializes
//   }

//   Future<void> fetchCountries() async {
//     final response =
//         await http.get(Uri.parse('http://10.0.2.2:3001/countries'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         countries = List<String>.from(data.map((country) => country['name']));
//       });
//     }
//   }

//   Future<void> sendUpdateRequest() async {
//     final String name = nameController.text;
//     final int age = int.tryParse(ageController.text) ?? 0;
//     final String gender = _selectedGender;
//     final String location = _selectedLocation;
//     final String bio = detailsController.text;

//     // Prepare the request body
//     final Map<String, dynamic> requestBody = {
//       'name': name,
//       'age': age,
//       'gender': gender,
//       'location': location,
//       'details': bio,
//     };

//     final response = await http.put(
//       Uri.parse('http://10.0.2.2:3001/up/updateuser/:userId'),
//       body: json.encode(requestBody),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       // Update successful
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => UserProfilePage()),
//       );
//     } else {
//       // Update failed
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text('Update Failed'),
//           content: const Text('Unable to update user profile.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   Future<void> uploadImageToCloudinary(File imageFile) async {
//     final url =
//         Uri.parse('https://api.cloudinary.com/v1_1/dkplhzt8t/image/upload');
//     final request = http.MultipartRequest('POST', url);
//     request.headers['X-Upload-Preset'] = '<your-upload-preset>';
//     request.files
//         .add(await http.MultipartFile.fromPath('file', imageFile.path));

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final responseData = await response.stream.transform(utf8.decoder).join();
//       final data = json.decode(responseData);
//       setState(() {
//         _imageUrl = data['secure_url']; // Update the _imageUrl variable
//       });
//     }
//   }

//   Future<void> pickImage() async {
//     final imagePicker = ImagePicker();
//     final pickedImage =
//         await imagePicker.pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//       });

//       await uploadImageToCloudinary(
//           _selectedImage!); // Upload the selected image
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
  

//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 70),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 16),
//                 Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Complete your profile',
//                   style: TextStyle(
//                     fontSize: 24,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
//                 child: GestureDetector(
//                   onTap: pickImage,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.black,
//                     radius: 50,
//                     backgroundImage: _selectedImage != null
//                         ? FileImage(_selectedImage!)
//                         : null,
//                     child: _selectedImage == null
//                         ? Icon(Icons.person, color: Colors.white)
//                         : null,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xFFFAFAFA), // Set the text field color
//                     prefixIcon: Icon(
//                       Icons.person,
//                       color: Colors.black,
//                     ),
//                     hintText: 'username',
//                     hintStyle: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: TextField(
//                   controller: ageController,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xFFFAFAFA), // Set the text field color
//                     prefixIcon: Icon(
//                       Icons.calendar_month,
//                       color: Colors.black,
//                     ),
//                     hintText: ' age',
//                     hintStyle: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xFFFAFAFA), // Set the dropdown color
//                     prefixIcon: Icon(
//                       Icons.group,
//                       color: Colors.black,
//                     ),
//                     hintText: 'Select your gender',
//                     hintStyle: TextStyle(color: Colors.grey),
//                   ),
//                   value: _selectedGender,
//                   items: <String>['Gender', 'Male', 'Female', 'Other']
//                       .map<DropdownMenuItem<String>>(
//                         (String value) => DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         ),
//                       )
//                       .toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedGender = newValue ?? '';
//                     });
//                   },
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: GestureDetector(
//                   onTap: () {
//                     // Open the dropdown manually
//                     FocusScope.of(context).unfocus();
//                     showDialog(
//                       context: context,
//                       builder: (_) => DropdownDialog(
//                         value: _selectedLocation,
//                         items: countries,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             _selectedLocation = newValue ?? '';
//                             Navigator.of(context).pop(); // Close the dialog
//                           });
//                         },
//                       ),
//                     );
//                   },
//                   child: InputDecorator(
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Color(0xFFFAFAFA), // Set the dropdown color
//                       prefixIcon: Icon(
//                         Icons.location_on,
//                         color: Colors.black,
//                       ),
//                       hintText: 'Select your location',
//                       hintStyle: TextStyle(color: Colors.grey),
//                     ),
//                     isEmpty: _selectedLocation == 'Location',
//                     child: Text(_selectedLocation),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: TextField(
//                   controller: detailsController,
//                   maxLines: 5,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xFFFAFAFA), // Set the text field color
//                     hintText: ' bio',
//                     hintStyle: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (_) => AlertDialog(
//                           title: const Text('Confirmation'),
//                           content: const Text(
//                               'Are you sure you want to finish your profile?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context)
//                                     .pop(); // Close the confirmation dialog
//                                 sendUpdateRequest(); // Send the update request
//                               },
//                               child: const Text('Yes'),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context)
//                                     .pop(); // Close the confirmation dialog
//                               },
//                               child: const Text('No'),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Color(0xFF284855), // Set the button color
//                     ),
//                     child: const Text('Finish'),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DropdownDialog extends StatelessWidget {
//   final String value;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;

//   const DropdownDialog({
//     required this.value,
//     required this.items,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 final item = items[index];
//                 return ListTile(
//                   title: Text(item),
//                   onTap: () {
//                     onChanged(item);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'user-profile.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';

// void main() {
//   runApp(MaterialApp(
//     home: Complete(),
//   ));
// }

// class Complete extends StatefulWidget {
//   const Complete({Key? key}) : super(key: key);

//   @override
//   _CompleteState createState() => _CompleteState();
// }

// class _CompleteState extends State<Complete> {
//   String _selectedGender = 'Gender';
//   String _selectedLocation = 'Location';
//   List<String> countries = [];
//   String? _imageUrl;

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController detailsController = TextEditingController();

//   File? _selectedImage;

//   @override
//   void initState() {
//     super.initState();
//     _selectedLocation = 'Location'; // Set initial value
//     fetchCountries(); // Fetch countries when the widget initializes
//   }

//   Future<void> fetchCountries() async {
//     final response = await http.get(Uri.parse('http://10.0.2.2:3001/countries'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         countries = List<String>.from(data.map((country) => country['name']));
//       });
//     }
//   }

  // Future<void> sendUpdateRequest() async {
  //   final String name = nameController.text;
  //   final int age = int.tryParse(ageController.text) ?? 0;
  //   final String gender = _selectedGender;
  //   final String location = _selectedLocation;
  //   final String bio = detailsController.text;

  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final userId = user.uid;

  //     final requestBody = {
  //       'name': name,
  //       'age': age,
  //       'gender': gender,
  //       'address': location,
  //       'details': bio,
  //     };

  //     final url = Uri.parse('http://10.0.2.2:3001/up/updateuser/$userId');
  //     final response = await http.put(
  //       url,
  //       body: jsonEncode(requestBody),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       // Update successful
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => UserProfilePage()),
  //       );
  //     } else {
  //       // Update failed
  //       showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //           title: const Text('Update Failed'),
  //           content: const Text('Unable to update user profile.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   }
  // }



// Future<void> sendUpdateRequest() async {
//   final String name = nameController.text;
//   final int age = int.tryParse(ageController.text) ?? 0;
//   final String gender = _selectedGender;
//   final String location = _selectedLocation;
//   final String bio = detailsController.text;

//   final user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     final userId = user.uid;

//     final requestBody = {
//       'name': name,
//       'age': age,
//       'gender': gender,
//       'address': location,
//       'details': bio,
//     };

//     final url = Uri.parse('http://10.0.2.2:3001/up/updateuser/$userId');
//     try {
//       final response = await http.put(
//         url,
//         body: jsonEncode(requestBody),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         // Update successful
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => UserProfilePage()),
//         );
//       } else {
//         // Update failed
//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: const Text('Update Failed'),
//             content: const Text('Unable to update user profile.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     } catch (error) {
//       // Log the error to the console
//       print('Error updating user: $error');
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text('Error'),
//           content: const Text('An error occurred while updating user profile.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }



//   Future<void> uploadImageToCloudinary(File imageFile) async {
//     final url = Uri.parse('https://api.cloudinary.com/v1_1/dkplhzt8t/image/upload');
//     final request = http.MultipartRequest('POST', url);
//     request.headers['X-Upload-Preset'] = '<your-upload-preset>';
//     request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final responseData = await response.stream.transform(utf8.decoder).join();
//       final data = json.decode(responseData);
//       setState(() {
//         _imageUrl = data['secure_url']; // Update the _imageUrl variable
//       });
//     }
//   }

//   Future<void> pickImage() async {
//     final imagePicker = ImagePicker();
//     final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       setState(() {
//         _selectedImage = File(pickedImage.path);
//       });

//       await uploadImageToCloudinary(_selectedImage!); // Upload the selected image
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 70),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 16),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Complete your profile',
//                   style: TextStyle(
//                     fontSize: 24,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
//                 child: GestureDetector(
//                   onTap: pickImage,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.black,
//                     radius: 50,
//                     backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
//                     child: _selectedImage == null ? Icon(Icons.person, color: Colors.white) : null,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xFFFAFAFA), // Set the text field color
//                     prefixIcon: Icon(
//                       Icons.person,
//                       color: Colors.black,
//                     ),
//                     hintText: 'username',
//                     hintStyle: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: TextField(
//                   controller: ageController,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xFFFAFAFA), // Set the text field color
//                     prefixIcon: Icon(
//                       Icons.calendar_month,
//                       color: Colors.black,
//                     ),
//                     hintText: ' age',
//                     hintStyle: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xFFFAFAFA), // Set the dropdown color
//                     prefixIcon: Icon(
//                       Icons.group,
//                       color: Colors.black,
//                     ),
//                     hintText: 'Select your gender',
//                     hintStyle: TextStyle(color: Colors.grey),
//                   ),
//                   value: _selectedGender,
//                   items: <String>['Gender', 'Male', 'Female', 'Other']
//                       .map<DropdownMenuItem<String>>(
//                         (String value) => DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         ),
//                       )
//                       .toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedGender = newValue ?? '';
//                     });
//                   },
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: GestureDetector(
//                   onTap: () {
//                     // Open the dropdown manually
//                     FocusScope.of(context).unfocus();
//                     showDialog(
//                       context: context,
//                       builder: (_) => DropdownDialog(
//                         value: _selectedLocation,
//                         items: countries,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             _selectedLocation = newValue ?? '';
//                             Navigator.of(context).pop(); // Close the dialog
//                           });
//                         },
//                       ),
//                     );
//                   },
//                   child: InputDecorator(
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Color(0xFFFAFAFA), // Set the dropdown color
//                       prefixIcon: Icon(
//                         Icons.location_on,
//                         color: Colors.black,
//                       ),
//                       hintText: 'Select your location',
//                       hintStyle: TextStyle(color: Colors.grey),
//                     ),
//                     isEmpty: _selectedLocation == 'Location',
//                     child: Text(_selectedLocation),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: TextField(
//                   controller: detailsController,
//                   maxLines: 5,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Color(0xFFFAFAFA), // Set the text field color
//                     hintText: ' bio',
//                     hintStyle: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 child: Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (_) => AlertDialog(
//                           title: const Text('Confirmation'),
//                           content: const Text('Are you sure you want to finish your profile?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop(); // Close the confirmation dialog
//                                 sendUpdateRequest(); // Send the update request
//                               },
//                               child: const Text('Yes'),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop(); // Close the confirmation dialog
//                               },
//                               child: const Text('No'),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Color(0xFF284855), // Set the button color
//                     ),
//                     child: const Text('Finish'),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DropdownDialog extends StatelessWidget {
//   final String value;
//   final List<String> items;
//   final ValueChanged<String?> onChanged;

//   const DropdownDialog({
//     required this.value,
//     required this.items,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             width: double.infinity,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 final item = items[index];
//                 return ListTile(
//                   title: Text(item),
//                   onTap: () {
//                     onChanged(item);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
