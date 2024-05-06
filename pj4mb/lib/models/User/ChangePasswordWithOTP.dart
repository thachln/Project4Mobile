import 'package:pj4mb/models/User/UpdatePass.dart';

class ChangePasswordWithOTP{
  final UpdatePass passwordDTO;
  final VerifyOTPDTO verifyOTPDTO;

  ChangePasswordWithOTP({required this.passwordDTO, required this.verifyOTPDTO});

  factory ChangePasswordWithOTP.fromJson(Map<String, dynamic> json) {
    return ChangePasswordWithOTP(
      passwordDTO: UpdatePass.fromJson(json['passwordDTO']),
      verifyOTPDTO: VerifyOTPDTO.fromJson(json['verifyOTPDTO']),
    );
  }

  Map<String, dynamic> toJson() => {
    'passwordDTO': passwordDTO.toJson(),
    'verifyOTPDTO': verifyOTPDTO.toJson(),
  };
}


class VerifyOTPDTO{
  final String email;
  final String pin;

  VerifyOTPDTO({required this.email, required this.pin});

  factory VerifyOTPDTO.fromJson(Map<String, dynamic> json) {
    return VerifyOTPDTO(
      email: json['email'],
      pin: json['pin'],
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'pin': pin,
  };
}