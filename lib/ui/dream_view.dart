import 'package:dream_journal/data/database_provider.dart';
import 'package:dream_journal/models/dream.dart';
import 'package:dream_journal/ui/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DreamView extends StatefulWidget {
  final Dream dream;
  final bool edit;
  final bool isNew;

  DreamView({Key key, this.dream, this.edit = true, this.isNew = false}) : super(key: key);

  @override
  _DreamViewState createState() => _DreamViewState(dream);
}

class _DreamViewState extends State<DreamView> {
  bool edited = false;
  Dream dream;

  final TextEditingController _controller = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy. MM. dd.');

  @override
  void initState() { 
    super.initState();
    _controller.addListener(setDreamValue);
  }

  _DreamViewState(Dream dream) {
    this.dream = dream;
  }

  @override
  Widget build(BuildContext context) {
    if(dream != null){
      _controller.text = dream.dream;
    }
    else {
      dream = Dream(
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
        if(edited)
          Navigator.pop(context, 'edited');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isNew ? 
            'New Dream' :
            widget.edit ?
            'Edit Dream' :
            'Dream'
          ),
          leading: BackButton(
            onPressed: () {
              if(edited) {
                Navigator.pop(context, 'edited');
              }
              else {
                Navigator.pop(context);
              }
            },
          ),
          actions: dream != null && !widget.edit ? 
            <Widget>[
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                onPressed: () async {
                  Dream result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>DreamView(dream: dream, edit:true,)));
                  if(result != null) {
                    setState(() {
                      edited = true;
                      dream ??= result;
                    });
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
                onPressed: () {
                  Dialogs.deleteConfirmDialog(context).then((confirmed) {
                    if(confirmed) {
                      DatabaseProvider.db.delete(dream);
                      Navigator.pop(context, 'deleted');
                    }
                  });
                },
              ),
            ]
            : <Widget>[
              IconButton(
                icon: Icon(Icons.check),
                onPressed: (){
                  if(widget.isNew)
                    saveDream();
                  else
                    updateDream();
                },
              ),
            ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal:16.0),
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed:() {
                    if(widget.edit) 
                      showDatePicker(
                        context: context,
                        initialDate: dream.date,
                        firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                        lastDate: DateTime.now()
                      ).then((value) => {
                        if(value != null)
                          setState((){
                            dream.date = value;
                          })
                      });
                  },
                  child: Text(
                    '${dateFormat.format(dream.date)}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(20, 10, 20, 10)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _controller,
                  enabled: widget.edit,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)
                    ),
                    hintText: 'Describe your dream in as much detail as you can'
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    1: FixedColumnWidth(55)
                  },
                  children:[
                    TableRow(
                      children: <Widget>[
                        Text('Lucid dream:'),
                        Switch(
                          value: dream.isLucid,
                          onChanged: (value) {
                            if(widget.edit)
                              setState(() {
                                dream.isLucid = value;
                              });
                          },                  
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text('Nightmare:'),
                        Switch(
                          value: dream.isNightmare,
                          onChanged: (value) {
                            if(widget.edit)
                              setState(() {
                                dream.isNightmare = value;
                              });
                          },                  
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text('Recurrent:'),
                        Switch(
                          value: dream.isRecurrent,
                          onChanged: (value) {
                            if(widget.edit)
                              setState(() {
                                dream.isRecurrent = value;
                              });
                          },                  
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text('Sleep paralysis:'),
                        Switch(
                          value: dream.sleepParalysisOccured,
                          onChanged: (value) {
                            if(widget.edit)
                              setState(() {
                                dream.sleepParalysisOccured = value;
                              });
                          },                  
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Text('False awakening:'),
                        Switch(
                          value: dream.falseAwakeningOccured,
                          onChanged: (value) {
                            if(widget.edit)
                              setState(() {
                                dream.falseAwakeningOccured = value;
                              });
                          },                  
                        ),
                      ],
                    ),
                  ],
                ),
                
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Text('Vividity:'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:100.0),
                      child: Slider(
                        value: dream.vividity.toDouble(),
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: dream.vividity.toString(),
                        onChanged: (value){
                          if(widget.edit)
                            setState(() {
                              dream.vividity = value.toInt();
                            });
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
    dream.dream = _controller.text;
  }

  Widget getLucidSlider() {
    if(dream.isLucid) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: Text('Lucidity:'),
          ),
          Padding(
            padding: const EdgeInsets.only(left:100.0),
            child: Slider(
              value: dream.lucidity.toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: dream.lucidity.toString(),
              onChanged: (value){
                if(widget.edit)
                  setState(() {
                    dream.lucidity = value.toInt();
                  });
              },
            ),
          ),
        ],
      );
    }
    else {
      return Container();
    }
  }

  void saveDream() {
    DatabaseProvider.db.insert(dream);
    Navigator.pop(context, 'success');
  }

  void updateDream() {
    DatabaseProvider.db.update(dream);
    Navigator.pop(context, dream);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}