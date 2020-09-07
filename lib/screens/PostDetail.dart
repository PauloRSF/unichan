import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Post.dart';
import '../components/PostCard.dart';
import '../notifiers/ThreadsNotifier.dart';

class PostDetail extends StatelessWidget {
  final Post post;

  PostDetail(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post #${post.no}')
      ),
      body: SingleChildScrollView(
        child: PostCard(post: post)
      )
    );
  }
}
