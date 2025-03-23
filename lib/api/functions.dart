import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchOrderDetails() async {
  final url = Uri.parse('https://backend.railse.com/payment/request/get-details/20');

  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization":
      "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI4MjY2OTEyMjgxIiwicm9sZXMiOiJST0xFX0FETUlOIiwiaWF0IjoxNzQwNzMzNTE1fQ.94Nw67f47D6FMD5Ctx-5L7ReA1iGGwzmECwwDYNhu28"
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> result = jsonDecode(response.body);
    return result['data'];
  } else {
    throw Exception("Failed to fetch data: ${response.statusCode}");
  }
}
