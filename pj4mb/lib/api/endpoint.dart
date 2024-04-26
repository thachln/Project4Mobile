class EndPoint{

  static const String baseUrl = 'http://172.16.39.60:8080/api'; // Sửa lại ip máy

  //Login
  static const String SignIn = '$baseUrl/auth/signin';
  static const String SignUp = '$baseUrl/auth/signup';
  //

  //Transaction
  static const String Get5TransactionNewest = '$baseUrl/transaction';
  static const String Get5TransactionHigtest = '$baseUrl/transaction';
  //


  //Bill
  //

  //Wallet
  static const String GetWallet = '$baseUrl/wallets/users/{userId}';
  static const String GetWalletType = '$baseUrl/wallet_types';
  static const String InsertWallet = '$baseUrl/wallets/create';
  static const String GetWalletTypeWithID = '$baseUrl/wallet_types/{typeID}';
  //

  //Category
  static const String GetCategory = '$baseUrl/categories/user/{userId}';
  static const String InsertCategory = '$baseUrl/categories/create';
  static const String UpdateCategory = '$baseUrl/categories/update';
  static const String GetIcon = '$baseUrl/categories/icons';
  //

}