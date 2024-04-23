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
  //

  //Category
  static const String GetCategory = '$baseUrl/categories/user/{userId}';
  //

}