import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Diary',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: MyHomePage(title: 'My Diary App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          title: Text(widget.title,
            style: TextStyle(fontSize: 24.0, color: Colors.white),
            textAlign: TextAlign.center)
        ),

        body: ListView.builder(itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(5.0),
              height: 65,
              child: ListTile(
                title: Text('제목',
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('내용',
                  style: TextStyle(fontSize: 15.0),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
              ));
        }),

        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('일기 쓰기', style: TextStyle(
             color: Colors.white
            )),
            tooltip: '오늘의 일기를 남겨요',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailDiaryPage()),
              );
            }));
  }
}

class DetailDiaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Diary',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white
              )),
        ),

        body: Row(children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        //border: OutlineInputBorder(),
                        hintText: '제목',
                      ),
                    )),

                Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        //border: OutlineInputBorder(),
                        hintText: '내용',
                      ),
                    ))
              ],
            ),
          )
        ]),

        floatingActionButton:
        FloatingActionButton(child: Icon(Icons.check, color: Colors.white)));

  }
}