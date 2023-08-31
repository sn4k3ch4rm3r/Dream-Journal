import 'package:flutter/material.dart';

class DreamPropertyMultiselect<T> extends StatelessWidget {
  final String title;
  final bool readOnly;
  final T? selected;
  final List<ButtonSegment<T>> segments;
  final Function(Set<dynamic>) onChanged;

  const DreamPropertyMultiselect({super.key, required this.title, required this.segments, required this.onChanged, required this.readOnly, this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Container(
            width: double.infinity,
            child: SegmentedButton(
                segments: segments,
                multiSelectionEnabled: false,
                emptySelectionAllowed: true,
                selected: {
                  selected
                },
                onSelectionChanged: (value) {
                  if (!readOnly) {
                    onChanged(value);
                  }
                }),
          ),
        ],
      ),
    );
  }
}
