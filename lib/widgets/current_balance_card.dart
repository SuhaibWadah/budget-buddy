import 'package:flutter/material.dart';

class CurrentBalanceCard extends StatefulWidget {
  const CurrentBalanceCard({super.key});

  @override
  _CurrentBalanceCardState createState() => _CurrentBalanceCardState();
}

class _CurrentBalanceCardState extends State<CurrentBalanceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 249, 248, 248),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(70),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Balance',
              style: TextStyle(color: Colors.black.withAlpha(100)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$100000',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.trending_up, color: Colors.green[600], size: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
