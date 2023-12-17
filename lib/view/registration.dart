import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:project_fyp/models/dry.dart';
import 'package:project_fyp/models/slots.dart';
import 'package:project_fyp/shared/config.dart';
import 'loginscreen.dart';

class RegistrationScreen extends StatefulWidget {
  final Slot slot;
  final Dry dry;
  const RegistrationScreen({super.key, required this.slot, required this.dry});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController rePassword = TextEditingController();

  String eula = "";
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  void _registerAccount() {
    String _name = name.text;
    String _email = email.text;
    String _phone = phone.text;
    String _password = password.text;
    String _rePassword = rePassword.text;

    if (_password != _rePassword) {
      Fluttertoast.showToast(
          msg: "Please check your password and try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    //Dialog for conformation

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerUser(_name, _email, _password, _phone);
              },
            ),
            TextButton(
              child: Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 270,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(90)),
                    color: Color.fromARGB(255, 26, 96, 194),
                    gradient: LinearGradient(
                        colors: [
                          (Color.fromARGB(255, 59, 119, 203)),
                          (Color.fromARGB(255, 19, 93, 197))
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 70),
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Image.asset('assets/images/login_laundry.png'),
                      height: 150,
                      width: 150,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20, top: 20),
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "Registration Page",
                        style: TextStyle(fontSize: 20, color: Colors.white70),
                      ),
                    )
                  ],
                )),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200]),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: name,
                  textInputAction: TextInputAction.next,
                  validator: (val) => val!.isEmpty || (val.length < 3)
                      ? "name must be longer than 3"
                      : null,
                  cursorColor: const Color.fromARGB(255, 59, 119, 203),
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 59, 119, 203),
                      ),
                      hintText: "Enter Name",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200]),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: email,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      val!.isEmpty || !val.contains("@") || !val.contains(".")
                          ? "enter a valid email"
                          : null,
                  cursorColor: const Color.fromARGB(255, 59, 119, 203),
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 59, 119, 203),
                      ),
                      hintText: "Enter Email",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200]),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: phone,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  validator: (val) => val!.isEmpty || (val.length < 3)
                      ? "phone must be digit"
                      : null,
                  cursorColor: const Color.fromARGB(255, 59, 119, 203),
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 59, 119, 203),
                      ),
                      hintText: "Enter Phone",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200]),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (val) => validatePassword(val.toString()),
                  obscureText: _passwordVisible,
                  cursorColor: const Color.fromARGB(255, 59, 119, 203),
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      icon: const Icon(
                        Icons.vpn_key,
                        color: Color.fromARGB(255, 59, 119, 203),
                      ),
                      hintText: "Password",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[200]),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: rePassword,
                  validator: (val) {
                    validatePassword(val.toString());
                    if (val != password.text) {
                      return "password do not match";
                    } else {
                      return null;
                    }
                  },
                  obscureText: _passwordVisible,
                  cursorColor: const Color.fromARGB(255, 59, 119, 203),
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      icon: const Icon(
                        Icons.vpn_key,
                        color: Color.fromARGB(255, 59, 119, 203),
                      ),
                      hintText: "Re-Password",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.blue,
                  ),
                  child: ElevatedButton(
                    onPressed: _registerAccount,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              const SizedBox(height: 15),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(" You already have an accounr? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (Content) => LoginScreen(
                                      slot: widget.slot,
                                      dry: widget.dry,
                                    )));
                      },
                      child: Text("Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.amber)),
                    )
                  ]),
            ],
          )),
    ));
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.?[A-Z])(?=.?[a-z])(?=.*?[0-9]).{10,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void _registerUser(String name, String email, String password, String phone) {
    try {
      http.post(Uri.parse("${ServConfig.Serv}php/register_user.php"), body: {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "register": "register"
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);

          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);

          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
