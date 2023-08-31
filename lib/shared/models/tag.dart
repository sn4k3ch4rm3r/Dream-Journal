import 'package:flutter/material.dart';

enum TagType {
  PLACE,
  PERSON,
  TAG,
}

class Tag {
  late String name;
  late TagType type;

  Tag(this.name, this.type);

  Tag.copy(Tag other) {
    name = other.name;
    type = other.type;
  }

  IconData get iconData {
    IconData icon;
    switch (type) {
      case TagType.PLACE:
        icon = Icons.place;
        break;
      case TagType.PERSON:
        icon = Icons.person;
        break;
      default:
        icon = Icons.tag;
        break;
    }
    return icon;
  }

  Widget toChip(BuildContext context, void Function()? onDelete) {
    if (onDelete != null) {
      return InputChip(
        label: Text(name),
        avatar: Icon(iconData, color: Theme.of(context).colorScheme.onSecondaryContainer),
        onDeleted: onDelete,
      );
    } else {
      return Chip(
        label: Text(name),
        avatar: Icon(iconData, color: Theme.of(context).colorScheme.onSecondaryContainer),
      );
    }
  }

  DropdownMenuEntry<Tag> toMenuEntry() {
    return DropdownMenuEntry(
      label: name,
      value: this,
      leadingIcon: Icon(iconData),
    );
  }

  @override
  String toString() {
    return 'Tag{name: $name, type: $type}';
  }
}
