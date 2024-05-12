import 'package:flutter/material.dart';
import 'package:frontend/components/labeltextfield.dart';
import 'package:frontend/components/standardbutton.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:go_router/go_router.dart';

class InvestorLoginScreen extends StatefulWidget {
  const InvestorLoginScreen({super.key});

  @override
  State<InvestorLoginScreen> createState() => _InvestorLoginScreenState();
}

class _InvestorLoginScreenState extends State<InvestorLoginScreen> {
  TextEditingController usernameC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.purple[50],
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Investor Login')
                .size(40)
                .weight(FontWeight.bold)
                .color(Colors.purple[200]!)
                .center()
                .addBottomMargin(20),
            LableTextField(
              lableText: 'email',
              controller: usernameC,
            ).addBottomMargin(20),
            LableTextField(
              lableText: 'password',
              controller: passwordC,
              hideInput: true,
            ).addBottomMargin(20),
            StandardButton(
              text: 'login',
              buttonColor: Colors.purple,
              width: 400,
              onTap: () {},
              textColor: Colors.white,
            ).addBottomMargin(30),
            TextButton(
                onPressed: () {
                  context.push('/investor/onboarding');
                },
                child: Text('Create Account'))
          ],
        ).limitSize(400),
      ).center(),
    );
  }
}
