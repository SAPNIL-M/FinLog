import 'package:expy/common/color_extension.dart';
import 'package:expy/data/budget_models.dart';
import 'package:expy/data/budget_repository.dart';
import 'package:flutter/material.dart';

class SpendingBudgetsPage extends StatefulWidget {
  const SpendingBudgetsPage({super.key});

  @override
  State<SpendingBudgetsPage> createState() => _SpendingBudgetsPageState();
}

class _SpendingBudgetsPageState extends State<SpendingBudgetsPage> {
  late final BudgetRepository _repo;
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  Future<BudgetSummary>? _summaryFut;
  Future<List<BudgetCategory>>? _categoriesFut;

  @override
  void initState() {
    super.initState();
    _repo = InMemoryBudgetRepository();
    _load();
  }

  void _load() {
    _summaryFut = _repo.getMonthlySummary(month: _currentMonth);
    _categoriesFut = _repo.getMonthlyCategories(month: _currentMonth);
    setState(() {});
  }

  void _prevMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    _load();
  }

  void _nextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    _load();
  }

  void _pickYear() async {
    final currentYear = DateTime.now().year;
    final first = DateTime(currentYear - 10);
    final last = DateTime(currentYear + 5);
    int tempYear = _currentMonth.year;

    await showModalBottomSheet(
      context: context,
      backgroundColor: TColor.gray70,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TColor.gray60,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Text('Select year', style: TextStyle(color: TColor.primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(
                height: 300,
                child: YearPicker(
                  firstDate: first,
                  lastDate: last,
                  selectedDate: DateTime(tempYear),
                  onChanged: (date) {
                    tempYear = date.year;
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (tempYear != _currentMonth.year) {
      _currentMonth = DateTime(tempYear, _currentMonth.month);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray80,
      appBar: AppBar(
        backgroundColor: TColor.gray80,
        elevation: 0,
        centerTitle: true,
        title: Text('Spending & Budgets', style: TextStyle(color: TColor.primaryText)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _monthPicker(),
              const SizedBox(height: 12),
              _summaryCard(),
              const SizedBox(height: 16),
              Expanded(child: _categoryList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColor.secondary,
        onPressed: () {
          // TODO: add new category/adjust budget
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Add budget coming soon'), backgroundColor: TColor.gray60),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _monthPicker() {
    final monthText = '${_monthName(_currentMonth.month)} ${_currentMonth.year}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _prevMonth,
          icon: Icon(Icons.chevron_left, color: TColor.primaryText),
        ),
        InkWell(
          onTap: _pickYear,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(monthText, style: TextStyle(color: TColor.primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(width: 6),
                Icon(Icons.expand_more, color: TColor.gray40, size: 20),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: Icon(Icons.chevron_right, color: TColor.primaryText),
        ),
      ],
    );
  }

  Widget _summaryCard() {
    return FutureBuilder<BudgetSummary>(
      future: _summaryFut,
      builder: (context, snap) {
        final data = snap.data;
        final totalBudget = data?.totalBudget ?? 0;
        final totalSpent = data?.totalSpent ?? 0;
        final remaining = (totalBudget - totalSpent).clamp(0, totalBudget);
  final double progress = totalBudget == 0 ? 0.0 : (totalSpent / totalBudget).clamp(0, 1).toDouble();
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TColor.gray70,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('This month', style: TextStyle(color: TColor.gray40)),
                  Text('Budget: ₹${totalBudget.toStringAsFixed(0)}', style: TextStyle(color: TColor.primaryText)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: snap.connectionState == ConnectionState.done ? progress : null,
                  backgroundColor: TColor.gray60,
                  valueColor: AlwaysStoppedAnimation<Color>(TColor.secondary),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Spent: ₹${totalSpent.toStringAsFixed(0)}', style: TextStyle(color: TColor.primaryText)),
                  Text('Left: ₹${remaining.toStringAsFixed(0)}', style: TextStyle(color: TColor.primaryText)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _categoryList() {
    return FutureBuilder<List<BudgetCategory>>(
      future: _categoriesFut,
      builder: (context, snap) {
        final items = snap.data ?? const <BudgetCategory>[];
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator(color: TColor.secondary));
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _categoryTile(items[i]),
        );
      },
    );
  }

  Widget _categoryTile(BudgetCategory c) {
    final progress = c.progress;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TColor.gray70,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _iconFor(c.iconKey, c.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(c.name, style: TextStyle(color: TColor.primaryText, fontSize: 16, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Text('₹${c.spent.toStringAsFixed(0)} / ₹${c.budget.toStringAsFixed(0)}', style: TextStyle(color: TColor.primaryText)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: progress,
                    backgroundColor: TColor.gray60,
                    valueColor: AlwaysStoppedAnimation<Color>(c.color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconFor(String key, Color color) {
    IconData data;
    switch (key) {
      case 'food':
        data = Icons.restaurant_menu;
        break;
      case 'transport':
        data = Icons.directions_bus_outlined;
        break;
      case 'home':
        data = Icons.home_outlined;
        break;
      case 'utilities':
        data = Icons.bolt_outlined;
        break;
      case 'internet':
        data = Icons.wifi_outlined;
        break;
      case 'education':
        data = Icons.school_outlined;
        break;
      case 'health':
        data = Icons.local_hospital_outlined;
        break;
      case 'shopping':
        data = Icons.shopping_bag_outlined;
        break;
      case 'entertainment':
        data = Icons.movie_outlined;
        break;
      case 'travel':
        data = Icons.flight_takeoff_outlined;
        break;
      default:
        data = Icons.category_outlined;
    }
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(data, color: color),
    );
  }

  String _monthName(int m) {
    const names = [
      'January','February','March','April','May','June','July','August','September','October','November','December'
    ];
    return names[m - 1];
  }
}
