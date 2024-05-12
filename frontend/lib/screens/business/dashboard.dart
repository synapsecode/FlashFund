import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/backend/backend.dart';
import 'package:frontend/components/labeltextfield.dart';
import 'package:frontend/components/standardbutton.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class BusinessDashboard extends StatefulWidget {
  const BusinessDashboard({super.key});

  @override
  State<BusinessDashboard> createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> {
  TextEditingController rechargeAmountC = TextEditingController();
  TextEditingController negotiatedMarketCapC = TextEditingController();

  bool isCurrentListingVisible = true;
  bool currentListingAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Dashboard')
                    .size(40)
                    .weight(FontWeight.bold)
                    .color(Colors.purple[200]!)
                    .addRightMargin(20),
                Row(
                  children: [
                    Text("\$ACME")
                        .size(60)
                        .weight(FontWeight.bold)
                        .translate(0, -10, 0),
                    Text('₹2.43')
                        .size(40)
                        .color(Colors.green[300]!)
                        .addLeftMargin(20),
                  ],
                ),
                Text('Current Market Cap: ₹30L').size(20),
                SizedBox(height: 20),
                Container(
                    height: MediaQuery.of(context).size.width * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <LineSeries<(double, String), String>>[
                          LineSeries<(double, String), String>(
                            // Bind data source
                            dataSource: <(double, String)>[
                              (2.35, 'MON'),
                              (2.12, 'TUE'),
                              (2.45, 'WED'),
                              (2.85, 'THU'),
                              (2.95, 'FRI'),
                              (2.1, 'SAT'),
                            ],
                            xValueMapper: ((double, String) x, _) => x.$2,
                            yValueMapper: ((double, String) x, _) => x.$1,
                          )
                        ])),
                SizedBox(height: 30),
              ],
            ).expanded(),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      onPressed: () {
                        print('ddd');
                        showDialog(
                          context: context,
                          builder: (context) {
                            print('ddd');
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
                                    onTap: () {},
                                    textColor: Colors.white,
                                  ),
                                ],
                              ).addUniformMargin(5),
                            );
                          },
                        );
                      },
                      child: Text('recharge wallet'),
                    ).addLeftMargin(10),
                  ],
                ).addBottomMargin(30),
                Text('balance').size(30),
                Text("₹34,000")
                    .size(40)
                    .weight(FontWeight.bold)
                    .translate(0, -10, 0),
                SizedBox(height: 20),
                StandardButton(
                  text: 'Raise Funds',
                  buttonColor: Colors.purple,
                  width: 400,
                  onTap: () {
                    context.push('/business/raisefunds');
                  },
                  textColor: Colors.white,
                ).addBottomMargin(15),
                StandardButton(
                  text: 'Start Repayment',
                  buttonColor: Colors.purple,
                  width: 400,
                  onTap: () {
                    context.push('/business/startrepayment');
                  },
                  textColor: Colors.white,
                ).addBottomMargin(15),
                if (isCurrentListingVisible) ...[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Current Listing'),
                        SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isCurrentListingVisible = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                foregroundColor: Colors.white,
                              ),
                              child: Text('reject'),
                            ).addLeftMargin(10),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          LableTextField(
                                            lableText: 'Negotiated Market Cap',
                                            controller: negotiatedMarketCapC,
                                          ).addBottomMargin(20),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                isCurrentListingVisible = false;
                                              });
                                            },
                                            child: Text('negotiate'),
                                          ),
                                        ],
                                      ).addUniformMargin(10),
                                    );
                                  },
                                );
                              },
                              child: Text('negotiate'),
                            ).addLeftMargin(10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isCurrentListingVisible = false;
                                  currentListingAccepted = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[400],
                                foregroundColor: Colors.white,
                              ),
                              child: Text('accept'),
                            ).addLeftMargin(10),
                          ],
                        ).center(),
                      ],
                    ),
                  ),
                ] else ...[
                  if (currentListingAccepted) ...[
                    SizedBox(height: 20),
                    Text('FlashFund Initiated! ').weight(FontWeight.bold),
                    Text('Required Amount: ₹25,00,000'),
                    Text('Accepted Valuation for next round: ₹6,00,00,000'),
                    Text('Finalized Loan Percent against Vaaluation: 4.16%'),
                    Text('Value of each microshare: ₹2.50'),
                  ]
                ],
                // StandardButton(
                //   text: 'Current Roadshows',
                //   buttonColor: Colors.purple,
                //   width: 400,
                //   onTap: () {},
                //   textColor: Colors.white,
                // ).addBottomMargin(15),
                // StandardButton(
                //   text: 'IPO Marketplace',
                //   buttonColor: Colors.purple,
                //   width: 400,
                //   onTap: () {},
                //   textColor: Colors.white,
                // ).addBottomMargin(30),
              ],
            ),
          ],
        ).addHorizontalMargin(50),
      ).addTopMargin(40),
    );
  }
}
