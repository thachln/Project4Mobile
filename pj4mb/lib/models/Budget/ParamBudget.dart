class ParamPudget {
  late int userId;
  late DateTime fromDate;
  late DateTime toDate;

  ParamPudget({required this.userId, required this.fromDate, required this.toDate});

  ParamPudget.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fromDate = DateTime.parse(json['fromDate']);
    toDate = DateTime.parse(json['toDate']);
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fromDate'] = this.fromDate.toIso8601String();
    data['toDate'] = this.toDate.toIso8601String();
    return data;
  }

}