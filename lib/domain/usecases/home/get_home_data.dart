// domain/usecases/home/get_home_data.dart
import '../../entities/home/home.dart';
import '../../repositories/home/home_repository.dart';

class GetHomeData {
  final HomeRepository repo;
  GetHomeData(this.repo);
  Future<HomeEntity> call(String userId) => repo.getHome(userId);
}
