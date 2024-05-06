class ResetPass {
  late String token;
  late String password;
  late String confirmPassword;

  ResetPass({required this.token, required this.password, required this.confirmPassword});

  ResetPass.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    return data;
  }
}