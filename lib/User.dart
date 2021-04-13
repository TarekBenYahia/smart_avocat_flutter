


class User {
  final String id;
  final String email;
  final String roles;
  final String accessToken;

  User({this.id, this.email, this.roles,this.accessToken});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        id: parsedJson['_id'] ?? "",
        email: parsedJson['email'] ?? "",
        roles: parsedJson['roles'] ?? "",
        accessToken: parsedJson['accessToken'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": this.id,
      "email": this.email,
      "roles": this.roles,
      "accessToken": this.accessToken
    };
  }
}