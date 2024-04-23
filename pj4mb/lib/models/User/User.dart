class User{
  final int id;
  final String username;
  final String email;
  final String password;
  final bool is_enabled; 
  late String statusCode = "";
  late String message = "";



   User({required this.id,required this.username,required this.email,required this.password,required this.is_enabled,required this.statusCode,required this.message});
//write the fromjson and tojson method
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'] ?? "",
      is_enabled: json['enabled'],
      statusCode: "",
      message: "",
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'enabled': is_enabled,
  };

}