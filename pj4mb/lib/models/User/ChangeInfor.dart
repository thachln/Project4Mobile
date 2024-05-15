class ChangeInfor{
  late int userId;
  late String username;
  late String email;
  late bool confirmNewEmail;

  ChangeInfor({
    required this.userId,
    required this.username,
    required this.email,
    required this.confirmNewEmail
  });

  factory ChangeInfor.fromJson(Map<String, dynamic> json) {
    return ChangeInfor(
      userId: json['userId'],
      username: json['username'],
      email: json['email'],
      confirmNewEmail: json['confirmNewEmail']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'confirmNewEmail': confirmNewEmail
    };
  }
}