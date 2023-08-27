import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:invoice_app/subscreens/add_clients.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../constants_colors.dart';
import 'package:image_picker/image_picker.dart';

//  final bool isEdit;
final String name = "";
final formkey = GlobalKey<FormState>();

class NewClients extends StatefulWidget {
  final String? clientId;
  const NewClients({super.key, this.isEdit, this.clientId});

  final isEdit;
  @override
  State<NewClients> createState() => _NewClientsState();
}

class _NewClientsState extends State<NewClients> {
  TextEditingController customerController = TextEditingController();

  TextEditingController custEmailController = TextEditingController();

  TextEditingController custNumController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isEdit = false;
  bool dataFetched = false;
  bool isvalid = true;
  List data = [];
  String name = "";
  XFile? _image;
 
  String message = '';
  bool loading = false;
  bool showSpinner = false;
  String fetchedValue = "";

  final formkey = GlobalKey<FormState>();

  Future<void> fetchData() async {
    print("fetching data");
    await EditClientDetails();
    setState(() {
      dataFetched = true;
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
   Future<void> uploadImage() async {
    if (_image == null) {
      setState(() {
        message = 'No image selected.';
      });
      return;
    }

    // setState(() {
    //   loading = true;
    // });

    try {
      var headers = {
        "Authorization":
            "Bearer $authorizationValue", // Replace with actual token
        "Accept": "application/json",
      };
      print("image value $authorizationValue");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://compughost.space/exam/api/uploadImage"),
      );
      print(request);
      request.headers.addAll(headers);
      print(request.headers);

      request.files.add(await http.MultipartFile.fromPath(
        'image', // Replace with your server's file field name
        _image!.path,
      ));

      var response = await request.send();
      print(response.statusCode);
     String responseBody = await response.stream.bytesToString();
print('Response Body: $responseBody');
    var data  = jsonDecode(responseBody);
    print(data);
   var imageUrl = data['message']['image'];
    print(imageUrl);
     
   String baseUrl = 'https://compughost.space'; // Replace with your actual base URL
String replacedUrl = imageUrl.replaceAll('public', baseUrl);

print('Replaced URL: $replacedUrl');

      if (response.statusCode == 200) {
        setState(() {
          message = 'Image uploaded successfully.';
          print(message);
           imageController = TextEditingController(text: imageUrl);
          
        });
      } else {
        setState(() {
          message =
              'Image upload failed with status code: ${response.statusCode}';
              print(message);
        });
      }
    } catch (error) {
      setState(() {
        message = 'Error uploading image: $error';
        print(message);
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    setState(() {});
    

    // fetchEditDetails();
    // if (names.isNotEmpty) {
    //   customerController?.text = names[0];
    // }
    print("the transfrd name $name");
    if (widget.isEdit) {
      print(" object called");
      customerController = TextEditingController(text: userrname);
      custEmailController = TextEditingController(text: userrEmail);
      custNumController = TextEditingController(text: userrNumber);
      setState(() {
        
      });
      // passwordController = TextEditingController(text : userrpassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.isEdit ? "Edit Details" : "Client Details"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(45),
              height: MediaQuery.of(context).size.height * 0.20,
              width: double.maxFinite,
              child: _image != null
                  ? CircleAvatar(
                      radius: 40,
                      backgroundImage: FileImage(File(_image!.path)),
                    )
                  : SizedBox(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                      backgroundImage: image !=''? NetworkImage(replacedUrl,scale: 1): NetworkImage("http://69.49.235.253:8035/media/craig-mckay-jmURdhtm7Ng-unsplash.jpg")

                    ),
                    ),
            ),
            Form(
              key: formkey,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  width: double.maxFinite,
                  color: Color_grey,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Client Name"),
                              SizedBox(
                                width: 2,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 35,
                                    width: 200,
                                    color: Colors.white,
                                    child: TextFormField(
                                      maxLength: 30,
                                      controller: customerController,
                                      decoration: InputDecoration(
                                          counterText: "",
                                          hintText: " Customer Name",
                                          contentPadding:
                                              EdgeInsets.only(bottom: 9, left: 8),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none)),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            RegExp(r'^[\w-]+&').hasMatch(value)) {
                                          return "Enter correct Names";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Email"),
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                height: 35,
                                width: 200,
                                color: Colors.white,
                                child: TextFormField(
                                  controller: custEmailController,
                                  decoration: InputDecoration(
                                      hintText: " Email Address",
                                      contentPadding: EdgeInsets.only(left: 8),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                  validator: EmailValidator(
                                      errorText: "Enter correct Email"),
      
                                  // validator: (value) {
                                  //   if (value!.isEmpty ||
                                  //       RegExp(r'^[\w-\.]+@ ([\w-]+ \.)+[\w-]{2,5}')
                                  //           .hasMatch(value)) {
                                  //     return "correct email uid";
                                  //   } else {
                                  //     return "Enter correct email id";
                                  //   }
                                  // },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Phone"),
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                height: 35,
                                width: 200,
                                color: Colors.white,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  controller: custNumController,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintText: " Phone Number",
                                    contentPadding: EdgeInsets.only(left: 8),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty ) {
                                      return null;
                                    } else {
                                      return "enter correct phone number";
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                         Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(widget.isEdit ? "" : "password"),
                              SizedBox(
                                width: 50,
                              ),
                              widget.isEdit
                                      ? Container(): Container(
                                height: 35,
                                width: 200,
                                color: Colors.white,
                                child: TextFormField(
                                 
                                  controller: passwordController,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintText: " password",
                                    contentPadding: EdgeInsets.only(left: 8),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return null;
                                    } else {
                                      return "enter password";
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                                Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Image"),
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                height: 50,
                                width: 200,
                                color: Colors.white,
                                child: TextFormField(
                                  
                                  
                                  controller: imageController,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintText: " image url",
                                    contentPadding: EdgeInsets.only(left: 8),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty ) {
                                      return null;
                                    } else {
                                      return "enter the url";
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Upload Image"),
                              SizedBox(
                                width: 30,
                              ),
                              Container(
                                  height: 35,
                                  width: 100,
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                       SizedBox(
                                      width: 100,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            pickImage();
                                          },
                                          child: Center(child: Text("Click here"))),
                                    ),
      
                                    ],
                                  
                                  )),
                                   Container(
                                  height: 35,
                                  width: 80,
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                       SizedBox(
                                      width: 80,
                                      child: ElevatedButton(
                                          onPressed: () {
                                          uploadImage();
                                          print(finalImageUrl);
                                          },
                                          child: Center(child: Text("Upload"))),
                                    ),
      
                                    ],
                                  
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  color: Color_blue,
                                  child: Center(
                                      child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  if (formkey.currentState!.validate()) {}
      
                                  widget.isEdit
                                      ? updateData(customerIdValue)
                                      : submitData();
                                },
                                child: Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width * 0.42,
                                  color: Colors.deepOrange,
                                  child: Center(
                                      child: Text(
                                    widget.isEdit ? "Update" : "Save",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitData() async {
    
    final body = {
      "name": customerController.text.toString(),
      "email": custEmailController.text.toString(),
      "mobile": custNumController.text.toString(),
      "password" : passwordController.text.toString(),
      "image_file": imageController.text.toString(),
    };
    print(body);

    final url = "https://compughost.space/exam/api/customer";

    final uri = Uri.parse(url);
    print(authorizationValue);
    final response = await http.post(uri,
        body: body, headers: {'Authorization': 'Bearer $authorizationValue'});
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('created successfully ');
    } else {
      print('creation failed');
    }

     final circleAvatar = CircleAvatar(
      backgroundImage: NetworkImage(replacedUrl),
      radius: 40.0,
    );
    
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => AddClients()));
  }

  Future<void> EditClientDetails() async {
    print("fecthing edit client ");
    final clientId = widget.clientId;

    final url = "https://compughost.space/exam/api/customer";
    final uri = Uri.parse(url);

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $authorizationValue',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

      for (final clientData in jsonData['data']) {
        final id = clientData['id'].toString();

        if (id == clientId) {
          final clientName = clientData['name'] as String;
          final clientNumber = clientData['mobile'].toString();
          final clienEmail = clientData['email'] as String;
          // final clientPassword = clientData['password'] as String ;
          print("name of client $clientName");

          // Now you have the clientName for the given clientId
          setState(() {
            userrname = clientName;
            userrNumber = clientNumber;
            userrEmail = clienEmail;
            // userrpassword = clientPassword;
            print("value fetched");
          });
          break; // No need to continue searching
        }
      }
    } else {
      // Handle error case
    }
    setState(() {});
  }

  Future<void> updateData(String customerIdValue) async {
    final body = {
      "name": customerController.text.toString(),
      "email": custEmailController.text.toString(),
      "mobile": custNumController.text.toString(),
      "password" : passwordController.text.toString(),
      "image_file": imageController.text.toString(),
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var custKey = prefs.getString(getUser);
    print(" get user id $custKey");

    final url = "https://compughost.space/exam/api/customer/$custKey";
    final uri = Uri.parse(url);
   
    print(authorizationValue);
    print(customerIdValue);
    final response = await http.put(uri,
        body: body, headers: {'Authorization': 'Bearer $authorizationValue'});
        print(response.statusCode);
        print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('successfully updated');
    } else {
      print('update failed');
    }
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AddClients()));
    }
  }

  Future<void> fetchEditDetails() async {
    final url = Base_URL + custlistendpoint;

    final uri = Uri.parse(url);
    print("seven");

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // var getTheKey = prefs.getString(ACCESS_KEY);
    print(authorizationValue);
    final response = await http
        .get(uri, headers: {'Authorization': 'Bearer $authorizationValue'});

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var json = jsonDecode(response.body) as Map;
      var results = json['data'] as List;
      List<Map<String, dynamic>> jsonData = List.from(results);

      List<String> names =
          jsonData.map((item) => item['name'].toString()).toList();
      // print(names[0]);
      // print(names[1]);

// Now you have the list of names. You can use this list to show them in your TextField.

      // print("customer id result $custres");
      // var setTheCustId = prefs.setInt(CUST_ID, custResults);
      setState(() {
        data = results;
        print("final data $data");
      });
    } else {
      print("error");
    }
  }

  // Future<void> clearUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // prefs.remove(getKey);
  //   prefs.clear();
  //   prefs.remove(CUST_ID);
  //   prefs.reload();
  // }

  Widget customDialog(String text, warning) {
    return Dialog(
      child: SizedBox(
        height: 150,
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                color: Color_orange,
                child: Center(
                    child: Text(
                  warning,
                  style: TextStyle(color: Color_white, fontSize: 18),
                )),
              ),
            ),
            Expanded(
              child: Container(
                height: 40,
                width: 150,
                child: Row(
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color_orange),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("NO")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color_orange),
                        onPressed: () {
                          updateData(customerIdValue);

                          customerController.clear();
                          custEmailController.clear();
                          custNumController.clear();
                          isLogin = false;
                          // clearUserData();

                          Fluttertoast.showToast(
                              msg: "created successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        child: Text("YES")),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isInputValid(String Name, String email, String phone) {
    return Name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty;
  }
}