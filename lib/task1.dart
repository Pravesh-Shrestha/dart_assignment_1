// =============================
// BANKING SYSTEM IN DART
// Clean & Simple Version
// =============================

// -------- INTERFACE -----------
abstract class InterestBearing {
  double calculateInterest();
}

// -------- BASE ABSTRACT CLASS -----------
abstract class BankAccount {
  final int accountNumber;
  final String accountHolder;
  double _balance;

  BankAccount({
    required this.accountNumber,
    required this.accountHolder,
    required double balance,
  }) : _balance = balance;

  // Getter & Setter (Encapsulation)
  double get balance => _balance;
  set balance(double value) => _balance = value;

  // Abstract methods (Abstraction)
  void deposit(double amount);
  void withdraw(double amount);

  void displayInfo() {
    print('===========================');
    print('Account Number: $accountNumber');
    print('Account Holder: $accountHolder');
    print('Balance: $_balance');
  }
}

// -------- SAVINGS ACCOUNT -----------
class SavingsAccount extends BankAccount implements InterestBearing {
  int withdrawalCount = 0;
  static const double minBalance = 500;
  static const double interestRate = 0.02;

  SavingsAccount({
    required super.accountNumber,
    required super.accountHolder,
    required super.balance,
  });

  @override
  void deposit(double amount) {
    _balance += amount;
    print('Deposited: \$$amount | New Balance: \$$_balance');
  }

  @override
  void withdraw(double amount) {
    if (withdrawalCount >= 3) {
      print('Withdrawal limit reached (3 per month).');
      return;
    }
    if (_balance - amount < minBalance) {
      print('Cannot withdraw. Minimum balance of \$$minBalance required.');
      return;
    }
    _balance -= amount;
    withdrawalCount++;
    print('Withdrawn: \$$amount | Remaining Balance: \$$_balance');
  }

  @override
  double calculateInterest() => _balance * interestRate;

  @override
  void displayInfo() {
    super.displayInfo();
    print('Account Type: Savings');
    print('Interest (2%): \$${calculateInterest()}');
  }
}

// -------- CHECKING ACCOUNT -----------
class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35;

  CheckingAccount({
    required super.accountNumber,
    required super.accountHolder,
    required super.balance,
  });

  @override
  void deposit(double amount) {
    _balance += amount;
    print('Deposited: \$$amount | New Balance: \$$_balance');
  }

  @override
  void withdraw(double amount) {
    _balance -= amount;
    if (_balance < 0) {
      _balance -= overdraftFee;
      print('Overdraft! Fee of \$$overdraftFee applied.');
    }
    print('Withdrawn: \$$amount | Remaining Balance: \$$_balance');
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Account Type: Checking');
  }
}

// -------- PREMIUM ACCOUNT -----------
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000;
  static const double interestRate = 0.05;

  PremiumAccount({
    required super.accountNumber,
    required super.accountHolder,
    required super.balance,
  });

  @override
  void deposit(double amount) {
    _balance += amount;
    print('Deposited: \$$amount | New Balance: \$$_balance');
  }

  @override
  void withdraw(double amount) {
    if (_balance - amount < minBalance) {
      print('Cannot withdraw. Must maintain \$$minBalance minimum.');
      return;
    }
    _balance -= amount;
    print('Withdrawn: \$$amount | Remaining Balance: \$$_balance');
  }

  @override
  double calculateInterest() => _balance * interestRate;

  @override
  void displayInfo() {
    super.displayInfo();
    print('Account Type: Premium');
    print('Interest (5%): \$${calculateInterest()}');
  }
}

// -------- BANK CLASS -----------
class Bank {
  final List<BankAccount> accounts = [];

  void createAccount(BankAccount account) {
    accounts.add(account);
    print('Account created for ${account.accountHolder}');
  }

  BankAccount? findAccount(int accNo) {
    for (final a in accounts) {
      if (a.accountNumber == accNo) return a;
    }
    return null;
  }

  void transfer(int fromAcc, int toAcc, double amount) {
    final from = findAccount(fromAcc);
    final to = findAccount(toAcc);

    if (from == null || to == null) {
      print('Transfer failed. Invalid account number.');
      return;
    }

    from.withdraw(amount);
    to.deposit(amount);
    print(
      'Transferred \$$amount from ${from.accountHolder} to ${to.accountHolder}',
    );
  }

  void generateReport() {
    print('\n======= BANK REPORT =======');
    for (final acc in accounts) {
      acc.displayInfo();
    }
    print('===========================\n');
  }
}

// -------- MAIN FUNCTION -----------
void main() {
  final bank = Bank();

  final savings = SavingsAccount(
    accountNumber: 1001,
    accountHolder: 'Alice',
    balance: 1000,
  );

  final checking = CheckingAccount(
    accountNumber: 1002,
    accountHolder: 'Bob',
    balance: 200,
  );

  final premium = PremiumAccount(
    accountNumber: 1003,
    accountHolder: 'Charlie',
    balance: 15000,
  );

  bank.createAccount(savings);
  bank.createAccount(checking);
  bank.createAccount(premium);

  savings.withdraw(200);
  savings.withdraw(200);
  savings.withdraw(200);
  savings.withdraw(100);

  checking.withdraw(300);

  premium.withdraw(6000);
  premium.deposit(2000);

  bank.transfer(1003, 1001, 500);
  bank.generateReport();
}
