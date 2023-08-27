import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:invoice_app/constants_colors.dart';
import 'package:http/http.dart' as http;

class PreviewInvoice extends StatefulWidget {
  const PreviewInvoice({super.key});

  @override
  State<PreviewInvoice> createState() => _PreviewInvoiceState();
}

class _PreviewInvoiceState extends State<PreviewInvoice> {



void getDataApi() async {
  final url = "http://69.49.235.253:8035/api/customer-list/";
  final uri = Uri.parse(url);

  try {
    final response = await http.get(uri, headers: {'Authorization': 'Bearer $authorizationValue'});

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['status'] == 'True') {
        final List<dynamic> customerList = responseData['data'];

        for (var customer in customerList) {
          final id = customer['id'];
          final name = customer['name'];
          final email = customer['email'];

          print('ID: $id');
          print('Name: $name');
          print('Email: $email');
          print('-----------------------');
        }
      } else {
        print('API returned an error message: ${responseData['message']}');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.18,
              width: double.maxFinite,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text("INV00001"),
                  Row(
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Image(
                        image: AssetImage("assets/images/order_history.png"),
                        height: 80,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date"),
                              SizedBox(
                                width: 80,
                              ),
                              Text("Due Date"),
                            ],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("31/07/2023"),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("31/07/2023"),
                                ],
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.664,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Client",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text("Product Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("Quantity",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("Unit Price",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("Total Price",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("Address",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("Fax_Number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("Payment Date",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Due Amount",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Paid Amount",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Payment Status",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.664,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Client",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Product Name",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Quantity",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Unit Price",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Total Price",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Address",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Fax_Number",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Payment Date",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Due Amount",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Paid Amount",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Payment Status",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
