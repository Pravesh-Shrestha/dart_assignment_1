// =============================
// BANKING SYSTEM IN DART
// =============================

abstract class InterestBearing {
  double calculateInterest();
}

// -------- BASE ABSTRACT CLASS -----------
abstract class BankAccount {
  final int _accountNumber;
  final String _accountHolder;
  double _balance;
  final List<String> _transactions = [];

  BankAccount({
    required int accountNumber,
    required String accountHolder,
    required double balance,
  }) : _accountNumber = accountNumber,
       _accountHolder = accountHolder,
       _balance = balance;

  // -------- Encapsulation (Getters & Setters) --------
  int get accountNumber => _accountNumber;
  String get accountHolder => _accountHolder;
  double get balance => _balance;
  set balance(double value) => _balance = value;

  // -------- Abstract Methods (Abstraction) --------
  void deposit(double amount);
  void withdraw(double amount);

  // -------- Common Utility Methods --------
  void addTransaction(String detail) {
    _transactions.add(detail);
  }

  void showTransactions() {
    print('\nTransaction History for $_accountHolder:');
    if (_transactions.isEmpty) {
      print('No transactions yet.');
      return;
    }
    for (final t in _transactions) {
      print('- $t');
    }
  }

  void displayInfo() {
    print('===========================');
    print('Account Number: $_accountNumber');
    print('Account Holder: $_accountHolder');
    print('Balance: \$${_balance.toStringAsFixed(2)}');
  }
}

// -------- SAVINGS ACCOUNT -----------
class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawalCount = 0;
  static const double minBalance = 500;
  static const double interestRate = 0.02;

  SavingsAccount({
    required super.accountNumber,
    required super.accountHolder,
    required super.balance,
  });

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print('Deposit amount must be positive.');
      return;
    }
    balance += amount;
    addTransaction('Deposited: \$$amount');
    print(
      'Deposited: \$$amount | New Balance: \$${balance.toStringAsFixed(2)}',
    );
  }

  @override
  void withdraw(double amount) {
    if (_withdrawalCount >= 3) {
      print('Withdrawal limit reached (3 per month).');
      return;
    }
    if (balance - amount < minBalance) {
      print('Cannot withdraw. Minimum balance of \$$minBalance required.');
      return;
    }
    balance -= amount;
    _withdrawalCount++;
    addTransaction('Withdrew: \$$amount');
    print(
      'Withdrew: \$$amount | Remaining Balance: \$${balance.toStringAsFixed(2)}',
    );
  }

  @override
  double calculateInterest() => balance * interestRate;

  @override
  void displayInfo() {
    super.displayInfo();
    print('Account Type: Savings');
    print('Interest (2%): \$${calculateInterest().toStringAsFixed(2)}');
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
    if (amount <= 0) {
      print('Deposit amount must be positive.');
      return;
    }
    balance += amount;
    addTransaction('Deposited: \$$amount');
    print(
      'Deposited: \$$amount | New Balance: \$${balance.toStringAsFixed(2)}',
    );
  }

  @override
  void withdraw(double amount) {
    balance -= amount;
    if (balance < 0) {
      balance -= overdraftFee;
      addTransaction('Overdraft fee: \$$overdraftFee');
      print('Overdraft! Fee of \$$overdraftFee applied.');
    }
    addTransaction('Withdrew: \$$amount');
    print(
      'Withdrew: \$$amount | Remaining Balance: \$${balance.toStringAsFixed(2)}',
    );
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
    balance += amount;
    addTransaction('Deposited: \$$amount');
    print(
      'Deposited: \$$amount | New Balance: \$${balance.toStringAsFixed(2)}',
    );
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < minBalance) {
      print('Cannot withdraw. Must maintain \$$minBalance minimum.');
      return;
    }
    balance -= amount;
    addTransaction('Withdrew: \$$amount');
    print(
      'Withdrew: \$$amount | Remaining Balance: \$${balance.toStringAsFixed(2)}',
    );
  }

  @override
  double calculateInterest() => balance * interestRate;

  @override
  void displayInfo() {
    super.displayInfo();
    print('Account Type: Premium');
    print('Interest (5%): \$${calculateInterest().toStringAsFixed(2)}');
  }
}

// -------- STUDENT ACCOUNT -----------
class StudentAccount extends BankAccount {
  static const double maxBalance = 5000;

  StudentAccount({
    required super.accountNumber,
    required super.accountHolder,
    required super.balance,
  });

  @override
  void deposit(double amount) {
    if (balance + amount > maxBalance) {
      print('Cannot deposit. Max balance of \$$maxBalance reached.');
      return;
    }
    balance += amount;
    addTransaction('Deposited: \$$amount');
    print(
      'Deposited: \$$amount | New Balance: \$${balance.toStringAsFixed(2)}',
    );
  }

  @override
  void withdraw(double amount) {
    if (amount > balance) {
      print('Insufficient funds.');
      return;
    }
    balance -= amount;
    addTransaction('Withdrew: \$$amount');
    print(
      'Withdrew: \$$amount | Remaining Balance: \$${balance.toStringAsFixed(2)}',
    );
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Account Type: Student');
  }
}

// -------- BANK CLASS -----------
class Bank {
  final List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    if (_accounts.any((a) => a.accountNumber == account.accountNumber)) {
      print('Error: Account number ${account.accountNumber} already exists.');
      return;
    }
    _accounts.add(account);
    print('** Account created for ${account.accountHolder}');
  }

  BankAccount? findAccount(int accNo) {
    for (final a in _accounts) {
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
    from.addTransaction('Transferred \$$amount to ${to.accountHolder}');
    to.addTransaction('Received \$$amount from ${from.accountHolder}');
    print(
      'Transferred \$$amount from ${from.accountHolder} to ${to.accountHolder}',
    );
  }

  void applyMonthlyInterest() {
    print('\nApplying monthly interest...');
    for (final acc in _accounts) {
      if (acc is InterestBearing) {
        final interest = (acc as InterestBearing).calculateInterest();
        acc.deposit(interest);
        acc.addTransaction('Interest added: \$$interest');
      }
    }
  }

  void generateReport() {
    print('\n======= BANK REPORT =======');
    for (final acc in _accounts) {
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
    accountHolder: 'Ankit',
    balance: 1000,
  );

  final checking = CheckingAccount(
    accountNumber: 1002,
    accountHolder: 'Sujal',
    balance: 200,
  );

  final premium = PremiumAccount(
    accountNumber: 1003,
    accountHolder: 'Aayush',
    balance: 15000,
  );

  final student = StudentAccount(
    accountNumber: 1004,
    accountHolder: 'Nipuana',
    balance: 3000,
  );

  bank.createAccount(savings);
  bank.createAccount(checking);
  bank.createAccount(premium);
  bank.createAccount(student);

  savings.withdraw(200);
  checking.withdraw(300);
  premium.withdraw(6000);
  student.deposit(2500);
  student.withdraw(1000);

  bank.transfer(1003, 1001, 500);
  bank.applyMonthlyInterest();
  bank.generateReport();

  savings.showTransactions();
  student.showTransactions();
}
