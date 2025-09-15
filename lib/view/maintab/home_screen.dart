import 'package:flutter/material.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:expy/common/color_extension.dart';
import 'package:expy/view/maintab/calender_page.dart';
import 'package:expy/view/maintab/spending_budgets_page.dart';
import 'package:expy/view/maintab/your_cards.dart';
import 'package:expy/view/settings/settings_view.dart';
import 'package:expy/data/budget_repository.dart';
import 'package:expy/data/budget_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
  with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final _repo = InMemoryBudgetRepository();
  final DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  late Future<BudgetSummary> _summaryFut;
  late Future<List<BudgetCategory>> _topCatsFut;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.grid_view_rounded,
    Icons.calendar_month_outlined,
    Icons.credit_card_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _reloadOverview();
  }

  void _reloadOverview() {
    _summaryFut = _repo.getMonthlySummary(month: _month);
    _topCatsFut = _repo.getMonthlyCategories(month: _month);
    // do not call setState here; callers will decide when to rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray80,
      body: _buildBody(context),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: TColor.secondary,
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: TColor.gray70,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: _currentIndex,
          activeColor: TColor.primary0,
          inactiveColor: TColor.gray50,
          iconSize: 28,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  // Build body based on selected bottom navigation index
  Widget _buildBody(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return _buildOverview(context);
      case 1:
        return const SpendingBudgetsPage();
      case 2:
        return const CalenderPage();
      case 3:
        return const YourCards();
      default:
        return _buildOverview(context);
    }
  }

  // Overview content
  Widget _buildOverview(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Hi there', style: TextStyle(color: TColor.primaryText, fontSize: 18, fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: Icon(
                      Icons.settings_outlined,
                      color: TColor.gray50,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsView()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Circular summary (reintroduce)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FutureBuilder<BudgetSummary>(
                future: _summaryFut,
                builder: (context, snap) {
                  final s = snap.data;
                  final total = s?.totalBudget ?? 0;
                  final spent = s?.totalSpent ?? 0;
                  final progress = total == 0 ? 0.0 : (spent / total).clamp(0, 1).toDouble();
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: TColor.gray70,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: DashedCircularProgressBar.aspectRatio(
                        startAngle: 225,
                        sweepAngle: 270,
                        foregroundStrokeWidth: 10,
                        backgroundStrokeWidth: 10,
                        aspectRatio: 1.2,
                        progress: (progress * 100),
                        maxProgress: 100,
                        corners: StrokeCap.round,
                        foregroundColor: TColor.secondary,
                        backgroundColor: TColor.gray50,
                        animation: true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("This month", style: TextStyle(color: TColor.primaryText, fontSize: 14)),
                            const SizedBox(height: 5),
                            Text(
                              '₹${spent.toStringAsFixed(0)}',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: TColor.primaryText),
                            ),
                            const SizedBox(height: 5),
                            Text('of ₹${total.toStringAsFixed(0)}', style: TextStyle(color: TColor.gray40, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // KPI row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<BudgetSummary>(
                future: _summaryFut,
                builder: (context, snap) {
                  final s = snap.data;
                  return Row(
                    children: [
                      Expanded(child: _kpiCard(title: 'Spent', value: '₹${(s?.totalSpent ?? 0).toStringAsFixed(0)}')),
                      const SizedBox(width: 10),
                      Expanded(child: _kpiCard(title: 'Budget', value: '₹${(s?.totalBudget ?? 0).toStringAsFixed(0)}')),
                      const SizedBox(width: 10),
                      Expanded(child: _kpiCard(title: 'Left', value: '₹${((s?.remaining ?? 0)).toStringAsFixed(0)}')),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

    // Quick actions (Expense/Income/Add bill only)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
      _quickAction(Icons.remove_circle_outline, 'Expense', onTap: _showAddExpense),
      _quickAction(Icons.add_circle_outline, 'Income'),
      _quickAction(Icons.receipt_long_outlined, 'Add bill'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Budgets snapshot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _sectionHeader('Budgets snapshot'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FutureBuilder<List<BudgetCategory>>(
                future: _topCatsFut,
                builder: (context, snap) {
                  final items = (snap.data ?? const <BudgetCategory>[]).take(3).toList();
                  if (items.isEmpty) {
                    return _emptyCard('No budgets yet');
                  }
                  return Column(
                    children: items.map((c) => _budgetMini(c)).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 4),

            // Upcoming payments (placeholder)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _sectionHeader('Upcoming payments'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _placeholderList([
                'Mobile bill due in 3 days',
                'Netflix due in 5 days',
                'Electricity bill due in 7 days',
              ]),
            ),

            // Recent activity (placeholder)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _sectionHeader('Recent activity'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _placeholderList([
                'Swiggy - ₹420',
                'Metro card recharge - ₹200',
                'Pharmacy - ₹350',
                'Zomato - ₹260',
                'Fuel - ₹1200',
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kpiCard({required String title, required String value}) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColor.gray70,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: TColor.gray40, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: TColor.primaryText, fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, {VoidCallback? onTap}) {
    return Column(
      children: [
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: TColor.gray70,
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Center(child: Icon(icon, color: TColor.primary0)),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: TColor.gray40, fontSize: 12)),
      ],
    );
  }

  void _showAddExpense() async {
    final categories = await _repo.getMonthlyCategories(month: _month);
    String? selectedId = categories.first.id;
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

  if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: TColor.gray70,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: TColor.gray60, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Add expense', style: TextStyle(color: TColor.primaryText, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  dropdownColor: TColor.gray70,
                  value: selectedId,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: TColor.gray80,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  iconEnabledColor: TColor.primaryText,
                  items: [
                    for (final c in categories)
                      DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name, style: TextStyle(color: TColor.primaryText)),
                      )
                  ],
                  onChanged: (v) => selectedId = v,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: TColor.primaryText),
                  decoration: InputDecoration(
                    hintText: 'Amount (₹)',
                    hintStyle: TextStyle(color: TColor.gray40),
                    filled: true,
                    fillColor: TColor.gray80,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteCtrl,
                  style: TextStyle(color: TColor.primaryText),
                  decoration: InputDecoration(
                    hintText: 'Note (optional)',
                    hintStyle: TextStyle(color: TColor.gray40),
                    filled: true,
                    fillColor: TColor.gray80,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final parsed = double.tryParse(amountCtrl.text.trim());
                      if (parsed == null || parsed <= 0 || selectedId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text('Enter a valid amount'), backgroundColor: TColor.gray60),
                        );
                        return;
                      }
                      await _repo.addExpense(date: DateTime.now(), categoryId: selectedId!, amount: parsed, note: noteCtrl.text.trim());
                      if (!mounted) return;
                      _reloadOverview();
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add expense'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
  );
  }

  Widget _budgetMini(BudgetCategory c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColor.gray70,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(c.name, style: TextStyle(color: TColor.primaryText, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
              Text('₹${c.spent.toStringAsFixed(0)} / ₹${c.budget.toStringAsFixed(0)}', style: TextStyle(color: TColor.primaryText)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: c.progress,
              backgroundColor: TColor.gray60,
              valueColor: AlwaysStoppedAnimation<Color>(c.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) => Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: TextStyle(color: TColor.gray40, fontSize: 14, fontWeight: FontWeight.w600)),
      );

  Widget _placeholderList(List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.gray70,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            ListTile(
              dense: true,
              title: Text(items[i], style: TextStyle(color: TColor.primaryText)),
            ),
            if (i != items.length - 1) Divider(height: 1, thickness: 1, color: TColor.gray60),
          ]
        ],
      ),
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.gray70,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: TColor.gray40),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: TColor.gray40))),
        ],
      ),
    );
  }

  // ...no legacy subscription widgets
}
