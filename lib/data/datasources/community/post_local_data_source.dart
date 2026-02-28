import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../models/community/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getPosts();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final String assetPath;
  PostLocalDataSourceImpl({this.assetPath = 'assets/dummy_data/posts.json'});

  @override
  Future<List<PostModel>> getPosts() async {
    final raw = await rootBundle.loadString(assetPath);
    final list = jsonDecode(raw) as List;
    return list.map((e) => PostModel.fromJson(e)).toList();
  }
}
