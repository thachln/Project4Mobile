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


class GetDetailReportDebtParam{
  late int userId;
  late DateTime fromDate;
  late DateTime toDate;
  late int index;

  GetDetailReportDebtParam({required this.userId, required this.fromDate, required this.toDate, required this.index});

  GetDetailReportDebtParam.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    fromDate = DateTime.parse(json['fromDate']);
    toDate = DateTime.parse(json['toDate']);
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['fromDate'] = this.fromDate.toIso8601String();
    data['toDate'] = this.toDate.toIso8601String();
    data['index'] = this.index;
    return data;
  }
}

class DetailReportDebtData{
  final int id;
  late int userId;
  final String name;
  final int categoryId;
  final String creditor;
  final double amount;
  final DateTime dueDate;
  late DateTime? paidDate;
  late bool isPaid;
  final String notes;
  late int index;

  DetailReportDebtData({required this.id, required this.userId, required this.name, required this.categoryId, required this.creditor, required this.amount, required this.dueDate, required this.paidDate, required this.isPaid, required this.notes});

  factory DetailReportDebtData.fromJson(Map<String, dynamic> json) {
    return DetailReportDebtData(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      categoryId: json['categoryId'],
      creditor: json['creditor'],
      amount: json['amount'],
      dueDate: DateTime.parse(json['dueDate']),
      paidDate: json['paidDate'] != null ? DateTime.parse(json['paidDate']) : null,
      isPaid: json['isPaid'],
      notes: json['notes'],
      
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['categoryId'] = this.categoryId;
    data['creditor'] = this.creditor;
    data['amount'] = this.amount;
    data['dueDate'] = this.dueDate.toIso8601String();
    data['paidDate'] = this.paidDate != null ? this.paidDate!.toIso8601String() : null;
    data['isPaid'] = this.isPaid;
    data['notes'] = this.notes;
    data['index'] = this.index;
    return data;
  }
}