
import 'dart:convert';
import 'package:watchlist/watchlist/models/group_model.dart';


import 'package:http/http.dart' as http;
class SymbolsRepo{
static Future<List<GroupModel>>fetchPost()async{
  var client = http.Client();
    List<GroupModel> postList = [];
    try {
      var response = await client
          .get(Uri.parse('http://5e53a76a31b9970014cf7c8c.mockapi.io/msf/getContacts'));

var result=jsonDecode(response.body);
      for (int i = 0; i < result.length; i++) {
        GroupModel post =
            GroupModel.fromJson(result[i]);
            post.checked = false;
        postList.add(post);
      }
      return postList;
}
catch(e){
  return [];
}
}}