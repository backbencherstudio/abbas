// data/repositories/profile/personal_info_repository_impl.dart
import '../../../../domain/entities/profile/personal_info_entity.dart';
import '../../../domain/repositories/profile/personal_info_repository.dart';
import '../../datasources/profile/personal_info_data_source.dart';


class PersonalInfoRepositoryImpl implements PersonalInfoRepository {
  final PersonalInfoDataSource dataSource;

  PersonalInfoRepositoryImpl({required this.dataSource});

  @override
  Future<PersonalInfoEntity> getPersonalInfo() async {
    try {
      final response = await dataSource.getPersonalInfo();
      return PersonalInfoEntity.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}