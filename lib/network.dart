// import 'package:flutter/foundation.dart';
// import 'dart:convert';
// import 'post_model.dart';
// import 'package:http/http.dart' as http;
//
// List<PhotoModel> parsePost(String response){
//   var list = json.decode(response) as List<dynamic>;
//   List<PhotoModel> posts = list.map((e) => PhotoModel.fromJson(e)).toList();
//   return posts;
// }
// Future<List<PhotoModel>> fecthPost () async {
//   var url = Uri.parse('https://jsonplaceholder.typicode.com/photos');
//   final response = await http.get(url);
//   if(response.statusCode == 200){
//     print(response.body);
//     return compute(parsePost, response.body);
//   } else {
//     throw Exception("Get API error");
//   }
// }