import 'package:expy/common/color_extension.dart';
import 'package:expy/common_widgets/orange_button.dart';
import 'package:expy/common_widgets/text_fieldl.dart';
import 'package:expy/view/maintab/home_screen.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool isChecked = false;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray80,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                height: 60,
                width: 178,
                child: Image.asset('assets/img/app_logo.png'),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(top: 140),
                  child: TextFieldl(
                    type: 'Login',
                    keyboardType: TextInputType.emailAddress,
                    obscured: false,
                    controller: _emailCtrl,
                  )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
                child: TextFieldl(
                  type: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscured: true,
                  controller: _passwordCtrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: isChecked,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isChecked = newValue!;
                            });
                          },
                        ),
                        Text(
                          'Remember me',
                          style: TextStyle(color: TColor.gray50),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: TColor.gray50),
                        ))
                  ],
                ),
              ),
      Container(
                height: 58,
                width: media.width * 0.9,
                margin: const EdgeInsets.only(top: 25),
                child: GradientButton(
                    label: "Sign In",
        onPressed: _onSignIn,
                    gradientColors: [TColor.secondary, TColor.secondary50]),
              ),
              const SizedBox(height: 100),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  "If you Don't have an account yet",
                  style: TextStyle(color: TColor.white, fontSize: 16),
                ),
              ),
              Container(
                height: 58,
                width: media.width * 0.9,
                margin: const EdgeInsets.only(top: 10),
                child: GradientButton(
                    gradientColors: [TColor.gray70, TColor.gray50],
                    label: 'Sign Up',
                    onPressed: () {}),
              )
            ],
          ),
        ),
      )),
    );
  }
}

extension on _SignInViewState {
  void _onSignIn() {
    FocusScope.of(context).unfocus();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter email and password'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: TColor.gray60,
        ),
      );
      return;
    }

    // TODO: Replace with real auth. For now, navigate to Home.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }
}
