import 'package:flutter/material.dart';

class DreamDescription extends StatelessWidget {
  final bool readOnly;
  final TextEditingController controller;
  final double conrerRadius = 12;

  const DreamDescription({super.key, required this.readOnly, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      borderRadius: BorderRadius.circular(conrerRadius),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        minLines: 4,
        textInputAction: TextInputAction.done,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          alignLabelWithHint: true,
          labelText: 'Dream Description',
        ),
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
