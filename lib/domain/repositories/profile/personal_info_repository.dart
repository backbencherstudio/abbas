// domain/repositories/profile/personal_info_repository.dart
import '../../entities/profile/personal_info_entity.dart';

abstract class PersonalInfoRepository {
  Future<PersonalInfoEntity> getPersonalInfo();
}
