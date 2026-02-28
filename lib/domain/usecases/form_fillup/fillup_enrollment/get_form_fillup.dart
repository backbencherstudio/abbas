
import '../../../entities/community/post.dart';
import '../../../repositories/form_fillup/fillup_enrollment/fillup_enrollment_repository.dart';

class GetPosts {
  final FormFillRepository repo;
  GetPosts(this.repo);

  Future<List<Post>> call() => repo.getPosts();
}
