
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Complete(),
    ),
  );
}

class Complete extends StatefulWidget {
  const Complete({Key? key}) : super(key: key);

  @override
  _CompleteState createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  String _selectedGender = 'Gender';
  String _selectedLocation = 'Location';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Complete your profile',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
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
                fillColor: Color.fromARGB(255, 168, 175, 238),
                filled: true,
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
                fillColor: Color.fromARGB(255, 168, 175, 238),
                filled: true,
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
                fillColor: Color.fromARGB(255, 168, 175, 238),
                filled: true,
                prefixIcon: Icon(
                  Icons.group,
                  color: Colors.black,
                ),
                hintText: 'Select your gender',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              value: _selectedGender,
              items: <String>['Gender', 'Male', 'Female','Other']
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
                fillColor: Color.fromARGB(255, 168, 175, 238),
                filled: true,
                prefixIcon: Icon(
                  Icons.location_on,
                  color: Colors.black,
                ),
                hintText: 'Select your location',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              value: _selectedLocation,
              items: <String>['Location', 'Tunis', 'Ariana','Beja','Sousse','Sfax','Ben Arous','Jandouba','Nabeul','Siliana',
              'Kef','Zaghouan','Monastir','Kairouan','Mahdia','Kasserine','Sidi Bou Zid','Gafsa','Touzer','Sfax',
              'Kbeli','Mednine','Tatouine','Bizerte' ]
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
               maxLines: 5,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 168, 175, 238),
                filled: true,
               
                hintText: ' bio',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 16),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30),
  child:Center(
  child: ElevatedButton(
    onPressed: () {
      // Perform an action when the button is pressed
    },
      style: ElevatedButton.styleFrom(
      primary: Color.fromARGB(255, 168, 175, 238), // Set the background color
    ),
    child: Text('Finish'),
  ),
),),
],
),
);
}
}