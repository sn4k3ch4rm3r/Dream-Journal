import 'package:dream_journal/shared/models/tag.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<dynamic> deleteConfirmDialog(BuildContext context) {
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

  static Future<dynamic> newTagDialog(BuildContext context, {required String name}) {
    TextEditingController controller = TextEditingController(text: name);
    TagType type = TagType.tag;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'New Tag',
          ),
          content: IntrinsicHeight(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  controller: controller,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<TagType>(
                  decoration: const InputDecoration(
                    labelText: 'Type',
                  ),
                  value: type,
                  onChanged: (value) {
                    if (value != null) {
                      type = value;
                    }
                  },
                  items: const [
                    DropdownMenuItem<TagType>(
                      value: TagType.tag,
                      child: Row(
                        children: [
                          Icon(Icons.tag),
                          SizedBox(width: 8.0),
                          Text('Tag'),
                        ],
                      ),
                    ),
                    DropdownMenuItem<TagType>(
                      value: TagType.person,
                      child: Row(
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 8.0),
                          Text('Person'),
                        ],
                      ),
                    ),
                    DropdownMenuItem<TagType>(
                      value: TagType.place,
                      child: Row(
                        children: [
                          Icon(Icons.place),
                          SizedBox(width: 8.0),
                          Text('Place'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, Tag(controller.text, type));
              },
              child: const Text('ADD'),
            ),
          ],
        );
      },
    );
  }
}
