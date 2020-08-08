import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../models/Post.dart';
import '../utils/post_utils.dart';

class ThreadsNotifier extends ChangeNotifier {
  final List<Post> posts = [];

  void addAll(List<Post> new_posts) {
    posts.addAll(new_posts);
    notifyListeners();
  }

  void removeAll() {
    posts.clear();
  }

  void sort(SortMethod method) {
    sortPostsList(posts, method);
    notifyListeners();
  }
}
