import 'package:flutter/material.dart';
import 'package:frontend/backend/auth.dart';
import 'package:frontend/backend/wallet.dart';
import 'package:frontend/components/labeltextfield.dart';
import 'package:frontend/components/standardbutton.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:frontend/main.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RepayListingPage extends StatefulWidget {
  const RepayListingPage({super.key});

  @override
  State<RepayListingPage> createState() => _RepayListingPageState();
}

class _RepayListingPageState extends State<RepayListingPage> {
  TextEditingController latestInvestmentC = TextEditingController();
  TextEditingController roundName = TextEditingController();

  double loanRate = 4.16;

  @override
  void initState() {
    latestInvestmentC.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  String getRepayAmount() {
    final double amt = double.tryParse(latestInvestmentC.value.text) ?? 0;
    var formatter = NumberFormat('#,##,000');
    return formatter.format(loanRate * amt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LableTextField(
              lableText: 'Investment Round Name',
              controller: roundName,
              isDropDown: true,
              dropdownAlwaysOpen: true,
              dropdownList: [
                'Pre-Seed',
                'Seed',
                'Series A',
                'Series B',
                'Series C',
              ],
            ).limitSize(600).addBottomMargin(20),
            LableTextField(
              lableText: 'Latest Round of Investment Valuation',
              controller: latestInvestmentC,
            ).limitSize(600).addBottomMargin(20),
            Text('Repayment Amount ($loanRate% of Market Cap)').size(25),
            Text("₹${getRepayAmount()}").size(60),
            SizedBox(height: 30),
            StandardButton(
              text: 'Finish Repayment',
              buttonColor: Colors.purple,
              width: 400,
              onTap: () {
                // final id = gpc.read(businessUserIDProvider)!;
                // VirtualWallet.withdraw(type: 'business', amount: 1, id: id);
              },
              textColor: Colors.white,
            ).addBottomMargin(15),
          ],
        ).center(),
      ),
    );
  }
}
