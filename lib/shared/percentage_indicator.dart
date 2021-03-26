import 'package:flutter/material.dart';

class PercentageIndicator extends StatelessWidget {
  final double value;

  PercentageIndicator({required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              " ${(value * 100).floor()}%",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: 60,
          height: 60,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: Duration(milliseconds: 350),
            builder: (context, double? col, _) {
              return CircularProgressIndicator(
                backgroundColor: Colors.grey[400],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent[700]!),
                value: col,
                strokeWidth: 10,
              );
            },
          ),
        ),
      ],
    );
  }
}
