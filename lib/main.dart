import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:diary_app/database.dart';
import 'package:diary_app/diary.dart';

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
            centerTitle: true,
            toolbarHeight: 70,
            title: Text(widget.title,
                style: TextStyle(fontSize: 28.0, color: Colors.white))),
        body: FutureBuilder<List<Diary>>(
            future: DatabaseHelper().getAllDiaries(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Diary>> snapshot) {
              if (!snapshot.hasData) return Center();

              return snapshot.data.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Diary item = snapshot.data[index];

                        var formatDateTime =
                            DateFormat('yyyy-MM-dd').format(item.updatedAt);

                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                            title: Text(item.title,
                                style: TextStyle(fontSize: 18)),
                            subtitle: Text(formatDateTime + '  ' + item.body,
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.8)),
                                maxLines: 1),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              _detailDiaryPage(context, item);
                            },
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  _deleteDiary(item.id);
                                })
                          ],
                        );
                      })
                  : Container(
                      child: Center(
                          child: Column(children: <Widget>[
                      (Text("일기장이 비어있어요!",
                          style: TextStyle(color: Colors.grey, fontSize: 20)))
                    ])));
            }),
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('일기 쓰기', style: TextStyle(color: Colors.white)),
            tooltip: '오늘의 일기를 남겨요',
            onPressed: () {
              _createDiaryPage(context);
            }));
  }

  _createDiaryPage(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateDiaryPage()));

    setState(() {});
  }

  _deleteDiary(int diaryId) async {
    await DatabaseHelper().deleteDiary(diaryId);

    setState(() {});
  }

  _detailDiaryPage(BuildContext context, Diary diary) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailDiaryPage(diary: diary)));

    setState(() {});
  }
}

class MyDiaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Diary',
              style: TextStyle(fontSize: 24.0, color: Colors.white)),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check, color: Colors.white)));
  }
}

class CreateDiaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CreateDiaryWidget();
  }
}

class CreateDiaryWidget extends StatefulWidget {
  @override
  _CreateDiaryState createState() => _CreateDiaryState();
}

class _CreateDiaryState extends State<CreateDiaryWidget> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void dispose() {
    this.titleController.dispose();
    this.bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Diary',
              style: TextStyle(fontSize: 24.0, color: Colors.white)),
        ),
        body: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(children: [
              Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '제목',
                    ),
                    controller: this.titleController,
                  )),
              Container(
                  margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '내용',
                    ),
                    controller: this.bodyController,
                  ))
            ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Diary diary = new Diary(
                  title: titleController.text,
                  body: bodyController.text,
                  updatedAt: DateTime.now());

              DatabaseHelper().createDiary(diary);
              Navigator.pop(context);
            },
            child: Icon(Icons.check, color: Colors.white)));
  }
}

class DetailDiaryPage extends StatelessWidget {
  final Diary diary;

  DetailDiaryPage({Key key, @required this.diary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailDiaryWidget(diary: this.diary);
  }
}

class DetailDiaryWidget extends StatefulWidget {
  final Diary diary;

  const DetailDiaryWidget({Key key, this.diary}) : super(key: key);

  @override
  _DetailDiaryState createState() => _DetailDiaryState(this.diary);
}

class _DetailDiaryState extends State<DetailDiaryWidget> {
  final Diary diary;

  _DetailDiaryState(this.diary);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary',
            style: TextStyle(fontSize: 24.0, color: Colors.white)),
      ),
      body: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(children: [
            Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  this.diary.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                child: Text(
                  this.diary.updatedAt.toIso8601String(),
                  style: TextStyle(color: Colors.grey),
                )),
            Text(this.diary.body),
          ])),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _editPage(context);
          },
          tooltip: '일기 업데이트하기',
          child: Icon(Icons.edit, color: Colors.white)),
    );
  }

  _editPage(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditDiaryPage(diary: this.diary)));
    setState(() {});
  }
}

class EditDiaryPage extends StatelessWidget {
  final Diary diary;

  EditDiaryPage({Key key, @required this.diary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditDiaryWidget(diary: diary);
  }
}

class EditDiaryWidget extends StatefulWidget {
  final Diary diary;

  EditDiaryWidget({@required this.diary});

  @override
  _EditDiaryState createState() => _EditDiaryState(diary: diary);
}

class _EditDiaryState extends State<EditDiaryWidget> {
  TextEditingController titleController;
  TextEditingController bodyController;

  final Diary diary;

  _EditDiaryState({@required this.diary});

  @override
  void initState() {
    super.initState();

    this.titleController = TextEditingController(text: diary.title);
    this.bodyController = TextEditingController(text: diary.body);
  }

  @override
  void dispose() {
    this.titleController.dispose();
    this.bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary',
            style: TextStyle(fontSize: 24.0, color: Colors.white)),
      ),
      body: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(children: [
            Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                  controller: this.titleController,
                )),
            TextField(
              decoration: InputDecoration(
                hintText: 'Content',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: this.bodyController,
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this.diary.title = titleController.text;
          this.diary.body = bodyController.text;
          this.diary.updatedAt = DateTime.now();

          DatabaseHelper().updateDiary(this.diary);
          Navigator.pop(context);
        },
        tooltip: '새 일기',
        child: Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}
