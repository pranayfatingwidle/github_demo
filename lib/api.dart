import 'dart:async';
import "dart:collection";
import 'dart:convert';
import 'dart:io';
import "dart:math";
import "dart:core";
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:simple_auth/simple_auth.dart';

class API {


  getAsync(String url, String username, String password) async {

  String basic = 'Basic ';
  String basicAuth = base64Encode(utf8.encode('$username:$password'));
  print(basicAuth);

  final response = await http.get(url,
      headers: <String, String>{'authorization': basic + basicAuth});
  print(response.statusCode);
  print(response.body);
    return [response,basicAuth];
  }

  Future<http.Response> getAsync_token(String url, String token) async {

  String basicAuth =
      'Basic ' + token;
  print(basicAuth);

  final response = await http.get(url,
      headers: <String, String>{'authorization': basicAuth});
  print(response.statusCode);
  print(response.body);
    return response;
  }

  // Future<http.Response> postAsync(String endPoint, Map data) async {
  //   var url = this.url;

  //   var client = new http.Client();
  //   var request = new http.Request('POST', Uri.parse(url));
  //   request.headers[HttpHeaders.contentTypeHeader] =
  //   'application/json';
  //   request.headers[HttpHeaders.cacheControlHeader] = "no-cache";
  //   request.body = json.encode(data);
  //   var response = await client.send(request).then((res) => res);
  //   return http.Response.fromStream(response);
  // }

 
   
}