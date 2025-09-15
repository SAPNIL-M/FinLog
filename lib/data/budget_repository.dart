import 'package:flutter/material.dart';
import 'budget_models.dart';

// Abstract repository to enable swapping in a Django-backed implementation later
abstract class BudgetRepository {
  Future<BudgetSummary> getMonthlySummary({required DateTime month});
  Future<List<BudgetCategory>> getMonthlyCategories({required DateTime month});
  Future<void> addExpense({
    required DateTime date,
    required String categoryId,
    required double amount,
    String? note,
  });
}

// Temporary in-memory implementation
class InMemoryBudgetRepository implements BudgetRepository {
  final Map<String, List<BudgetCategory>> _byMonth = {};

  // Singleton to share state across pages
  static final InMemoryBudgetRepository _instance = InMemoryBudgetRepository._internal();
  factory InMemoryBudgetRepository() => _instance;
  InMemoryBudgetRepository._internal() {
    final nowKey = _key(DateTime.now());
    _byMonth[nowKey] = _seedIndianCategories();
  }

  @override
  Future<BudgetSummary> getMonthlySummary({required DateTime month}) async {
    final list = await getMonthlyCategories(month: month);
    final totalBudget = list.fold<double>(0, (s, c) => s + c.budget);
    final totalSpent = list.fold<double>(0, (s, c) => s + c.spent);
    return BudgetSummary(totalBudget: totalBudget, totalSpent: totalSpent);
  }

  @override
  Future<List<BudgetCategory>> getMonthlyCategories({required DateTime month}) async {
    final key = _key(month);
    return _byMonth[key] ?? _seedIndianCategories();
  }

  @override
  Future<void> addExpense({
    required DateTime date,
    required String categoryId,
    required double amount,
    String? note,
  }) async {
    final key = _key(date);
    final current = List<BudgetCategory>.from(_byMonth[key] ?? _seedIndianCategories());
    final idx = current.indexWhere((c) => c.id == categoryId);
    if (idx == -1) {
      // If category not found, just ignore (or add new). We'll ignore for now.
      return;
    }
    final cat = current[idx];
    final updated = BudgetCategory(
      id: cat.id,
      name: cat.name,
      budget: cat.budget,
      spent: cat.spent + amount,
      iconKey: cat.iconKey,
      color: cat.color,
    );
    current[idx] = updated;
    _byMonth[key] = current;
  }

  // Helpers
  String _key(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}';

  List<BudgetCategory> _seedIndianCategories() {
    return const [
      BudgetCategory(
        id: 'food_groceries',
        name: 'Food & Groceries',
        budget: 12000,
        spent: 7600,
        iconKey: 'food',
        color: Color(0xFFFF7966),
      ),
      BudgetCategory(
        id: 'transport',
        name: 'Transport (Metro/Auto/Taxi)',
        budget: 4000,
        spent: 1850,
        iconKey: 'transport',
        color: Color(0xFF7DFFEE),
      ),
      BudgetCategory(
        id: 'rent',
        name: 'Rent / Home Loan',
        budget: 20000,
        spent: 20000,
        iconKey: 'home',
        color: Color(0xFFE4D3FF),
      ),
      BudgetCategory(
        id: 'utilities',
        name: 'Utilities (Electricity/Water)',
        budget: 3000,
        spent: 2100,
        iconKey: 'utilities',
        color: Color(0xFFC9A7FF),
      ),
      BudgetCategory(
        id: 'mobile_internet',
        name: 'Mobile & Internet',
        budget: 1500,
        spent: 900,
        iconKey: 'internet',
        color: Color(0xFFAD7BFF),
      ),
      BudgetCategory(
        id: 'education',
        name: 'Education / Courses',
        budget: 5000,
        spent: 1200,
        iconKey: 'education',
        color: Color(0xFF00FAD9),
      ),
      BudgetCategory(
        id: 'health',
        name: 'Health & Medicines',
        budget: 2500,
        spent: 400,
        iconKey: 'health',
        color: Color(0xFFFFA699),
      ),
      BudgetCategory(
        id: 'shopping',
        name: 'Shopping',
        budget: 6000,
        spent: 3500,
        iconKey: 'shopping',
        color: Color(0xFF5E00F5),
      ),
      BudgetCategory(
        id: 'entertainment',
        name: 'Entertainment',
        budget: 3000,
        spent: 1700,
        iconKey: 'entertainment',
        color: Color(0xFF924EFF),
      ),
      BudgetCategory(
        id: 'travel',
        name: 'Travel',
        budget: 8000,
        spent: 0,
        iconKey: 'travel',
        color: Color(0xFF666680),
      ),
    ];
  }
}
