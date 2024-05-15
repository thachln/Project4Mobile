class EndPoint{

  static const String baseUrl = 'http://192.168.1.2:8080/api'; // Sửa lại ip máy
  //static const String baseUrl = 'http://172.16.39.60:8080/api'; // Sửa lại ip máy

  //Account
  static const String SignIn = '$baseUrl/auth/signin';
  static const String SignUp = '$baseUrl/auth/signup';
  static const String ChangeInformation = '$baseUrl/auth/updateEmailUsernameProfile';
  static const String ResetPass = '$baseUrl/auth/updateEmailUsernameProfile/{id}';
  static const String ChangePass = '$baseUrl/auth/updateProfile/updatePassword';
  static const String ForgotPass = '$baseUrl/auth/forgot-password';
  static const String ChangePasswordWithOTP = '$baseUrl/auth/updateProfile/changePasswordWithOTP';
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
  static const String FindTransaction = '$baseUrl/transactions/FindTransaction';
  static const String GetTransactionWithBudget = '$baseUrl/transactions/getTransactionWithBudget';
  static const String GetTransactionWithSaving = '$baseUrl/transactions/getTransactionWithSaving';
  //


  //Bill
  static const String InsertBill = '$baseUrl/bills/create';
  static const String UpdateBill = '$baseUrl/bills/update/{id}';
  static const String DeleteBill = '$baseUrl/bills/delete/{id}';
  static const String findBillExpired = '$baseUrl/bills/findBillExpired';
  static const String findBillActive = '$baseUrl/bills/findBillActive';
  static const String findBillWithId = '$baseUrl/bills/{id}';
  //

  //Wallet
  static const String GetWallet = '$baseUrl/wallets/users/{userId}';
  static const String GetWalletType = '$baseUrl/wallet_types';
  static const String InsertWallet = '$baseUrl/wallets/create';
  static const String GetWalletTypeWithID = '$baseUrl/wallet_types/{typeID}';
  static const String UpdateWallet = '$baseUrl/wallets/update/{walletID}';
  static const String DeleteWallet = '$baseUrl/wallets/delete/{walletID}';
  static const String Transfer = '$baseUrl/wallets/transfer';
  static const String GetWalletWithId = '$baseUrl/wallets/{id}';
  //

  //Category
  static const String GetCategory = '$baseUrl/categories/user/{userId}';
  static const String GetCategoryWithId = '$baseUrl/categories/getCategoryByCategoryId/{categoryId}';
  static const String InsertCategory = '$baseUrl/categories/create';
  static const String UpdateCategory = '$baseUrl/categories/update';
  static const String GetIcon = '$baseUrl/categories/icons';
  static const String DeleteCategory = '$baseUrl/categories/delete/{categoryID}';
  //

  //Budget
  static const String InsertBudget = '$baseUrl/budgets/create';
  static const String GetBudgetWithTime = '$baseUrl/budgets/getBudgetWithTime';
  static const String GetBudgetWithID = '$baseUrl/budgets/{id}';
  static const String UpdateBudget = '$baseUrl/budgets/update/{id}';
  static const String DeleteBudget = '$baseUrl/budgets/delete/{id}';
  static const String getPast = '$baseUrl/budgets/getBudgetPast';
  static const String getFuture = '$baseUrl/budgets/getBudgetFuture';
  
  //

  //Debt
  static const String InsertDebt = '$baseUrl/debts/create';
  static const String UpdateDebt = '$baseUrl/debts/update/{id}';
  static const String DeleteDebt = '$baseUrl/debts/delete/{id}';
  static const String getDebtByUserId = '$baseUrl/debts/{id}';
  static const String getDebtById = '$baseUrl/debts/user/{id}';
  static const String findDebtActive = '$baseUrl/debts/findDebtActive/user/{id}';
  static const String findDebtPaid = '$baseUrl/debts/findDebtPaid/user/{id}';
  static const String UpdateIsPaid = '$baseUrl/debts/updateIsPaid/{id}';
  static const String GetReportDebt = '$baseUrl/debts/reportDebt';
  static const String FindDebt = '$baseUrl/debts/findDebt';
  static const String FindLoan = '$baseUrl/debts/findLoan';
  static const String getDetailDebtReport = '$baseUrl/debts/getDetailReportDebtParam';
  //


  //Notification
  static const String GetNotification = '$baseUrl/notifications/user/{id}';
  static const String UpdateNotification = '$baseUrl/notifications/update/{id}';
  static const String UpdateAllNotificationRead = '$baseUrl/notifications/update/{id}';
  //

  //Goal
  static const String InsertGoal = '$baseUrl/savinggoals/create';
  static const String UpdateGoal = '$baseUrl/savinggoals/update/{id}';
  static const String DeleteGoal = '$baseUrl/savinggoals/delete/{id}';
  static const String GetGoal = '$baseUrl/savinggoals/user/{id}';
  static const String findWorkingByUserId = '$baseUrl/savinggoals/findWorkingByUserId/user/{id}';
  static const String findFinishedByUserId = '$baseUrl/savinggoals/findFinishedByUserId/user/{id}';
  static const String getSavingWithSavingID = '$baseUrl/savinggoals/getSavingWithSavingID';
  static const String getSavingWithWallet = '$baseUrl/savinggoals/wallets/{walletid}/users/{userid}';
  //

  //TransactionRecurrence
  static const String InsertTransactionRecurrence = '$baseUrl/transactionsRecurring/create';
  static const String UpdateTransactionRecurrence = '$baseUrl/transactionsRecurring/update/{id}';
  static const String DeleteTransactionRecurrence = '$baseUrl/transactionsRecurring/delete/{id}';
  static const String findRecuExpired = '$baseUrl/transactionsRecurring/findRecuExpired';
  static const String findRecuActive = '$baseUrl/transactionsRecurring/findRecuActive';
  static const String getTransactionsRecurringById = '$baseUrl/transactionsRecurring/{id}';

  //
}