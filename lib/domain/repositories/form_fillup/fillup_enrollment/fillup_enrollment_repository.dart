
import '../../../entities/community/post.dart';

abstract class FormFillRepository {
  Future<List<Post>> getPosts();
}
