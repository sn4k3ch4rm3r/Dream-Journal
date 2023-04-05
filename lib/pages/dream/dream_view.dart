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
  final DateFormat _dateFormat = DateFormat('yyyy. MM. dd.');

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
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                    onPressed: () {
                      setState(() {
                        _editing = true;
                        _dreamBackup = Dream.copy(_dream!);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                    onPressed: () {
                      Dialogs.deleteConfirmDialog(context).then((confirmed) {
                        if (confirmed) {
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
                ElevatedButton(
                  onPressed: () {
                    if (_editing) {
                      showDatePicker(
                        context: context,
                        initialDate: _dream!.date,
                        firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                        lastDate: DateTime.now(),
                      ).then((value) => {
                            if (value != null)
                              setState(() {
                                _dream!.date = value;
                              })
                          });
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 10, 20, 10)),
                  ),
                  child: Text(
                    _dateFormat.format(_dream!.date),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _controller,
                  readOnly: !_editing,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    hintText: 'Describe your dream in as much detail as you can',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {
                    1: FixedColumnWidth(55)
                  },
                  children: [
                    TableRow(
                      children: <Widget>[
                        const Text('Lucid dream:'),
                        Switch(
                          value: _dream!.isLucid,
                          onChanged: (value) {
                            if (_editing) {
                              setState(() {
                                _dream!.isLucid = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        const Text('Nightmare:'),
                        Switch(
                          value: _dream!.isNightmare,
                          onChanged: (value) {
                            if (_editing) {
                              setState(() {
                                _dream!.isNightmare = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        const Text('Recurrent:'),
                        Switch(
                          value: _dream!.isRecurrent,
                          onChanged: (value) {
                            if (_editing) {
                              setState(() {
                                _dream!.isRecurrent = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        const Text('Sleep paralysis:'),
                        Switch(
                          value: _dream!.sleepParalysisOccured,
                          onChanged: (value) {
                            if (_editing) {
                              setState(() {
                                _dream!.sleepParalysisOccured = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        const Text('False awakening:'),
                        Switch(
                          value: _dream!.falseAwakeningOccured,
                          onChanged: (value) {
                            if (_editing) {
                              setState(() {
                                _dream!.falseAwakeningOccured = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text('Vividity:'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: Slider(
                        value: _dream!.vividity.toDouble(),
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: _dream!.vividity.toString(),
                        onChanged: (value) {
                          if (_editing) {
                            setState(() {
                              _dream!.vividity = value.toInt();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                getLucidSlider(),
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

  Widget getLucidSlider() {
    if (_dream!.isLucid) {
      return Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text('Lucidity:'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 100.0),
            child: Slider(
              value: _dream!.lucidity.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: _dream!.lucidity.toString(),
              onChanged: (value) {
                if (_editing) {
                  setState(() {
                    _dream!.lucidity = value.toInt();
                  });
                }
              },
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
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
