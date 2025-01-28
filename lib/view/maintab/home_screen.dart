import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:expy/common/color_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.grid_view_rounded,
    Icons.calendar_month_outlined,
    Icons.credit_card_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray80,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: TColor.gray50,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Circular Progress Bar
          Center(
            child: DashedCircularProgressBar.aspectRatio(
              startAngle: 225,
              sweepAngle: 270,
              foregroundStrokeWidth: 10,
              backgroundStrokeWidth: 10,
              aspectRatio: 1.2,
              progress: 75, // Example percentage
              maxProgress: 100,
              corners: StrokeCap.round,
              foregroundColor: TColor.secondary,
              backgroundColor: TColor.gray50,
              animation: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "FINLOG",
                    style: TextStyle(color: TColor.primaryText, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "\$1,235",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: TColor.primaryText),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "This month bills",
                    style: TextStyle(color: TColor.gray40, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.gray70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("See your budget"),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Stats Summary Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryCard("Active subs", "12", TColor.secondary),
                _buildSummaryCard("Highest subs", "\$19.99", TColor.primary),
                _buildSummaryCard("Lowest subs", "\$5.99", TColor.secondaryG),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // TabBar for Subscription & Bills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: TColor.gray70,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: TColor.gray80,
                  borderRadius: BorderRadius.circular(20),
                ),
                labelColor: TColor.primaryText,
                unselectedLabelColor: TColor.gray40,
                tabs: const [
                  Tab(text: "Your subscriptions"),
                  Tab(text: "Upcoming bills"),
                ],
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSubscriptionList(),
                Center(
                    child: Text("Upcoming bills",
                        style: TextStyle(color: TColor.primaryText))),
              ],
            ),
          ),
        ],
      ),

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
              color: Colors.black.withOpacity(0.3),
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

  // Summary Card Widget
  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColor.gray70,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: TColor.gray40, fontSize: 12)),
          const SizedBox(height: 5),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Subscription List
  Widget _buildSubscriptionList() {
    final subscriptions = [
      {
        "name": "Spotify",
        "price": "\$5.99",
        "icon": Icons.music_note,
        "color": Colors.green
      },
      {
        "name": "YouTube Premium",
        "price": "\$18.99",
        "icon": Icons.play_circle_filled,
        "color": Colors.red
      },
      {
        "name": "Microsoft OneDrive",
        "price": "\$29.99",
        "icon": Icons.cloud,
        "color": Colors.blue
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      itemCount: subscriptions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = subscriptions[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TColor.gray70,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(item["icon"] as IconData,
                  color: item["color"] as Color, size: 32),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(item["name"] as String,
                      style:
                          TextStyle(color: TColor.primaryText, fontSize: 16))),
              Text(item["price"] as String,
                  style: TextStyle(color: TColor.primaryText, fontSize: 16)),
            ],
          ),
        );
      },
    );
  }
}
