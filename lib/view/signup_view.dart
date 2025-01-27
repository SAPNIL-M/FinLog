import 'package:expy/common/color_extension.dart';
import 'package:expy/common_widgets/orange_button.dart';
import 'package:expy/common_widgets/text_fieldl.dart';
import 'package:flutter/material.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
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
                  child: const TextFieldl(
                    type: 'Email-Address',
                    keyboardType: TextInputType.emailAddress,
                    obscured: false,
                  )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
                child: const TextFieldl(
                  type: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscured: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(color: TColor.gray70),
                    )),
                    Expanded(
                        child: Container(
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(color: TColor.gray70),
                    )),
                    Expanded(
                        child: Container(
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(color: TColor.gray70),
                    )),
                    Expanded(
                        child: Container(
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(color: TColor.gray70),
                    )),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Use 8 or more characters with a mix of letters,\nnumbers & symbols",
                      style: TextStyle(color: TColor.gray50),
                    ),
                  ),
                ],
              ),
              Container(
                height: 58,
                width: media.width * 0.9,
                margin: const EdgeInsets.only(top: 30),
                child: GradientButton(
                    label: "Get started,it's free!",
                    onPressed: () {},
                    gradientColors: [TColor.secondary, TColor.secondary50]),
              ),
              const SizedBox(height: 100),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  "Do you already have a account?",
                  style: TextStyle(color: TColor.white, fontSize: 16),
                ),
              ),
              Container(
                height: 58,
                width: media.width * 0.9,
                margin: const EdgeInsets.only(top: 10),
                child: GradientButton(
                    gradientColors: [TColor.gray70, TColor.gray50],
                    label: 'I have an account',
                    onPressed: () {}),
              )
            ],
          ),
        ),
      )),
    );
  }
}
