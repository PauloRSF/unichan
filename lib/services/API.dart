import 'dart:convert';
import 'package:http/http.dart';
import '../models/Post.dart';

class API {
  Future<List<Post>> getThreadsOps() async {
    Response response = await get('https://55chan.org/b/catalog.json');
    var data = json.decode(response.body);

    List<Post> posts = new List<Post>();
    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < data[i]['threads'].length; j++) {
        var post = Post.fromJson(data[i]['threads'][j]);
        post.isOp = true;
        posts.add(post);
      }
    }

    return posts;
  }

  Future<List<Post>> getFullThread(no) async {
    Response response = await get('https://55chan.org/b/res/${no}.json');
    var data = json.decode(response.body);

    if (data.containsKey('posts')) {
      List<Post> posts = List<Post>();
      for (var i = 0; i < data['posts'].length; i++) {
        var post = Post.fromJson(data['posts'][i]);
        post.isOp = false;
        posts.add(post);
      }
      return posts;
    }

  }
}