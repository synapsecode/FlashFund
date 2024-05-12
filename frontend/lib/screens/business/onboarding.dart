import 'package:flutter/material.dart';
import 'package:frontend/backend/auth.dart';
import 'package:frontend/components/labeltextfield.dart';
import 'package:frontend/components/standardbutton.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:go_router/go_router.dart';

class BusinessOnboardingScreen extends StatefulWidget {
  const BusinessOnboardingScreen({super.key});

  @override
  State<BusinessOnboardingScreen> createState() =>
      _BusinessOnboardingScreenState();
}

class _BusinessOnboardingScreenState extends State<BusinessOnboardingScreen> {
  TextEditingController companyNameC = TextEditingController();
  TextEditingController legalStructureC = TextEditingController();
  TextEditingController companyAddrC = TextEditingController();
  TextEditingController dateOfFoundingC = TextEditingController();
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
                  lableText: 'Company Name',
                  controller: companyNameC,
                ).expanded(),
                SizedBox(width: 20),
                LableTextField(
                  lableText: 'Legal Structure',
                  controller: legalStructureC,
                ).expanded(),
              ],
            ).addBottomMargin(20),
            Row(
              children: [
                LableTextField(
                  lableText: 'Company Address',
                  controller: companyAddrC,
                  maxLength: 200,
                ).expanded(),
                SizedBox(width: 20),
                LableTextField(
                  lableText: 'Date of Founding',
                  controller: dateOfFoundingC,
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
            Row(
              children: [
                LableTextField(
                  lableText: 'Current Funding Stage',
                  controller: fundingStageC,
                  isDropDown: true,
                  dropdownList: [
                    'Pre-Seed',
                    'Seed',
                    'Series A',
                    'Series B',
                    'Series C',
                  ],
                ).expanded(),
              ],
            ).addBottomMargin(0),
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
    final res = await BusinessAuth.register(
      email: emailC.value.text,
      password: passwordC.value.text,
      companyAddress: companyAddrC.value.text,
      companyName: companyNameC.value.text,
      fundingStatus: fundingStageC.value.text,
      legalstructure: legalStructureC.value.text,
    );
    if (res) {
      //login
      final success = await BusinessAuth.login(
        email: emailC.value.text,
        password: passwordC.value.text,
      );
      if (success) {
        context.push('/business/dashboard');
      } else {
        print('Login Failed!');
      }
    } else {
      print('Registration Failed!');
    }
  }
}
