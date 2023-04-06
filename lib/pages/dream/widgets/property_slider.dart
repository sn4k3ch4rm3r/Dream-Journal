import 'package:flutter/material.dart';

class DreamPropertySlider extends StatelessWidget {
  final String title;
  final int value;
  final int min;
  final int max;
  final bool readOnly;
  final Function(int) onChanged;

  const DreamPropertySlider({super.key, required this.title, required this.value, required this.onChanged, required this.readOnly, this.min = 0, this.max = 10});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              label: value.toString(),
              onChanged: readOnly ? (_) {} : (double value) => onChanged(value.toInt()),
            ),
          ),
        ),
      ],
    );
  }
}
