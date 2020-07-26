import 'dart:ffi';

import 'package:flutter/material.dart';

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
  
  bool isLucidDream = false;
  double vividity = 0.5;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _controller,
              maxLines: 20,
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
    print('isLucidDream: $isLucidDream');
    print('vividity: $vividity');
    print('dream: ${_controller.text}');
    //Get date
    //Save to sqlite
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}