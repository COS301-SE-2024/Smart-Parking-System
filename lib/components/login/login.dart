import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool alreadyHaveOne = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  height: 150, // Set the height to make it small
                ),
                SizedBox(height: 20),
                if (alreadyHaveOne)
                  Text(
                    'Enter your details',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 119, 119, 119),
                    ),
                  ),
                SizedBox(height: 20),
                if (alreadyHaveOne)
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Name';
                      }
                      return null;
                    },
                  ),
                if (alreadyHaveOne) SizedBox(height: 20),
                if (alreadyHaveOne)
                  TextFormField(
                    controller: _surnameController,
                    decoration: InputDecoration(labelText: 'Surname'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Surname';
                      }
                      return null;
                    },
                  ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                if (alreadyHaveOne) SizedBox(height: 20),
                if (alreadyHaveOne)
                  TextFormField(
                    controller: _noController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    // obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Phone Number';
                      }
                      return null;
                    },
                  ),
                if (!alreadyHaveOne) SizedBox(height: 20),
                if (!alreadyHaveOne)
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Password';
                      }
                      return null;
                    },
                  ),
                if (!alreadyHaveOne)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          alreadyHaveOne = !alreadyHaveOne;
                        });
                      },
                      child: Text(
                        'Forgot Password',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                SizedBox(height: 35),
                if (alreadyHaveOne)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF613EEA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Slightly rounded corners
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform signup operation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Signup successful')),
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 130.0,
                        vertical: 15,
                      ), // Add padding to the left and right
                      child: Text('Next'),
                    ),
                  ),
                if (!alreadyHaveOne)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF613EEA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Slightly rounded corners
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform login operation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login successful')),
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 130.0,
                        vertical: 15,
                      ), // Add padding to the left and right
                      child: Text('Login'),
                    ),
                  ),
                SizedBox(height: 35),
                if (alreadyHaveOne)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        alreadyHaveOne = !alreadyHaveOne;
                      });
                    },
                    child: Text(
                      'Already have an account?\nLogin',
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (!alreadyHaveOne)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        alreadyHaveOne = !alreadyHaveOne;
                      });
                    },
                    child: Text(
                      'or Signup',
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
