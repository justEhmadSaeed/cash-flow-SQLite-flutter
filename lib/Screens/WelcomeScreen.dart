import 'package:cash_flow_app/Components/RoundButton.dart';
import 'package:cash_flow_app/Screens/LoginScreen.dart';
import 'package:cash_flow_app/Screens/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatelessWidget {
  static const ROUTE = '/WELCOME';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('assets/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Expense Flow',
                      textStyle: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.w900,
                      ),
                      speed: Duration(milliseconds: 150),
                    )
                  ],
                  repeatForever: true,
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Hero(
              tag: 'login',
              child: RoundButton(
                color: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.ROUTE);
                },
                title: 'Log In',
              ),
            ),
            Hero(
              tag: 'signup',
              child: RoundButton(
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, SignupScreen.ROUTE);
                },
                title: 'Sign Up',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
