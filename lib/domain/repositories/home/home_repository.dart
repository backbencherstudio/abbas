// domain/repositories/home/home_repository.dart
import '../../entities/home/home.dart';

abstract class HomeRepository {
  Future<HomeEntity> getHome(String userId);
}
