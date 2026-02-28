// presentation/viewmodels/home/home_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../../../domain/entities/home/home.dart';
import '../../../domain/usecases/home/get_home_data.dart';

class HomeViewModel extends ChangeNotifier {
  final GetHomeData getHomeData;
  HomeViewModel(this.getHomeData);

  bool loading = false;
  HomeEntity? data;
  String? error;

  Future<void> load(String userId) async {
    loading = true; error = null; notifyListeners();
    try {
      data = await getHomeData(userId);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }
}
