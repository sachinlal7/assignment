import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invoice_app/constants_colors.dart';
import 'package:http/http.dart' as http;
import 'package:invoice_app/model/custModels.dart';
import 'package:invoice_app/model/cust_list_model.dart';

class ClientDetails extends StatefulWidget {
  final String clientId;
  ClientDetails({super.key, required this.clientId});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  bool isLoading = true;

  List data = [];

  Future<void> fetchClientDetails() async {
    final clientId = widget.clientId;

    final url = "https://compughost.space/exam/api/customer/";
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
          final clientNumber = clientData['mobile'];
          final clienEmail = clientData['email'] as String;
          print("name of client $clientName");

          // Now you have the clientName for the given clientId
          if (mounted) {
            setState(() {
              userrname = clientName;
              userrNumber = clientNumber;
              userrEmail = clienEmail;
            });
          }
          break; // No need to continue searching
        }
      }
    } else {
      // Handle error case
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchClientDetails();
  }

  @override
  Widget build(BuildContext context) {
    print("client build");
    return Scaffold(
      backgroundColor: Color_green,
      appBar: AppBar(
        title: Text("Information"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage("assets/images/person.jpg"),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name"),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Email"),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Phone"),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userrname),
                  SizedBox(
                    height: 5,
                  ),
                  Text(userrNumber),
                  SizedBox(
                    height: 5,
                  ),
                  Text(userrEmail),
                  SizedBox(
                    height: 5,
                  ),
                ],
              )
            ],
          ),
         
        
       
        ],
      ),
    );
  }
}