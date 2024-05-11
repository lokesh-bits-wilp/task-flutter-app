import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_flutter_app/pre_auth/register_screen.dart';
import 'package:task_flutter_app/post_auth/task_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool isLoggedIn = false;
  bool _isObscure = true; // Track password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              focusNode: usernameFocus,
              autocorrect: false,
              inputFormatters: [],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Username',
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter username',
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                labelStyle: TextStyle(fontSize: 16.sp, color: Colors.blue),
              ),
            ),
            SizedBox(height: 25),
            TextField(
              controller: passwordController,
              focusNode: passwordFocus,
              obscureText: _isObscure, // Toggle password visibility
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                fillColor: Colors.white,
                labelText: 'Password',
                hintText: 'Enter password',
                labelStyle: TextStyle(fontSize: 16.sp, color: Colors.blue),
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure; // Toggle password visibility
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10.w),
            SizedBox(
              width: 80.w,
              height: 12.w,
              child: ElevatedButton(
                onPressed: () {
                  print("tapped on login");
                  if (_validateInputs()) {
                    doLogin();
                  }
                },
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 17.sp, color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: const Color(0xFF666666),
                        fontSize: 16.sp,
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.40,
                      ),
                    ),
                    TextSpan(
                      text: 'Register',
                      style: TextStyle(
                        color: const Color(0xFF5A63FF),
                        fontSize: 17.sp,
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.40,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _navigateToNextScreen(context),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (usernameController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      // Show error message for empty fields
      showError("Username and password cannot be empty.");
      return false;
    }
    return true;
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskListScreen()));
  }

  Future<void> doLogin() async {
    final username = usernameController.text.trim();
    final userPassword = passwordController.text.trim();

    final user = ParseUser(username, userPassword, null);
    print(user);

    var response = await user.login();
    if (response.success) {
      showSuccess();
      setState(() {
        isLoggedIn = true;
      });
      _navigateToHomeScreen(context);
    } else {
      showError(response.error!.message);
    }
  }

  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: const Text("User was successfully logged in!"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
