import 'package:dream_journal/data/database_provider.dart';
import 'package:dream_journal/models/dream.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddDream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Dream'),
      ),
      body: AddDreamBody(),
    );
  }
}

class AddDreamBody extends StatefulWidget {
  @override
  _AddDreamBodyState createState() => _AddDreamBodyState();
}

class _AddDreamBodyState extends State<AddDreamBody> {
  final TextEditingController _controller = TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy. MM. dd.');
  bool isLucidDream = false;
  double vividity = 0.5;
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                  lastDate: DateTime.now()
                ).then((value) => {
                  setState((){
                    date=value;
                  })
                });
              },
              child: Text('${dateFormat.format(date)}'),
            ),
            TextFormField(
              controller: _controller,
              maxLines: 20,
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
                  onChanged:(value) {
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
                    setState(() {
                      vividity = value;
                    });
                  },
                ),
              ],
            ),
            RaisedButton(
              onPressed: (){
                saveDream();
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}