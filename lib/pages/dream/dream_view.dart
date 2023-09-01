import 'package:dream_journal/pages/dream/widgets/dream_description.dart';
import 'package:dream_journal/pages/dream/widgets/property_multiselect.dart';
import 'package:dream_journal/pages/dream/widgets/property_slider.dart';
import 'package:dream_journal/pages/dream/widgets/property_switch.dart';
import 'package:dream_journal/shared/database_provider.dart';
import 'package:dream_journal/shared/firestore_manager.dart';
import 'package:dream_journal/shared/models/dream.dart';
import 'package:dream_journal/shared/models/mood.dart';
import 'package:dream_journal/shared/models/time_of_day.dart';
import 'package:dream_journal/shared/models/tag.dart';
import 'package:dream_journal/shared/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DreamView extends StatefulWidget {
  final Dream? dream;
  final bool isNew;

  const DreamView({Key? key, this.dream, this.isNew = false}) : super(key: key);

  @override
  State<DreamView> createState() => _DreamViewState();
}

class _DreamViewState extends State<DreamView> {
  bool _editing = false;
  Dream? _dream;
  Dream? _dreamBackup;

  List<Tag> _allTags = [];

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('EEEE, MMMM d, yyyy');

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(setDreamValue);
    _dream = widget.dream == null ? null : Dream.copy(widget.dream!);
    _editing = widget.isNew;
    FirestoreManager.getTags().then((value) => _allTags = value);
  }

  @override
  Widget build(BuildContext context) {
    if (_dream != null) {
      _descriptionController.text = _dream!.dream ?? '';
    } else {
      _dream = Dream(
        isLucid: false,
        isNightmare: false,
        isRecurrent: false,
        sleepParalysisOccured: false,
        falseAwakeningOccured: false,
        vividity: 5,
        lucidity: 5,
        date: DateTime.now(),
      );
    }

    List<Widget> actions = [
      IconButton(
        icon: Icon(_dream!.favourite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          if (_editing) {
            setState(() {
              _dream!.favourite = !_dream!.favourite;
            });
          }
        },
      ),
    ];
    if (_dream != null && !_editing) {
      actions.addAll([
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            setState(() {
              _editing = true;
              _dreamBackup = Dream.copy(_dream!);
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            Dialogs.deleteConfirmDialog(context).then((confirmed) {
              if (confirmed ?? false) {
                FirestoreManager.deleteDream(_dream!.firebaseId!);
                Navigator.pop(context);
              }
            });
          },
        ),
      ]);
    } else {
      actions.add(
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            FirestoreManager.saveDream(_dream!);
            if (widget.isNew) {
              Navigator.pop(context, 'success');
            } else {
              setState(() {
                _editing = false;
              });
            }
          },
        ),
      );
    }

    //All tags except the selected ones
    List<DropdownMenuEntry<Tag>> menuItems = _allTags.where((element) => !_dream!.tags.map((e) => e.name).toList().contains(element.name)).map((tag) => tag.toMenuEntry()).toList();
    List<Widget> chips = _dream!.tags
        .map(
          (tag) => tag.toChip(
            context,
            _editing
                ? () {
                    setState(() {
                      _dream!.tags.remove(tag);
                    });
                  }
                : null,
          ),
        )
        .toList();

    return WillPopScope(
      onWillPop: () async {
        if (_editing && !widget.isNew) {
          resetEdit();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isNew
              ? 'New Dream'
              : _editing
                  ? 'Edit Dream'
                  : 'Dream'),
          leading: BackButton(
            onPressed: () {
              if (_editing && !widget.isNew) {
                resetEdit();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: actions,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: <Widget>[
                FilledButton.tonalIcon(
                  onPressed: () {
                    if (_editing) {
                      showDatePicker(
                        context: context,
                        initialDate: _dream!.date,
                        firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                        lastDate: DateTime.now(),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            _dream!.date = date;
                          });
                        }
                      });
                    }
                  },
                  icon: const Icon(Icons.event),
                  label: Text(
                    _dateFormat.format(_dream!.date),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 25)),
                  ),
                ),
                const SizedBox(height: 20.0),
                DreamDescription(
                  readOnly: !_editing,
                  controller: _descriptionController,
                ),
                const SizedBox(height: 15.0),
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 8.0, // Set the spacing between the chips
                    alignment: WrapAlignment.start,
                    children: chips,
                  ),
                ),
                if (_editing) const SizedBox(height: 10.0),
                if (_editing)
                  DropdownMenu<Tag>(
                    width: MediaQuery.of(context).size.width - 32.0,
                    inputDecorationTheme: Theme.of(context).inputDecorationTheme,
                    trailingIcon: const Icon(Icons.add),
                    controller: _tagController,
                    label: const Text('Tags'),
                    dropdownMenuEntries: menuItems,
                    enableSearch: false,
                    enableFilter: true,
                    requestFocusOnTap: true,
                    onSelected: (value) async {
                      Tag? tag = value;
                      if (value == null) {
                        FocusScope.of(context).unfocus();
                        Tag? newTag = await Dialogs.newTagDialog(context, name: _tagController.text);
                        if (newTag != null) {
                          tag = newTag;
                          _allTags.add(tag);
                        } else {
                          _tagController.clear();
                          return;
                        }
                      }
                      _dream!.tags.add(tag!);
                      _tagController.clear();
                      setState(() {});
                    },
                  ),
                const SizedBox(height: 15.0),
                const Divider(),
                DreamPropertySwitch(
                  title: 'Lucid Dream',
                  value: _dream!.isLucid,
                  readOnly: !_editing,
                  onChanged: (value) => setState(() {
                    _dream!.isLucid = value;
                  }),
                ),
                DreamPropertySwitch(
                  title: 'Nightmare',
                  value: _dream!.isNightmare,
                  readOnly: !_editing,
                  onChanged: (value) => setState(() {
                    _dream!.isNightmare = value;
                  }),
                ),
                DreamPropertySwitch(
                  title: 'Sleep Paralysis',
                  value: _dream!.sleepParalysisOccured,
                  readOnly: !_editing,
                  onChanged: (value) => setState(() {
                    _dream!.sleepParalysisOccured = value;
                  }),
                ),
                DreamPropertySwitch(
                  title: 'Recurrent Dream',
                  value: _dream!.isRecurrent,
                  readOnly: !_editing,
                  onChanged: (value) => setState(() {
                    _dream!.isRecurrent = value;
                  }),
                ),
                DreamPropertySwitch(
                  title: 'False Awakening',
                  value: _dream!.falseAwakeningOccured,
                  readOnly: !_editing,
                  onChanged: (value) => setState(() {
                    _dream!.falseAwakeningOccured = value;
                  }),
                ),
                const Divider(),
                DreamPropertySlider(
                  title: 'Clarity',
                  value: _dream!.vividity,
                  readOnly: !_editing,
                  onChanged: (value) => setState(() {
                    _dream!.vividity = value;
                  }),
                ),
                if (_dream!.isLucid)
                  DreamPropertySlider(
                    title: 'Lucidity',
                    value: _dream!.lucidity,
                    readOnly: !_editing,
                    onChanged: (value) => setState(() {
                      _dream!.lucidity = value;
                    }),
                  ),
                const SizedBox(height: 16.0),
                const Divider(),
                DreamPropertyMultiselect(
                  title: 'Time of day',
                  onChanged: (value) => setState(() {
                    _dream!.time = value.firstOrNull;
                  }),
                  readOnly: !_editing,
                  segments: const [
                    ButtonSegment(
                      value: TimeOfDayEnum.night,
                      label: Text('Night'),
                      icon: Icon(Icons.nights_stay),
                    ),
                    ButtonSegment(
                      value: TimeOfDayEnum.day,
                      label: Text('Day'),
                      icon: Icon(Icons.wb_sunny),
                    ),
                  ],
                  selected: _dream!.time,
                ),
                DreamPropertyMultiselect(
                  title: 'Mood',
                  onChanged: (value) => setState(() {
                    _dream!.mood = value.firstOrNull;
                  }),
                  readOnly: !_editing,
                  segments: const [
                    ButtonSegment(
                      value: Mood.bad,
                      icon: Text('😞'),
                      label: Text('Bad'),
                    ),
                    ButtonSegment(
                      value: Mood.neutral,
                      icon: Text('😐'),
                      label: Text('Neutral'),
                    ),
                    ButtonSegment(
                      value: Mood.good,
                      icon: Text('🙂'),
                      label: Text('Good'),
                    ),
                  ],
                  selected: _dream!.mood,
                ),
                const SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setDreamValue() {
    _dream!.dream = _descriptionController.text;
  }

  void saveDream() {
    DatabaseProvider.db.insert(_dream!);
    Navigator.pop(context, 'success');
  }

  void updateDream() {
    DatabaseProvider.db.update(_dream!);
    setState(() {
      _editing = false;
    });
  }

  void resetEdit() {
    setState(() {
      _editing = false;
      _dream = _dreamBackup;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
