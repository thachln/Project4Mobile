class ChangeInfor{
  late String username;
  late String email;
  late bool confirmNewEmail;

  ChangeInfor({required this.username, required this.email, required this.confirmNewEmail});

  ChangeInfor.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    confirmNewEmail = json['confirmNewEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['confirmNewEmail'] = this.confirmNewEmail;
    return data;
  }
}