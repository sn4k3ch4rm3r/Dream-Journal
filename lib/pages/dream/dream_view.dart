import 'package:dream_journal/pages/dream/widgets/dream_description.dart';
import 'package:dream_journal/pages/dream/widgets/property_slider.dart';
import 'package:dream_journal/pages/dream/widgets/property_switch.dart';
import 'package:dream_journal/shared/utils/database_provider.dart';
import 'package:dream_journal/shared/models/dream.dart';
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

  final TextEditingController _controller = TextEditingController();
  final DateFormat _dateFormat = DateFormat('EEEE, MMMM d, yyyy');

  @override
  void initState() {
    super.initState();
    _controller.addListener(setDreamValue);
    _dream = widget.dream == null ? null : Dream.copy(widget.dream!);
    _editing = widget.isNew;
  }

  @override
  Widget build(BuildContext context) {
    if (_dream != null) {
      _controller.text = _dream!.dream ?? '';
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
          actions: _dream != null && !_editing
              ? <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _editing = true;
                        _dreamBackup = Dream.copy(_dream!);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Dialogs.deleteConfirmDialog(context).then((confirmed) {
                        if (confirmed ?? false) {
                          DatabaseProvider.db.delete(_dream!);
                          Navigator.pop(context);
                        }
                      });
                    },
                  ),
                ]
              : <Widget>[
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      if (widget.isNew) {
                        saveDream();
                      } else {
                        updateDream();
                      }
                    },
                  ),
                ],
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
                  icon: Icon(Icons.event),
                  label: Text(
                    _dateFormat.format(_dream!.date),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 25)),
                  ),
                ),
                const SizedBox(height: 20.0),
                DreamDescription(
                  readOnly: !_editing,
                  controller: _controller,
                ),
                const SizedBox(height: 20.0),
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
                Divider(),
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
                SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setDreamValue() {
    _dream!.dream = _controller.text;
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
    _controller.dispose();
    super.dispose();
  }
}
