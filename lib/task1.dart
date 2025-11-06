// =============================
// BANKING SYSTEM IN DART
// Final Submission Version
// =============================

abstract class InterestBearing {
  double calculateInterest();
}

// -------- BASE ABSTRACT CLASS -----------
abstract class BankAccount {
  final int accountNumber;
  final String accountHolder;
  double _balance;
  final List<String> transactions = [];

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

  void addTransaction(String detail) {
    transactions.add(detail);
  }

  void showTransactions() {
    print('\nTransaction History for $accountHolder:');
    if (transactions.isEmpty) {
      print('No transactions yet.');
      return;
    }
    for (final t in transactions) {
      print('- $t');
    }
  }

  void displayInfo() {
    print('===========================');
    print('Account Number: $accountNumber');
    print('Account Holder: $accountHolder');
    print('Balance: \$${_balance.toStringAsFixed(2)}');
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
    if (amount <= 0) {
      print('Deposit amount must be positive.');
      return;
    }
    _balance += amount;
    addTransaction('Deposited: \$$amount');
    print(
      'Deposited: \$$amount | New Balance: \$${_balance.toStringAsFixed(2)}',
    );
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
    addTransaction('Withdrew: \$$amount');
    print(
      'Withdrew: \$$amount | Remaining Balance: \$${_balance.toStringAsFixed(2)}',
    );
  }

  @override
  double calculateInterest() => _balance * interestRate;

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
    _balance += amount;
    addTransaction('Deposited: \$$amount');
    print(
      'Deposited: \$$amount | New Balance: \$${_balance.toStringAsFixed(2)}',
    );
  }

  @override
  void withdraw(double amount) {
    _balance -= amount;
    if (_balance < 0) {
      _balance -= overdraftFee;
      addTransaction('Overdraft fee: \$$overdraftFee');
      print('Overdraft! Fee of \$$overdraftFee applied.');
    }
    addTransaction('Withdrew: \$$amount');
    print(
      'Withdrew: \$$amount | Remaining Balance: \$${_balance.toStringAsFixed(2)}',
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
    _balance += amount;
    addTransaction('Deposited: \$$amount');
    print(
      'Deposited: \$$amount | New Balance: \$${_balance.toStringAsFixed(2)}',
    );
  }

  @override
  void withdraw(double amount) {
    if (_balance - amount < minBalance) {
      print('Cannot withdraw. Must maintain \$$minBalance minimum.');
      return;
    }
    _balance -= amount;
    addTransaction('Withdrew: \$$amount');
    print(
      'Withdrew: \$$amount | Remaining Balance: \$${_balance.toStringAsFixed(2)}',
    );
  }

  @override
  double calculateInterest() => _balance * interestRate;

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
    if (_balance + amount > maxBalance) {
      print('Cannot deposit. Max balance of \$$maxBalance reached.');
      return;
    }
    _balance += amount;
    addTransaction('Deposited: \$$amount');
    print(
      'Deposited: \$$amount | New Balance: \$${_balance.toStringAsFixed(2)}',
    );
  }

  @override
  void withdraw(double amount) {
    if (amount > _balance) {
      print('Insufficient funds.');
      return;
    }
    _balance -= amount;
    addTransaction('Withdrew: \$$amount');
    print(
      'Withdrew: \$$amount | Remaining Balance: \$${_balance.toStringAsFixed(2)}',
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
  final List<BankAccount> accounts = [];

  void createAccount(BankAccount account) {
    if (accounts.any((a) => a.accountNumber == account.accountNumber)) {
      print('Error: Account number ${account.accountNumber} already exists.');
      return;
    }
    accounts.add(account);
    print('** Account created for ${account.accountHolder}');
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
    from.addTransaction('Transferred \$$amount to ${to.accountHolder}');
    to.addTransaction('Received \$$amount from ${from.accountHolder}');
    print(
      'Transferred \$$amount from ${from.accountHolder} to ${to.accountHolder}',
    );
  }

  void applyMonthlyInterest() {
    print('\nApplying monthly interest...');
    for (final acc in accounts) {
      if (acc is InterestBearing) {
        final interest = (acc as InterestBearing).calculateInterest();
        acc.deposit(interest);
        acc.addTransaction('Interest added: \$$interest');
      }
    }
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
