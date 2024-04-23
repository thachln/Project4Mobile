class WalletType{
  final String TypeID;
  final String TypeName;

  WalletType({required this.TypeID,required this.TypeName});


  factory WalletType.fromJson(Map<String, dynamic> json) {
    return WalletType(
      TypeID: json['TypeID'],
      TypeName: json['TypeName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'TypeID': TypeID,
    'TypeName': TypeName,
  };

}