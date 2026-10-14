import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../main.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});
  @override
  Widget build(BuildContext context) =>  Scaffold(
      backgroundColor: cream,
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
                color: espresso,
                borderRadius: BorderRadius.all(Radius.circular(21))),
            child: const Icon(Icons.coffee_rounded, color: cream, size: 31)),
       const SizedBox(height: 18),
       const SpinKitThreeBounce(color: ember, size: 20),
       const SizedBox(height: 10),
       const Text('BREWING YOUR SESSION',
            style: TextStyle(
                color: muted,
                fontSize: 9,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w800))
      ])));
}
