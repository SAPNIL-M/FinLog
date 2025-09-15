import 'package:expy/common/color_extension.dart';
import 'package:expy/view/onboarding/signin_view.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool notifications = true;
  bool faceId = false;
  bool appLock = false;
  bool darkMode = true; // UI only in this demo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray80,
      appBar: AppBar(
        backgroundColor: TColor.gray80,
        elevation: 0,
        title: Text('Settings', style: TextStyle(color: TColor.primaryText)),
        iconTheme: IconThemeData(color: TColor.primaryText),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _profileCard(),
            const SizedBox(height: 16),
            _sectionHeader('Preferences'),
            _settingsCard(children: [
              _switchTile(
                icon: Icons.notifications_none,
                title: 'Push notifications',
                value: notifications,
                onChanged: (v) => setState(() => notifications = v),
              ),
              _divider(),
              _switchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark mode',
                value: darkMode,
                onChanged: (v) => setState(() => darkMode = v),
              ),
              _divider(),
              _switchTile(
                icon: Icons.lock_outline,
                title: 'App lock',
                value: appLock,
                onChanged: (v) => setState(() => appLock = v),
              ),
              _divider(),
              _switchTile(
                icon: Icons.face_retouching_natural,
                title: 'Face ID / Touch ID',
                value: faceId,
                onChanged: (v) => setState(() => faceId = v),
              ),
            ]),
            const SizedBox(height: 16),
            _sectionHeader('Account'),
            _settingsCard(children: [
              _navTile(
                icon: Icons.person_outline,
                title: 'Account information',
                onTap: () => _toast(context, 'Account information'),
              ),
              _divider(),
              _navTile(
                icon: Icons.security,
                title: 'Privacy & security',
                onTap: () => _toast(context, 'Privacy & security'),
              ),
              _divider(),
              _navTile(
                icon: Icons.payment,
                title: 'Payment methods',
                onTap: () => _toast(context, 'Payment methods'),
              ),
              _divider(),
              _navTile(
                icon: Icons.language,
                title: 'Language',
                onTap: () => _toast(context, 'Language'),
              ),
            ]),
            const SizedBox(height: 16),
            _sectionHeader('About'),
            _settingsCard(children: [
              _navTile(
                icon: Icons.info_outline,
                title: 'About FinLog',
                onTap: () => _toast(context, 'About FinLog'),
              ),
              _divider(),
              _navTile(
                icon: Icons.help_outline,
                title: 'Help & support',
                onTap: () => _toast(context, 'Help & support'),
              ),
            ]),
            const SizedBox(height: 24),
            _logoutButton(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColor.gray70,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: TColor.primary,
            child: Text('S', style: TextStyle(color: TColor.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sapnil', style: TextStyle(color: TColor.primaryText, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('sapnil@example.com', style: TextStyle(color: TColor.gray40, fontSize: 14)),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, color: TColor.gray40),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Text(title, style: TextStyle(color: TColor.gray40, fontSize: 14)),
      );

  Widget _settingsCard({required List<Widget> children}) => Container(
        decoration: BoxDecoration(
          color: TColor.gray70,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: children),
      );

  Widget _navTile({required IconData icon, required String title, VoidCallback? onTap}) => ListTile(
        leading: Icon(icon, color: TColor.primary0),
        title: Text(title, style: TextStyle(color: TColor.primaryText)),
        trailing: Icon(Icons.chevron_right, color: TColor.gray40),
        onTap: onTap,
      );

  Widget _switchTile({required IconData icon, required String title, required bool value, required ValueChanged<bool> onChanged}) => SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: TColor.primary0),
        title: Text(title, style: TextStyle(color: TColor.primaryText)),
        activeColor: TColor.secondary,
        inactiveThumbColor: TColor.gray40,
        inactiveTrackColor: TColor.gray60,
      );

  Widget _divider() => Divider(height: 1, thickness: 1, color: TColor.gray60);

  Widget _logoutButton(BuildContext context) => SizedBox(
        height: 56,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: TColor.gray70,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () {
            // Navigate to SignIn and remove all previous routes
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SignInView()),
              (route) => false,
            );
          },
          icon: Icon(Icons.logout, color: TColor.secondary),
          label: Text('Log out', style: TextStyle(color: TColor.primaryText)),
        ),
      );

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: TColor.gray60,
      ),
    );
  }
}
