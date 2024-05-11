import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_flutter_app/pre_auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final FocusNode userNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create account",
              style: TextStyle(fontSize: 22.sp),
            ),
            SizedBox(height: 25),
            TextField(
              controller: username,
              focusNode: userNameFocus,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Username',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter Your Username',
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                labelStyle: TextStyle(fontSize: 16.sp, color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: email,
              focusNode: emailFocus,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Email',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter Your email',
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                labelStyle: TextStyle(fontSize: 16.sp, color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: password,
              focusNode: passwordFocus,
              obscureText: _isObscure,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Password',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter password',
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                labelStyle: TextStyle(fontSize: 16.sp, color: Colors.blue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: confirmPassword,
              focusNode: confirmPasswordFocus,
              obscureText: _isObscure,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [],
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Confirm Password',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter confirm password',
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                labelStyle: TextStyle(fontSize: 16.sp, color: Colors.blue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: 85.w,
              height: 12.w,
              child: ElevatedButton(
                onPressed: () {
                  if (_validateInputs()) {
                    doRegistration();
                  }
                },
                child: Text(
                  "Register",
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
                      text: "Already have an account? ",
                      style: TextStyle(
                        color: const Color(0xFF666666),
                        fontSize: 16.sp,
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.40,
                      ),
                    ),
                    TextSpan(
                      text: 'Login',
                      style: TextStyle(
                        color: const Color(0xFF5A63FF),
                        fontSize: 17.sp,
                        fontFamily: 'SFPro',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.40,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _navigateToLoginScreen(context),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   icon: ImageIcon(
            //     AssetImage("assets/images/back.png"),
            //     color: Colors.blue,
            //     size: 40,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  bool _validateInputs() {
    if (username.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        password.text.trim().isEmpty ||
        confirmPassword.text.trim().isEmpty) {
      showError("All fields are required");
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.text.trim())) {
      showError("Enter a valid email address");
      return false;
    }
    if (password.text != confirmPassword.text) {
      showError("Passwords do not match");
      return false;
    }
    return true;
  }

  Future<void> doRegistration() async {
    final userName = username.text.trim();
    final userEmail = email.text.trim();
    final userPassword = password.text.trim();

    final user = ParseUser.createUser(userName, userPassword, userEmail);

    var response = await user.signUp();

    if (response.success) {
      showSuccess();
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
          content: const Text("User was successfully created!"),
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
