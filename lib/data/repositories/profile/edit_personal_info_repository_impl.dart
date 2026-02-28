// // import '../../../domain/entities/profile/personal_info_entity.dart';
// // import '../../../domain/repositories/profile/edit_personal_info_repository.dart';
// // import '../../datasources/profile/edit_personal_info_data_source.dart';
// //
// // class EditPersonalInfoRepositoryImpl implements EditPersonalInfoRepository {
// //   final EditPersonalInfoDataSource dataSource;
// //
// //   EditPersonalInfoRepositoryImpl({required this.dataSource});
// //
// //   @override
// //   Future<PersonalInfoEntity> updatePersonalInfo(PersonalInfoEntity personalInfo) async {
// //     try {
// //       final response = await dataSource.updatePersonalInfo(
// //         personalInfo.name,
// //         personalInfo.phoneNumber,
// //         personalInfo.dateOfBirth,
// //         personalInfo.experienceLevels,
// //         personalInfo.actingGoals,
// //       );
// //
// //       if (response.success) {
// //         return personalInfo;
// //       } else {
// //         throw Exception(response.message);
// //       }
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// //
// //   @override
// //   Future<PersonalInfoEntity> getPersonalInfo() async {
// //     try {
// //       final response = await dataSource.getPersonalInfo();
// //       return PersonalInfoEntity.fromJson(response);
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// // }
//
// import '../../../../domain/entities/profile/personal_info_entity.dart';
// import '../../../../domain/repositories/profile/edit_personal_info_repository.dart';
// import '../../datasources/profile/edit_personal_info_data_source.dart';
//
// class EditPersonalInfoRepositoryImpl implements EditPersonalInfoRepository {
//   final EditPersonalInfoDataSource dataSource;
//
//   EditPersonalInfoRepositoryImpl({required this.dataSource});
//
//   @override
//   Future<PersonalInfoEntity> updatePersonalInfo(PersonalInfoEntity personalInfo) async {
//     try {
//       final response = await dataSource.updatePersonalInfo(
//         personalInfo.name,
//         personalInfo.phoneNumber,
//         personalInfo.dateOfBirth,
//         personalInfo.experienceLevel,
//         personalInfo.actingGoals,
//       );
//
//       if (response.success) {
//         return personalInfo;
//       } else {
//         throw Exception(response.message);
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   @override
//   Future<PersonalInfoEntity> getPersonalInfo() async {
//     try {
//       final response = await dataSource.getPersonalInfo();
//       return PersonalInfoEntity.fromJson(response);
//     } catch (e) {
//       rethrow;
//     }
//   }
// }