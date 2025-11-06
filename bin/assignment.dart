// ===============================
// BANKING SYSTEM IN DART
// ===============================

// --------- INTERFACE -----------
abstract class InterestBearing {
  double calculateInterest();
}

// --------- ABSTRACT BASE CLASS -----------
abstract class BankAccount {
  final int _accountNumber;
  final String _accountHolder;
  double _balance;

  BankAccount(this._accountNumber, this._accountHolder, this._balance);

  // Getters and Setters (Encapsulation)
  int get accountNumber => _accountNumber;
  String get accountHolder => _accountHolder;
  double get balance => _balance;

  set balance(double amount) {
    _balance = amount;
  }

  // Abstract methods (Abstraction)
  void deposit(double amount);
  void withdraw(double amount);

  void displayInfo() {
    print('===========================');
    print('Account Number: $_accountNumber');
    print('Account Holder: $_accountHolder');
    print('Balance: $_balance');
  }
}

// --------- SAVINGS ACCOUNT -----------
class SavingsAccount extends BankAccount implements InterestBearing {
  int withdrawalCount = 0;
  static const double minBalance = 500;
  static const double interestRate = 0.02;

  SavingsAccount(super.accNo, super.holder, super.balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print('Deposited: \$$amount | New Balance: \$$balance');
  }

  @override
  void withdraw(double amount) {
    if (withdrawalCount >= 3) {
      print('Withdrawal limit reached (3 per month).');
      return;
    }
    if (balance - amount < minBalance) {
      print('Cannot withdraw. Minimum balance of \$$minBalance required.');
      return;
    }
    balance -= amount;
    withdrawalCount++;
    print('Withdrawn: \$$amount | Remaining Balance: \$$balance');
  }

  @override
  double calculateInterest() {
    return balance * interestRate;
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Account Type: Savings Account');
    print('Interest (2%): \$${calculateInterest()}');
  }
}

// --------- CHECKING ACCOUNT -----------
class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35;

  CheckingAccount(super.accNo, super.holder, super.balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print('Deposited: \$$amount | New Balance: \$$balance');
  }

  @override
  void withdraw(double amount) {
    balance -= amount;
    if (balance < 0) {
      balance -= overdraftFee;
      print('Overdraft! Fee of \$$overdraftFee applied.');
    }
    print('Withdrawn: \$$amount | Remaining Balance: \$$balance');
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Account Type: Checking Account');
  }
}

// --------- PREMIUM ACCOUNT -----------
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000;
  static const double interestRate = 0.05;

  PremiumAccount(super.accNo, super.holder, super.balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print('Deposited: \$$amount | New Balance: \$$balance');
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < minBalance) {
      print('Cannot withdraw. Must maintain \$$minBalance minimum.');
      return;
    }
    balance -= amount;
    print('Withdrawn: \$$amount | Remaining Balance: \$$balance');
  }

  @override
  double calculateInterest() {
    return balance * interestRate;
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Account Type: Premium Account');
    print('Interest (5%): \$${calculateInterest()}');
  }
}

// --------- BANK CLASS -----------
class Bank {
  List<BankAccount> accounts = [];

  void createAccount(BankAccount account) {
    accounts.add(account);
    print('Account Created for ${account.accountHolder}');
  }

  BankAccount? findAccount(int accNo) {
    for (var acc in accounts) {
      if (acc.accountNumber == accNo) {
        return acc;
      }
    }
    print('Account not found!');
    return null;
  }

  void transfer(int fromAcc, int toAcc, double amount) {
    var sender = findAccount(fromAcc);
    var receiver = findAccount(toAcc);

    if (sender == null || receiver == null) {
      print('Transfer failed. Invalid account number.');
      return;
    }

    sender.withdraw(amount);
    receiver.deposit(amount);
    print(
      'Transferred \$$amount from ${sender.accountHolder} to ${receiver.accountHolder}',
    );
  }

  void generateReport() {
    print('\n======= BANK REPORT =======');
    for (var acc in accounts) {
      acc.displayInfo();
    }
    print('===========================\n');
  }
}

// --------- MAIN FUNCTION -----------
void main() {
  Bank bank = Bank();

  // Create accounts
  SavingsAccount sa = SavingsAccount(1001, "Ankit", 1000);
  CheckingAccount ca = CheckingAccount(1002, "Sujal", 200);
  PremiumAccount pa = PremiumAccount(1003, "Nipuana", 15000);

  // Add accounts to bank
  bank.createAccount(sa);
  bank.createAccount(ca);
  bank.createAccount(pa);

  // Perform actions
  sa.withdraw(200);
  sa.withdraw(200);
  sa.withdraw(200);
  sa.withdraw(100); // should show limit reached

  ca.withdraw(300); // overdraft
  pa.withdraw(6000);
  pa.deposit(2000);

  // Transfer
  bank.transfer(1003, 1001, 500);

  // Report
  bank.generateReport();
}
