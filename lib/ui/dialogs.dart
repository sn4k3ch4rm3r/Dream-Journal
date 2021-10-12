import 'package:flutter/material.dart';

class Dialogs {
  static Future<bool> deleteConfirmDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are sure you want to delete this dream?', ),
          content: Text('This action can\'t be undone!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('DELETE'),
            ),
          ],
        );
      },
    );
  }
}