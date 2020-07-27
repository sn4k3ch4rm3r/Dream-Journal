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
        vividity: 50,
        date: DateTime.now(),
      );
    }
    return Scaffold(
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
          : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              RaisedButton(
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
              ),
              TextField(
                controller: _controller,
                enabled: widget.edit,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textInputAction: TextInputAction.done,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).primaryColorLight,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  hintText: 'Describe your dream in as much detail as you can'
                ),
                cursorColor: Theme.of(context).accentColor,
              ),
              Row(
                children: <Widget>[
                  Text('Lucidity:'),
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
              Row(
                children: <Widget>[
                  Text('Vividity:'),
                  Slider(
                    value: dream.vividity/100,
                    onChanged: (value){
                      if(widget.edit)
                        setState(() {
                          dream.vividity = (value*100).floor();
                        });
                    },
                  ),
                ],
              ),
              getSaveButton(),
            ],
          ),
        ),
      ),
    );
  }
  Widget getSaveButton() {
    if(dream == null || widget.edit){
      return RaisedButton(
        onPressed: (){
          if(widget.isNew)
            saveDream();
          else
            updateDream();
        },
        child: Text('Save'),
      );
    }
    else {
      return Container();
    }
  }

  void saveDream() {
    dream.dream = _controller.text;
    DatabaseProvider.db.insert(dream);
    Navigator.pop(context, 'success');
  }

  void updateDream() {
    dream.dream = _controller.text;
    DatabaseProvider.db.update(dream);
    Navigator.pop(context, dream);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}