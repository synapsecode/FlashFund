import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/extensions/extensions.dart';
import 'package:frontend/extensions/miscextensions.dart';
import 'package:frontend/routes.dart';
import 'package:go_router/go_router.dart';

final gpc = ProviderContainer();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  GoRouter.optionURLReflectsImperativeAPIs = true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: globalRouter,
        debugShowCheckedModeBanner: false,
        title: "FlashFund",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}

class FlashFundApp extends StatelessWidget {
  const FlashFundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.purple[50],
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome to Flash Funds")
                .size(40)
                .weight(FontWeight.bold)
                .color(Colors.purple[200]!)
                .addBottomMargin(20),
            ElevatedButton(
              onPressed: () {
                context.push('/business/login');
              },
              child: Text('Business'),
            ).limitSize(200).addBottomMargin(10),
            ElevatedButton(
              onPressed: () {
                context.push('/investor/login');
              },
              child: Text('Investor'),
            ).limitSize(200),
          ],
        ),
      ),
    );
  }
}
