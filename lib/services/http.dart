//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> urlServicePost(String path, Map<dynamic, dynamic> body) async {
  var url = Uri.http('localhost:3000', '/api/$path');
  // var url = Uri.http('13.56.233.124:3000', '/api/$path');
  var response = await http.post(url, body: body);
  return response.body;
}

Future<int> urlServiceDelete(String path, String id) async {
  var url = Uri.http('localhost:3000', '/api/$path');
  // var url = Uri.http('13.56.233.124:3000', '/api/$path');
  var response = await http.delete(url, body: id);
  return response.statusCode;
}

Future<String> urlServiceGet(
  String path,
) async {
  try {
    var url = Uri.http('localhost:3000', '/api/$path');
    // var url = Uri.http('13.56.233.124:3000', '/api/$path');
    var response = await http.get(
      url,
    );
    return response.body;
  } catch (e) {
    return "{events: []}";
  }
}
