import 'package:flutter/material.dart';

class TotalBalanceCard extends StatefulWidget {
  const TotalBalanceCard({super.key, required this.isExpense});
  final isExpense;

  @override
  _TotalBalanceCardState createState() => _TotalBalanceCardState();
}

class _TotalBalanceCardState extends State<TotalBalanceCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 247, 246, 246),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    widget.isExpense
                        ? Icons.arrow_downward_sharp
                        : Icons.arrow_upward_sharp,
                    color: widget.isExpense ? Colors.red : Colors.green,
                  ),
                  Text(
                    widget.isExpense ? 'Expense' : 'Icome',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '\$1300',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
