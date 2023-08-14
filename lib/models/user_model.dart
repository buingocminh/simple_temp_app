class UserModel {
  final String name;
  final String email;
  String accessToken;

  UserModel({
    required this.accessToken,
    required this.email,
    required this.name,
  });

  UserModel.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      email = json['email'],
      accessToken = json['accessToken'];
  UserModel.empty() : 
    name = "",
    email = "",
    accessToken = "";
}