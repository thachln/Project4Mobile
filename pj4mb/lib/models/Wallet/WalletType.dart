class WalletType{
  final int TypeID;
  final String TypeName;

  WalletType({required this.TypeID,required this.TypeName});


  factory WalletType.fromJson(Map<String, dynamic> json) {
    return WalletType(
      TypeID: json['typeId'],
      TypeName: json['typeName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'typeId': TypeID,
    'typeName': TypeName,
  };

}