import 'package:dream_journal/pages/dream/dream_view.dart';
import 'package:dream_journal/shared/models/dream.dart';
import 'package:flutter/material.dart';

class DreamListElement extends StatelessWidget {
  final Dream dream;
  final void Function() onChanged;
  const DreamListElement({super.key, required this.dream, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        dream.date.day.toString().padLeft(2, '0'),
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      title: Text(
        dream.dream!,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () async {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DreamView(dream: dream, edit: false)),
        );
        if (result == 'edited' || result == 'deleted') {
          onChanged();
        }
      },
    );
  }
}
