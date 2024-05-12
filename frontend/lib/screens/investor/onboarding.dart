import 'package:flutter/material.dart';
import 'package:frontend/backend/auth.dart';
import 'package:frontend/components/labeltextfield.dart';
import 'package:frontend/components/standardbutton.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:go_router/go_router.dart';

class InvestorOnboardingScreen extends StatefulWidget {
  const InvestorOnboardingScreen({super.key});

  @override
  State<InvestorOnboardingScreen> createState() =>
      _InvestorOnboardingScreenState();
}

class _InvestorOnboardingScreenState extends State<InvestorOnboardingScreen> {
  TextEditingController nameC = TextEditingController();
  TextEditingController aadharNumber = TextEditingController();
  TextEditingController invAddress = TextEditingController();
  TextEditingController panDetailsC = TextEditingController();
  TextEditingController fundingStageC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.purple[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Onboarding')
                .size(40)
                .weight(FontWeight.bold)
                .color(Colors.purple[200]!)
                .center()
                .addBottomMargin(40),
            Row(
              children: [
                LableTextField(
                  lableText: 'Investor Name',
                  controller: nameC,
                ).expanded(),
                SizedBox(width: 20),
                LableTextField(
                  lableText: 'Aadhar Number',
                  controller: aadharNumber,
                ).expanded(),
              ],
            ).addBottomMargin(20),
            Row(
              children: [
                LableTextField(
                  lableText: 'Investor Address',
                  controller: invAddress,
                  maxLength: 200,
                ).expanded(),
                SizedBox(width: 20),
                LableTextField(
                  lableText: 'PAN Details',
                  controller: panDetailsC,
                ).expanded(),
              ],
            ).addBottomMargin(30),
            Row(
              children: [
                LableTextField(
                  lableText: 'Email Address',
                  controller: emailC,
                  maxLength: 200,
                ).expanded(),
                SizedBox(width: 20),
                LableTextField(
                  lableText: 'Password',
                  controller: passwordC,
                  hideInput: true,
                ).expanded(),
              ],
            ).addBottomMargin(30),
            StandardButton(
              text: 'Continue',
              buttonColor: Colors.purple,
              width: 400,
              onTap: () {
                register();
              },
              textColor: Colors.white,
            ).addBottomMargin(30),
          ],
        ).addHorizontalMargin(50),
      ).center().addTopMargin(40),
    );
  }

  register() async {
    final res = await InvestorAuth.register(
      email: emailC.value.text,
      password: passwordC.value.text,
      name: nameC.value.text,
      aadhar: aadharNumber.value.text,
      address: invAddress.value.text,
      pan: panDetailsC.value.text,
    );
    if (res) {
      //login
      final success = await InvestorAuth.login(
        email: emailC.value.text,
        password: passwordC.value.text,
      );
      if (success) {
        context.push('/investor/dashboard');
      } else {
        print('Login Failed!');
      }
    } else {
      print('Registration Failed!');
    }
  }
}
