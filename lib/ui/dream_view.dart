import 'package:dream_journal/data/database_provider.dart';
import 'package:dream_journal/models/dream.dart';
import 'package:dream_journal/ui/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DreamView extends StatefulWidget {
  final Dream dream;
  final bool edit;

  DreamView({Key key, this.dream, this.edit = true}) : super(key: key);

  @override
  _DreamViewState createState() => _DreamViewState(dream);
}

class _DreamViewState extends State<DreamView> {
  bool edited = false;
  Dream dream;
  Widget _scaffoldBody;
  
  _DreamViewState(Dream dream) {
    this.dream = dream;
    
  }
  
  @override
  void initState() { 
    _scaffoldBody = buildBody();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dream == null ? 
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
                    _scaffoldBody = buildBody();
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
      body: _scaffoldBody,
    );
  }
  Widget buildBody() {
    return DreamViewBody(dream: dream, edit: widget.edit);
  }
}

class DreamViewBody extends StatefulWidget {
  final Dream dream;
  final bool edit;

  const DreamViewBody({Key key, this.dream, this.edit}) : super(key: key);
  @override
  _DreamViewBodyState createState() => _DreamViewBodyState(dream, edit);
}

class _DreamViewBodyState extends State<DreamViewBody> {
  final Dream dream;
  bool edit;

  final TextEditingController _controller = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy. MM. dd.');
  bool isLucidDream;
  double vividity;
  DateTime date;

  _DreamViewBodyState(this.dream, bool edit) {
    if(dream != null){
      print('BODY_CLASS: ${dream.toMap()}');
      isLucidDream = dream.isLucid;
      vividity = dream.vividity/100;
      date = dream.date;
      _controller.text = dream.dream;
      this.edit = edit;
    }
    else {
      isLucidDream = false;
      vividity = 0.5;
      date = DateTime.now();
      this.edit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed:() {
                if(edit) 
                  showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                    lastDate: DateTime.now()
                  ).then((value) => {
                    if(value != null)
                      setState((){
                        date = value;
                      })
                  });
              },
              child: Text(
                '${dateFormat.format(date)}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            TextField(
              controller: _controller,
              enabled: edit,
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
                  value: isLucidDream,
                  onChanged: (value) {
                    if(edit)
                      setState(() {
                        isLucidDream = value;
                      });
                  },                  
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text('Vividity:'),
                Slider(
                  value: vividity,
                  onChanged: (value){
                    if(edit)
                      setState(() {
                        vividity = value;
                      });
                  },
                ),
              ],
            ),
            getSaveButton(),
          ],
        ),
      ),
    );
  }
  Widget getSaveButton() {
    if(dream == null || edit){
      return RaisedButton(
        onPressed: (){
          if(dream == null)
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
    Dream dream = Dream(
      dream: _controller.text,
      isLucid: isLucidDream,
      vividity: (vividity*100).floor(),
      date: date,
    );
    DatabaseProvider.db.insert(dream);
    Navigator.pop(context, 'success');
  }

  void updateDream() {
    dream.date = date;
    dream.dream = _controller.text;
    dream.isLucid = isLucidDream;
    dream.vividity = (vividity*100).floor();
    DatabaseProvider.db.update(dream);
    Navigator.pop(context, dream);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}