class EndPoint{

  static const String baseUrl = 'http://192.168.1.3:8080/api'; // Sửa lại ip máy

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
  static const String UpdateWallet = '$baseUrl/wallets/update/{walletID}';
  static const String DeleteWallet = '$baseUrl/wallets/delete/{walletID}';
  //

  //Category
  static const String GetCategory = '$baseUrl/categories/user/{userId}';
  static const String InsertCategory = '$baseUrl/categories/create';
  static const String UpdateCategory = '$baseUrl/categories/update';
  static const String GetIcon = '$baseUrl/categories/icons';
  static const String DeleteCategory = '$baseUrl/categories/delete{categoryID}';
  //

}