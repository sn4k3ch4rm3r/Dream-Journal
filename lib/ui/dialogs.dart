import 'package:flutter/material.dart';

class Dialogs {
  static Future<dynamic> deleteConfirmDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Are sure you want to delete this dream?',
          ),
          content: const Text('This action can\'t be undone!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }
}
