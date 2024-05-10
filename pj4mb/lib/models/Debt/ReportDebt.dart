class ReportDebtData{
  late String name;
  late int number;

  ReportDebtData({required this.name, required this.number});

  ReportDebtData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['number'] = this.number;
    return data;
  }
}