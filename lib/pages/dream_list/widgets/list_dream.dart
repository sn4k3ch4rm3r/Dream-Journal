import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:dream_journal/pages/dream/dream_view.dart';
import 'package:dream_journal/shared/models/dream.dart';
import 'package:flutter/material.dart';

class DreamListElement extends StatelessWidget {
  final Dream dream;
  final void Function() onChanged;
  final bool hidden;
  const DreamListElement({super.key, required this.dream, required this.onChanged, this.hidden = false});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openColor: Theme.of(context).colorScheme.surface,
      closedColor: Theme.of(context).colorScheme.surface,
      transitionDuration: const Duration(milliseconds: 400),
      onClosed: (String? data) {
        onChanged();
      },
      openBuilder: (context, action) => DreamView(dream: dream),
      closedBuilder: (context, action) => ListTile(
        leading: Text(
          dream.date.day.toString().padLeft(2, '0'),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        title: ClipRect(
          child: Stack(
            children: [
              Text(
                dream.dream ?? 'No description',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (hidden)
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.5,
                    sigmaY: .5,
                  ),
                  child: Container(),
                ),
            ],
          ),
        ),
        onTap: () => hidden ? null : action(),
      ),
    );
  }
}
