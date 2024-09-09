import 'package:flutter/material.dart';

class Mytiles extends StatelessWidget {
  final String text;

  Mytiles({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Card(
        color: theme.cardColor, // Use theme's card color
        child: ListTile(
          trailing: Icon(Icons.arrow_right,
              color: theme.iconTheme.color), // Use theme's icon color
          title: Text(
            text,
            style: TextStyle(
              color: theme.textTheme.bodyText1?.color, // Use theme's text color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
