import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Complete extends StatefulWidget {
  const Complete({Key? key}) : super(key: key);

  @override
  _CompleteState createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  String _selectedGender = 'Gender';
  String _selectedLocation = 'Location';
  List<String> countries = [];

  @override
  void initState() {
    super.initState();
    _selectedLocation = 'Location'; // Set initial value
    fetchCountries(); // Fetch countries when the widget initializes
  }

  Future<void> fetchCountries() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3001/countries'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        countries = List<String>.from(data.map((country) => country['name']));
      });
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
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 50,
              backgroundImage: NetworkImage(
                'https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=',
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
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
                    // Perform an action when the button is pressed
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFAFAFA), // Set the button color
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
