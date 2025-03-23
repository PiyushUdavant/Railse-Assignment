import 'package:flutter/material.dart';
import 'package:railse_technical_round/api/functions.dart';
import 'package:railse_technical_round/pages/widgets/custom_button_style.dart';
import 'package:railse_technical_round/pages/widgets/slide_and_fade_in_widget.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  OrderDetailsPageState createState() => OrderDetailsPageState();
}

class OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
          centerTitle: true,
          title: const Text("Order Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFF00E5FF)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          SafeArea(
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchOrderDetails(), // Using the imported function
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("No Data Available"));
                }

                var orderData = snapshot.data!;
                var payeeDetails = orderData['payee_details'];
                var services = orderData['service_payment_requests'];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: SlideFadeFromRight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Payment Status: ${orderData['payment_status']}",
                          style: const TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Pay ₹${orderData['total_amount_with_gst']} to ${orderData['pay_to']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF673AB7), // Deep Purple
                                Color(0xFF9C27B0), // Purple
                                Color(0xFFE040FB), // Purple Accent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.phone, color: Colors.black),
                                  SizedBox(width: 3),
                                  Text(
                                      "Mobile: ${payeeDetails['mobile_number'] ?? 'N/A'}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                                ],
                              ),
                              Text("👤 Name: ${payeeDetails['name'] ?? 'N/A'}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomButtonStyle(text: 'Record Payment'),
                            CustomButtonStyle(text: 'Add File(s)'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: const Text("Services",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(height: 10),
                        ...services.map<Widget>((service) {
                          BoxDecoration getPaymentGradient() {
                            if (service['payment_status'].toUpperCase() ==
                                "PAID") {
                              return BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF66BB6A), // Light Green
                                    Color(0xFF2E7D32), // Dark Green
                                  ],
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              );
                            } else {
                              return BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xffd32f2f), // Dark Red
                                    Color(0xfff44336), // Bright Red
                                    Color(0xffff5252), // Light Red
                                  ],
                                ),
                              );
                            }
                          }

                          return Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 200,
                              decoration: getPaymentGradient(),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Service : ${service['service']}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .white, // Contrast for better visibility
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Expense (w/o GST) : ₹${service['expense_without_gst']}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      Text(
                                        "GST : ${service['gst_percentage']}%",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      Text(
                                        "Expense (with GST) : ₹${service['expense_with_gst']}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      Text(
                                        "Paid Amount : ₹${service['paid_amount']}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      Text(
                                        "Status : ${service['payment_status']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18, // Ensures visibility
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 30,
                                      ))
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
