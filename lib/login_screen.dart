import 'package:flutter/material.dart';
import 'meal_list_screen.dart'; // Import home screen for navigation

// This is the login/register screen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to get text from input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variable to track if user wants to login or register
  bool isLoginMode = true;

  // Function to handle login
  void handleLogin() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // TODO: Add real login logic here (Firebase, API, etc.)
    print('Login: $email');

    // Navigate to home screen after successful login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  // Function to handle registration
  void handleRegister() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    // TODO: Add real registration logic here (Firebase, API, etc.)
    print('Register: $email');

    // Show success message and switch to login mode
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Account created! Please login.')));

    setState(() {
      isLoginMode = true;
      passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // Light gray background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 40),

                // App Title
                Text(
                  'Meal Planner',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 80),

                // Welcome Text
                Text(
                  isLoginMode ? 'Welcome back!' : 'Create Account!',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 16),

                // Subtitle
                Text(
                  isLoginMode
                      ? "Let's get you signed in."
                      : "Let's get you started.",
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),

                SizedBox(height: 40),

                // Email Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9), // Light mint green
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 20,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Password Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE8F5E9), // Light mint green
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true, // Hides password
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 20,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Register/Login Toggle Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Toggle between login and register mode
                      setState(() {
                        isLoginMode = !isLoginMode;
                      });
                    },
                    child: Text(
                      isLoginMode ? 'Register' : 'Back to Login',
                      style: TextStyle(
                        color: Color(0xFF4CAF50), // Green color
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Main Action Button (Login/Register)
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLoginMode) {
                        handleLogin();
                      } else {
                        handleRegister();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50), // Green button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isLoginMode ? 'Log In' : 'Register',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // OR Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey[400], thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey[400], thickness: 1),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // Google Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlinedButton(
                    onPressed: () {
                      // Google sign in logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Google Sign In coming soon!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFFE8F5E9),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.g_mobiledata, size: 32, color: Colors.black),
                        SizedBox(width: 12),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Apple Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlinedButton(
                    onPressed: () {
                      // Apple sign in logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Apple Sign In coming soon!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFFE8F5E9),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.apple, size: 28, color: Colors.black),
                        SizedBox(width: 12),
                        Text(
                          'Continue with Apple',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Clean up controllers when widget is removed
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
