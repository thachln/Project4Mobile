class UpdatePass {
  late int userId;
  late String email;
  late String oldPassword;
  late String newPassword;
  late String confirmNewPassword;

  UpdatePass(
      {required this.userId,
      required this.email,
      required this.oldPassword,
      required this.newPassword,
      required this.confirmNewPassword});

  UpdatePass.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    oldPassword = json['oldPassword'];
    newPassword = json['newPassword'];
    confirmNewPassword = json['confirmNewPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['email'] = this.email;
    data['oldPassword'] = this.oldPassword;
    data['newPassword'] = this.newPassword;
    data['confirmNewPassword'] = this.confirmNewPassword;
    return data;
  }
}