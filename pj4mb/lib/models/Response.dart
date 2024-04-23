class ResponseApi{
  final String message;
  final int status;
  final dynamic data;

  ResponseApi({required this.message,required this.status,required this.data});

  factory ResponseApi.fromJson(Map<String, dynamic> json){
    return ResponseApi(
      message: json['message'],
      status: json['status'],
      data: json['data']
    );
  }
}