// class User {
//   int id;
//   String fullName;
//   String content;
//   String email;
//   String entryCount;

//   User.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         fullName = json['fullname'],
//         email = json['email'],
//         entryCount = json['entry_count'];
// }

class User {
  final String uid;
  final String type;

  User({this.uid, this.type});
}

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({this.uid, this.sugars, this.strength, this.name});
}
