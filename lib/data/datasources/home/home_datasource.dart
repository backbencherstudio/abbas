// data/datasources/home/home_datasource.dart
abstract class HomeDataSource {
  Future<Map<String, dynamic>> fetchHome(String userId);
}
