import 'package:dream_journal/ui/ui_elements.dart';
import 'package:flutter/material.dart';

import 'add_dream.dart';

class DreamList extends StatelessWidget {
  const DreamList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dreams'),
      ),
      body: DreamListBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDream()),
          )
        },
      ),
      bottomNavigationBar: UiElements.bottomNavigator(
        context,
        selected: 0
      ),
    );
  }
}

class DreamListBody extends StatefulWidget {
  DreamListBody({Key key}) : super(key: key);

  @override
  _DreamListBodyState createState() => _DreamListBodyState();
}

class _DreamListBodyState extends State<DreamListBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget> [
        ListView(
          children: <Widget>[
            Ink(
              color: Theme.of(context).accentColor,
              child: ListTile(
                dense: true,
                title: Text(
                  'July 2020',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Container(
              height: 55,
              child: ListTile(
                leading: Text(
                  '26',
                  style: Theme.of(context).textTheme.headline4,
                ),
                title: Text(
                  'Dream text will appear here akkasdfk alsdkfja éalskdjf dals alsdéf  adslkf daslf éasdlfk asdlf dasl fédsa léd aésdfk jjfkdal alsdkfj asdfk asdéf dkfj alsdfé dkfj dkalsédf jadf aésdlkfj',
                  style: Theme.of(context).textTheme.bodyText2,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              height: 55,
              child: ListTile(
                leading: Text(
                  '26',
                  style: Theme.of(context).textTheme.headline4,
                ),
                title: Text(
                  'Dream text will appear here akkasdfk dfk asdéf dkfj alsdfé dkfj dkalsédf jadf aésdlkfj',
                  style: Theme.of(context).textTheme.bodyText2,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              height: 55,
              child: ListTile(
                leading: Text(
                  '26',
                  style: Theme.of(context).textTheme.headline4,
                ),
                title: Text(
                  'Dream text will appear here ',
                  style: Theme.of(context).textTheme.bodyText2,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Ink(
              color: Theme.of(context).accentColor,
              child: ListTile(
                dense: true,
                title: Text(
                  'June 2020',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Container(
              height: 55,
              child: ListTile(
                leading: Text(
                  '26',
                  style: Theme.of(context).textTheme.headline4,
                ),
                title: Text(
                  'Dream text will appear here akkasdfk alsdkfja éalskdjf dals alsdéf  adslkf daslf éasdlfk asdlf dasl fédsa léd aésdfk jjfkdal alsdkfj asdfk asdéf dkfj alsdfé dkfj dkalsédf jadf aésdlkfj',
                  style: Theme.of(context).textTheme.bodyText2,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              height: 55,
              child: ListTile(
                leading: Text(
                  '26',
                  style: Theme.of(context).textTheme.headline4,
                ),
                title: Text(
                  'Dream text will appear here akkasdfk dfk asdéf dkfj alsdfé dkfj dkalsédf jadf aésdlkfj',
                  style: Theme.of(context).textTheme.bodyText2,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              height: 55,
              child: ListTile(
                leading: Text(
                  '26',
                  style: Theme.of(context).textTheme.headline4,
                ),
                title: Text(
                  'Dream text will appear here ',
                  style: Theme.of(context).textTheme.bodyText2,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}