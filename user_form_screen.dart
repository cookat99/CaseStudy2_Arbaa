import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  String name;
  String gender;
  int age;
  DateTime dateOfBirth;
  String occupation;

  UserDetails({
    required this.name,
    required this.gender,
    required this.age,
    required this.dateOfBirth,
    required this.occupation,
  });
}

class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _gender = '';
  int _age = 0;
  DateTime? _dateOfBirth;
  String _occupation = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details Form'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name.';
                }
                return null;
              },
              onSaved: (value) => _name = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Gender'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your gender.';
                }
                return null;
              },
              onSaved: (value) => _gender = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Age'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age.';
                }
                return null;
              },
              onSaved: (value) => _age = int.parse(value ?? '0'),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Date of Birth'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your date of birth.';
                }
                return null;
              },
              onSaved: (value) {
                // Parse the date from the string value
                // For example: '2023-06-22'
                _dateOfBirth = DateTime.parse(value ?? '');
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Occupation'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your occupation.';
                }
                return null;
              },
              onSaved: (value) => _occupation = value ?? '',
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a UserDetails object from the form inputs
      UserDetails userDetails = UserDetails(
        name: _name,
        gender: _gender,
        age: _age,
        dateOfBirth: _dateOfBirth!,
        occupation: _occupation,
      );

      // Call a method to save the user details to Firestore
      _saveUserDetails(userDetails);
    }
  }

  void _saveUserDetails(UserDetails userDetails) {
    FirebaseFirestore.instance
        .collection('users')
        .add({
          'name': userDetails.name,
          'gender': userDetails.gender,
          'age': userDetails.age,
          'dateOfBirth': userDetails.dateOfBirth,
          'occupation': userDetails.occupation,
        })
        .then((value) => {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Success'),
                    content: Text('User details saved successfully!'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/details');
                        },
                      ),
                    ],
                  );
                },
              ),
            })
        .catchError((error) => {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text('Failed to save user details.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              ),
            });
  }
}
