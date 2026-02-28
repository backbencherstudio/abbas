// domain/usecases/profile/get_personal_info_usecase.dart

import '../../entities/profile/personal_info_entity.dart';
import '../../repositories/profile/personal_info_repository.dart';

class GetPersonalInfoUseCase {
  final PersonalInfoRepository repository;

  GetPersonalInfoUseCase({required this.repository});

  Future<PersonalInfoEntity> call() async {
    return await repository.getPersonalInfo();
  }
}
