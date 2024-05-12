import 'package:flutter/material.dart';
import 'package:frontend/backend/roadshow.dart';
import 'package:frontend/components/labeltextfield.dart';
import 'package:frontend/components/standardbutton.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RaiseFundsPage extends StatefulWidget {
  const RaiseFundsPage({super.key});

  @override
  State<RaiseFundsPage> createState() => _RaiseFundsPageState();
}

class _RaiseFundsPageState extends State<RaiseFundsPage> {
  TextEditingController loanAmountC = TextEditingController();
  TextEditingController estimatedValueC = TextEditingController();

  @override
  void initState() {
    estimatedValueC.addListener(() {
      setState(() {});
    });
    loanAmountC.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  double getLoanPercentageAgainstValuation() {
    final double loanAmount = double.tryParse(loanAmountC.value.text) ?? 0;
    final double compVal = double.tryParse(estimatedValueC.value.text) ?? 0;
    return compVal == 0 ? 0 : (loanAmount / compVal) * 100;
  }

  String getValueOfEachShare() {
    final double loanAmount = double.tryParse(loanAmountC.value.text) ?? 0;
    final lp = getLoanPercentageAgainstValuation();
    const MICROSHARE_COUNT = 1000000; //1 Million
    final ves = loanAmount / MICROSHARE_COUNT;
    return ves.toStringAsFixed(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Raise Funds')
              .size(40)
              .weight(FontWeight.bold)
              .color(Colors.purple[200]!)
              .addBottomMargin(40),
          StandardButton(
            text: 'Upload Prospectus',
            buttonColor: Colors.black,
            width: 400,
            onTap: () {},
            textColor: Colors.white,
          ).addBottomMargin(30),
          LableTextField(
            lableText: 'Loan Amount',
            controller: loanAmountC,
          ).addBottomMargin(20).limitSize(400),
          LableTextField(
            lableText: 'Estimated Valuation in next funding round',
            controller: estimatedValueC,
          ).addBottomMargin(20).limitSize(400),
          Text(
              'Pre-Roadshow Loan Percentage against valuation: ₹${getLoanPercentageAgainstValuation()}'),
          Text('Pre-Roadshow Value of each share: ₹${getValueOfEachShare()}'),
          SizedBox(height: 30),
          StandardButton(
            text: 'Start Roadshow',
            buttonColor: Colors.purple,
            width: 400,
            onTap: () async {
              final double loanAmount =
                  double.tryParse(loanAmountC.value.text) ?? 0;
              final double compVal =
                  double.tryParse(estimatedValueC.value.text) ?? 0;
              final res = await RoadshowBackend.createRoadshow(
                projectedValuation: compVal.toInt(),
                loanAmount: loanAmount.toInt(),
              );
              if (res == false) {
                print('ERRORRRRRRRR');
              }
              context.pop();
            },
            textColor: Colors.white,
          ).addBottomMargin(30),
        ],
      ).center(),
    );
  }
}
