class EndPoint{

  static const String baseUrl = 'http://192.168.1.3:8080/api'; // Sửa lại ip máy
  //static const String baseUrl = 'http://172.16.39.60:8080/api'; // Sửa lại ip máy

  //Login
  static const String SignIn = '$baseUrl/auth/signin';
  static const String SignUp = '$baseUrl/auth/signup';
  //

  //Transaction
  static const String Get5TransactionNewest = '$baseUrl/transactions/getTop5NewTransaction/users/{userId}';
  static const String Get5TransactionHigtest = '$baseUrl/transactions/getTop5TransactionHightestMoney';
  static const String InsertTransaction = '$baseUrl/transactions/create';
  static const String UpdateTransaction = '$baseUrl/transactions/update/{id}';
  static const String DeleteTransaction = '$baseUrl/transactions/delete/{id}';
  static const String GetTransactionWithTime = '$baseUrl/transactions/GetTransactionWithTime';
  static const String GetTransactionReport = '$baseUrl/transactions/GetTransactionReport';
  static const String GetTransactionReportMonth = '$baseUrl/transactions/GetTransactionReportMonth';
  static const String GetTransactionById = '$baseUrl/transactions/{id}';
  //


  //Bill
  static const String GetBillExpired = '$baseUrl/bills/getBillExpired';
  static const String GetBillActive = '$baseUrl/bills/getBillActive';
  static const String InsertBill = '$baseUrl/bills/create';
  static const String UpdateBill = '$baseUrl/bills/update/{id}';
  static const String DeleteBill = '$baseUrl/bills/delete/{id}';
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
  static const String GetCategoryWithId = '$baseUrl/categories/getCategoryByCategoryId/{categoryId}';
  static const String InsertCategory = '$baseUrl/categories/create';
  static const String UpdateCategory = '$baseUrl/categories/update';
  static const String GetIcon = '$baseUrl/categories/icons';
  static const String DeleteCategory = '$baseUrl/categories/delete{categoryID}';
  //

  //Budget
  static const String InsertBudget = '$baseUrl/budgets/create';
  static const String GetBudgetWithTime = '$baseUrl/budgets/getBudgetWithTime';
  static const String GetBudgetWithID = '$baseUrl/budgets/{id}';
  static const String UpdateBudget = '$baseUrl/budgets/update/{id}';
  static const String DeleteBudget = '$baseUrl/budgets/delete/{id}';
  //
}