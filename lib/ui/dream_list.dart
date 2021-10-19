import 'package:dream_journal/data/database_provider.dart';
import 'package:dream_journal/models/dream.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dream_view.dart';

class DreamList extends StatefulWidget {
  const DreamList({Key key}) : super(key: key);

  @override
  _DreamListState createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dreams'),
      ),
      body: DreamListBody(),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Icon(
          Icons.add,
        ),
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DreamView(isNew: true)),
          );
          if(result == 'success') {
            setState(() {});
          }
        },
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
  Future<Widget> getDreams() async {
    List<Dream> dreams = await DatabaseProvider.db.getDreams();
    List<Widget> listElements = [];
    if(dreams.length > 0) {
      dreams.sort((a, b) => a.date.millisecondsSinceEpoch.compareTo(b.date.millisecondsSinceEpoch));
      dreams = dreams.reversed.toList();
      DateTime prevDate = dreams.first.date;
      listElements.add(listViewMonth(prevDate));
      dreams.forEach((dream) {
        if(dream.date.month != prevDate.month || dream.date.year != prevDate.year){
          prevDate = dream.date;
          listElements.add(listViewMonth(prevDate));
        }
        listElements.add(listViewDream(dream));
      });
      return ListView(
        children:listElements
      );
    }
    else {
      return Center(
        child: Text('You have not saved any dreams yet.'),
      );
    }
  }

  Container listViewDream(Dream dream) {
    return Container(
      height: 65,
      child: ListTile(
        leading: Text(
          '${dream.date.day.toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.headline4,
        ),
        title: Text(
          dream.dream,
          style: Theme.of(context).textTheme.bodyText2,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () async{
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DreamView(dream: dream, edit:false)),
          );
          if(result == 'edited' || result == 'deleted') {
            setState(() {});
          }
        },
      ),
    );
  }

  Ink listViewMonth(DateTime date) {
    DateFormat dateFormat = DateFormat('MMMM yyyy');
    return Ink(
      color: Theme.of(context).colorScheme.secondary,
      child: ListTile(
        dense: true,
        title: Text(
          '${dateFormat.format(date)}',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDreams(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData)
          return snapshot.data;
        else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}