import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_page.dart';
import 'menu_page.dart';

class HomePage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome!", 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 50,
                color: Colors.indigo,
              )),
              SizedBox(height: 60),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text;
                  String password = passwordController.text;

                  if (email.isEmpty || password.isEmpty) {
                    _showErrorDialog(context, 'Please fill in all fields.');
                    return;
                  }

                  try {
                    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                    print('User logged in: ${userCredential.user}');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MenuPage()),
                    );
                  } on FirebaseAuthException catch (e) {
                    String errorMessage;
                    if (e.code == 'user-not-found') {
                      errorMessage = 'No user found for that email.';
                    } else if (e.code == 'wrong-password') {
                      errorMessage = 'Wrong password provided.';
                    } else {
                      errorMessage = 'Login failed. Please try again.';
                    }
                    _showErrorDialog(context, errorMessage);
                  } catch (e) {
                    print(e);
                    _showErrorDialog(context, 'An unknown error occurred.');
                  }
                },
                child: Text('Login', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo, 
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text("Don't have an account? Sign up",
                style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
