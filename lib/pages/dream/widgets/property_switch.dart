import 'package:flutter/material.dart';

class DreamPropertySwitch extends StatelessWidget {
  final String title;
  final bool value;
  final bool readOnly;
  final Function(bool) onChanged;
  const DreamPropertySwitch({super.key, required this.title, required this.value, required this.onChanged, required this.readOnly});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: Switch(
        value: value,
        onChanged: !readOnly ? onChanged : (_) {},
      ),
      onTap: !readOnly ? () => onChanged(!value) : () {},
    );
  }
}
