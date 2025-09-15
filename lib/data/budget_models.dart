import 'package:flutter/material.dart';

// Backend-friendly models for future Django integration
class BudgetCategory {
  final String id; // stable key for backend
  final String name;
  final double budget; // monthly budget amount
  final double spent; // amount spent this month
  final String iconKey; // e.g., 'food', 'transport', used to map to icons/images
  final Color color; // UI accent color

  const BudgetCategory({
    required this.id,
    required this.name,
    required this.budget,
    required this.spent,
    required this.iconKey,
    required this.color,
  });

  double get progress => budget == 0 ? 0.0 : (spent / budget).clamp(0, 1).toDouble();
  double get remaining => (budget - spent).clamp(0, budget);
}

class BudgetSummary {
  final double totalBudget;
  final double totalSpent;

  const BudgetSummary({required this.totalBudget, required this.totalSpent});

  double get progress => totalBudget == 0 ? 0.0 : (totalSpent / totalBudget).clamp(0, 1).toDouble();
  double get remaining => (totalBudget - totalSpent).clamp(0, totalBudget);
}
