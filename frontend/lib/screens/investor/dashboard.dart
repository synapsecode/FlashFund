import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/backend/auth.dart';
import 'package:frontend/backend/backend.dart';
import 'package:frontend/backend/wallet.dart';
import 'package:frontend/components/labeltextfield.dart';
import 'package:frontend/components/standardbutton.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:frontend/main.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class InvestorDashboard extends StatefulWidget {
  const InvestorDashboard({super.key});

  @override
  State<InvestorDashboard> createState() => _InvestorDashboardState();
}

class _InvestorDashboardState extends State<InvestorDashboard> {
  TextEditingController rechargeAmountC = TextEditingController();
  TextEditingController negotiatedMarketCapC = TextEditingController();

  Timer? autoSetStateTimer;

  @override
  void initState() {
    final t = Timer.periodic(Duration(seconds: 5), (timer) {
      autoSetStateTimer = timer;
      print('autoSetStateTimer invoked');
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    autoSetStateTimer?.cancel();
    super.dispose();
  }

  List<StockPriceModel> stocks = [
    StockPriceModel(
      id: 0,
      name: 'ACME',
      price: 2.33,
      marketCap: 60000000,
      values: [2.00, 2.44, 2.33, 1.18, 2.53, 2.33],
    ),
    StockPriceModel(
      id: 1,
      name: 'BGMN',
      price: 9.5,
      marketCap: 60000000,
      values: [7.2, 8.5, 9.9, 11.3, 7.4, 9.5],
    )
  ];

  @override
  Widget build(BuildContext context) {
    final cBal = gpc.read(currentWalletBalance);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Investor Dashboard')
                      .size(40)
                      .weight(FontWeight.bold)
                      .color(Colors.purple[200]!)
                      .addRightMargin(20),
                  SizedBox(height: 50),
                  ...stocks.map((x) => StockPriceGroup(model: x)).toList(),
                ],
              ),
            ).expanded(),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        foregroundColor: Colors.white,
                      ),
                      child: Text('logout'),
                    ).addLeftMargin(10),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('notifications'),
                    ).addLeftMargin(10),
                    ElevatedButton(
                      onPressed: () async {
                        final z = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  LableTextField(
                                          lableText: 'Recharge Amount',
                                          controller: rechargeAmountC)
                                      .addBottomMargin(20),
                                  StandardButton(
                                    text: 'Purchase',
                                    buttonColor: Colors.purple,
                                    width: 400,
                                    onTap: () async {
                                      final id =
                                          gpc.read(investorUserIDProvider)!;
                                      await VirtualWallet.deposit(
                                        type: 'investor',
                                        amount: int.tryParse(
                                                rechargeAmountC.value.text) ??
                                            0,
                                        id: id,
                                      );
                                      Navigator.pop(context, 'purchased');
                                    },
                                    textColor: Colors.white,
                                  ),
                                ],
                              ).addUniformMargin(5),
                            );
                          },
                        );
                        if (z == 'purchased') {
                          setState(() {});
                        }
                      },
                      child: Text('recharge wallet'),
                    ).addLeftMargin(10),
                  ],
                ).addBottomMargin(30),
                Text('balance').size(30),
                Text("₹${NumberFormat('#,##,###').parse(cBal.toString())}")
                    .size(40)
                    .weight(FontWeight.bold)
                    .translate(0, -10, 0),
                SizedBox(height: 20),
                StandardButton(
                  text: 'Current Roadshows',
                  buttonColor: Colors.purple,
                  width: 400,
                  onTap: () {
                    context.push('/investor/roadshows');
                  },
                  textColor: Colors.white,
                ).addBottomMargin(15),
                StandardButton(
                  text: 'IPO Marketplace',
                  buttonColor: Colors.purple,
                  width: 400,
                  onTap: () {
                    context.push('/investor/marketplace');
                  },
                  textColor: Colors.white,
                ).addBottomMargin(30),
              ],
            ),
          ],
        ).addHorizontalMargin(50),
      ).addTopMargin(40),
    );
  }
}

class StockPriceModel {
  final int id;
  final String name;
  final double price;
  final double marketCap;
  final List<double> values;

  StockPriceModel({
    required this.id,
    required this.name,
    required this.price,
    required this.marketCap,
    required this.values,
  });
}

class StockPriceGroup extends StatelessWidget {
  final StockPriceModel model;

  const StockPriceGroup({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("\$${model.name}")
                .size(30)
                .weight(FontWeight.bold)
                .translate(0, -10, 0),
            Text('₹${model.price}')
                .size(22)
                .color(Colors.green[300]!)
                .translate(5, -12, 0),
          ],
        ),
        Text('Current Market Cap: ₹${model.marketCap}')
            .size(16)
            .translate(0, -10, 0),
        SizedBox(height: 20),
        Container(
          height: MediaQuery.of(context).size.width * 0.15,
          width: MediaQuery.of(context).size.width * 0.3,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <LineSeries<(double, String), String>>[
              LineSeries<(double, String), String>(
                // Bind data source
                dataSource: <(double, String)>[
                  (model.values[0], 'MON'),
                  (model.values[1], 'TUE'),
                  (model.values[2], 'WED'),
                  (model.values[3], 'THU'),
                  (model.values[4], 'FRI'),
                  (model.values[5], 'SAT'),
                ],
                xValueMapper: ((double, String) x, _) => x.$2,
                yValueMapper: ((double, String) x, _) => x.$1,
              )
            ],
          ),
        ).translate(0, -30, 0),
        Divider().addRightMargin(10).translate(0, -25, 0),
        SizedBox(height: 30),
      ],
    );
  }
}
