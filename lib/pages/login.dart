import 'dart:convert';

import 'package:carilaundry2/controller/AuthController.dart';
import 'package:carilaundry2/core/apiConstant.dart';
import 'package:carilaundry2/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:carilaundry2/utils/constants.dart';
import 'package:carilaundry2/utils/helper.dart';
import 'package:carilaundry2/widgets/app_button.dart';
import 'package:carilaundry2/widgets/input_widget.dart';
import 'package:carilaundry2/widgets/custom_snackbar.dart';

import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Authcontroller _authcontroller;
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authcontroller = Authcontroller();
    // Inisialisasi controller jika belum dilakukan di AuthController
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  String Name = "";

  void _login(String email, String password) async {
  if (email.isEmpty) {
    _showErrorDialog("Email harus diisi.");
    return;
  }

  if (password.isEmpty) {
    _showErrorDialog("Password harus diisi.");
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('${Apiconstant.BASE_URL}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String Name = responseData['user']['name']; // Ambil nama pengguna dari respons API
      CustomSnackbar.showSuccess(context, "Login Berhasil!");

      // Navigasi ke Dashboard dengan membawa nama pengguna
      print("Sending user name: $Name");
      Navigator.pushReplacementNamed(
        context,
        "/dashboard",
        arguments: Name, // Kirim nama pengguna sebagai arguments
      );
    } else {
      final responseData = jsonDecode(response.body);
      String errorMessage =
          responseData['message'] ?? "Login gagal. Periksa data anda";
      _showErrorDialog(errorMessage);
    }
  } catch (e) {
    _showErrorDialog(
      "An error occurred. Please check your connection and try again.",
    );
  }
}

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: 0.0,
                top: -20.0,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    "assets/images/washing_machine_illustration.png",
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 15.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                FlutterIcons.keyboard_backspace_mdi,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              "Log in to your account",
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height - 20.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Lets make a generic input widget
                              SizedBox(
                                height: 25.0,
                              ),
                              CustomField(
                                label: 'Email',
                                controller: emailController,
                                isPassword: false,
                                textInputType: TextInputType.emailAddress,
                                radius: 10,
                              ),
                              SizedBox(height: 25.0),
                              CustomField(
                                label: 'Password',
                                controller: passwordController,
                                isPassword: true,
                                textInputType: TextInputType.text,
                                radius: 10,
                              ),
                              SizedBox(height: 15.0),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Forgot Password?",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Constants.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              AppButton(
                                type: ButtonType.PRIMARY,
                                text: "Log In",
                                onPressed: () {
                                  _login(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
