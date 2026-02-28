
import '../../entities/profile/personal_info_entity.dart';


abstract class EditPersonalInfoRepository {
  Future<PersonalInfoEntity> updatePersonalInfo(PersonalInfoEntity personalInfo);
  Future<PersonalInfoEntity> getPersonalInfo();
}

