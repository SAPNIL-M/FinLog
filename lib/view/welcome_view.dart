import 'package:expy/common/color_extension.dart';

import 'package:expy/common_widgets/orange_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/img/welcome_screen.png',
            fit: BoxFit.cover,
            width: media.width,
            height: media.height,
          ),
          SafeArea(
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
                    margin: const EdgeInsets.only(top: 530),
                    child: Text(
                      "Track Every Penny, Save Every Dollar",
                      style: TextStyle(color: TColor.white, fontSize: 15),
                    ),
                  ),
                  Container(
                    height: 58,
                    width: media.width * 0.9,
                    margin: const EdgeInsets.only(top: 70),
                    child: GradientButton(
                        label: 'Get Started',
                        gradientColors: [TColor.secondary, TColor.secondary50],
                        onPressed: () {}),
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
          )
        ],
      ),
    );
  }
}
