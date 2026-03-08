// class CreatePostModel {
//   final String? id;
//   final Author? author;
//
//   CreatePostModel({required this.id, required this.author});
// }
//
// class Author {
//   final String? id;
//   final String? name;
//   final String? userName;
//   final String? avatar;
//
//   Author({ this.id, this.name, this.userName, this.avatar});
//
//   factory Author.formJson(Map<String, dynamic> json){
//     return Author(
//         id = json['id'];
//         name = json['name'];
//         userName = json['username'];
//     avatar = json['avatar'];
//     );
//   }
//
//   Map<String,dynamic> toJson(){
//     return {
//       'id' : id,
//       'name' : name,
//       'username' : userName,
//       'avatar' : avatar
//     };
//   }
// }