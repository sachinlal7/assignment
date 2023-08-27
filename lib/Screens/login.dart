import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invoice_app/Screens/dashboard.dart';
import 'package:invoice_app/Screens/forgotPassword.dart';
import 'package:invoice_app/constants_colors.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invoice_app/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLogin = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController(text: "sachinlal006@gmail.com");
  TextEditingController passwordController = TextEditingController(text: "sach1234");

  bool isUserLoggedIn = false;

  void login(String email, password) async {
    var url = Uri.parse("https://compughost.space/exam/api/login");
    var response = await http
        .post(url, body: {'email': email, 'password': password});
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        print("data $data");
        final token = data['token'];
        print(token);
        

        var prefs = await SharedPreferences.getInstance();
        var setToken = prefs.setString(ACCESSKEY, token);
        print("set token $setToken");
        

       

        if (mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: ((context) => DashBoard())));
        }

        isLogin = true;

        Fluttertoast.showToast(
            msg: "Login Sucessfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);

        print("Login Successfully");
      } else {
        if (mounted) {
          print("Login Failed");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color_orange,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                ),
                Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 55,
                  width: 370,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5))),
                  child: TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                        hintText: "Username",
                        contentPadding: EdgeInsets.only(left: 10),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter username";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 0.5),
                Container(
                  height: 55,
                  width: 370,
                  color: Colors.white,
                  child: TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: "Password",
                        contentPadding: EdgeInsets.only(left: 10),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Password";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 0.5),
                SizedBox(
                  height: 0.5,
                ),
                SizedBox(height: 0.5),
                GestureDetector(
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      login(userNameController.text.toString(),
                          passwordController.text.toString());
                    }

                    // (Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => DashBoard())));

                    // isLogin == true
                    //     ? (Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => DashBoard())))
                    //     : print("error login");

                    // login(eMailController.text.toString(),
                    //     passwordController.text.toString());

                    // login(eMailController.text.toString(),
                    //     passwordController.text.toString());
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => DashBoard()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.059,
                    width: MediaQuery.of(context).size.height * 0.432,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: Center(
                        child: Text(
                      "LOGIN",
                      style: TextStyle(
                          color: Color_orange,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 1.8,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getData() async {
    var prefs = await SharedPreferences.getInstance();
    var getKey = prefs.getString(ACCESSKEY);
   

    var KeyToken = getKey != null ? getKey : "No access key found";
   
    print("key token $KeyToken");
    print("get key $getKey");


  }
}
