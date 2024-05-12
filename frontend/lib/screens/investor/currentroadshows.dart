import 'package:flutter/material.dart';
import 'package:frontend/components/labeltextfield.dart';
import 'package:frontend/components/standardbutton.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:intl/intl.dart';

class RoadshowModel {
  final int id;
  final String companyName;
  final String prospectusURL;
  double companyValuation;
  final double loanAmount;

  double get loanPercentageAgainstValuation {
    return companyValuation == 0 ? 0 : (loanAmount / companyValuation) * 100;
  }

  String get getValueOfEachShare {
    const MICROSHARE_COUNT = 1000000; //1 Million
    final ves = loanAmount / MICROSHARE_COUNT;
    return ves.toStringAsFixed(5);
  }

  RoadshowModel({
    required this.id,
    required this.companyName,
    required this.prospectusURL,
    required this.companyValuation,
    required this.loanAmount,
  });
}

class CurrentRoadshowsPage extends StatefulWidget {
  const CurrentRoadshowsPage({super.key});

  @override
  State<CurrentRoadshowsPage> createState() => _CurrentRoadshowsPageState();
}

class _CurrentRoadshowsPageState extends State<CurrentRoadshowsPage> {
  List<RoadshowModel> roadshows = [
    RoadshowModel(
      id: 0,
      companyName: 'Acme Corp',
      prospectusURL: 'https://www.google.com',
      companyValuation: 4853858585,
      loanAmount: 240000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Roadshows')
                .size(40)
                .weight(FontWeight.bold)
                .color(Colors.purple[200]!)
                .addBottomMargin(40),
          ],
        ).center(),
      ),
    );
  }
}
