import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthListElement extends StatelessWidget {
  final DateTime month;
  const MonthListElement({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        title: Text(
          DateFormat('MMMM yyyy').format(month),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        dense: true,
      ),
    );
  }
}
