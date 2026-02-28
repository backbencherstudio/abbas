import '../../entities/profile/personal_info_entity.dart';
import '../../repositories/profile/edit_personal_info_repository.dart';

class EditPersonalInfoUseCase {
  final EditPersonalInfoRepository repository;

  EditPersonalInfoUseCase({required this.repository});

  Future<PersonalInfoEntity> execute(PersonalInfoEntity personalInfo) async {
    return await repository.updatePersonalInfo(personalInfo);
  }

  Future<PersonalInfoEntity> getPersonalInfo() async {
    return await repository.getPersonalInfo();
  }
}
