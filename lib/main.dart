import 'package:flutter/material.dart';
import 'package:pagination_listview_example/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Endless scroll flutter example'),
    );
  }
}

enum LoadingState { DONE, LOADING, WAITING, ERROR }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // set data provider
  Provider dataProvider = new MemoryProvider();

  // set local state
  List<String> data = [];

  int pageNumber = 1;
  int totalItems = 20;

  bool isLoading = false;

  LoadingState loadingState = LoadingState.LOADING;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    isLoading = true;
    try {
      print("Load page ===> $pageNumber");
      var nextData =
          await dataProvider.listItems(page: pageNumber, total: totalItems);
      setState(() {
        loadingState = LoadingState.DONE;
        data.addAll(nextData);
        isLoading = false;
        pageNumber++;
      });
    } catch (e) {
      isLoading = false;
      if (loadingState == LoadingState.LOADING) {
        setState(() => loadingState = LoadingState.ERROR);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: _getListWidgetSection()),
    );
  }

  Widget _getListWidgetSection() {
    switch (loadingState) {
      case LoadingState.DONE:
        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              // > 80%
              if (!isLoading && index > (data.length * 0.8)) {
                _loadData();
              }
              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.account_circle, color: Colors.teal),
                ),
                title: Text(
                  "Item $index",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              );
            });
      case LoadingState.ERROR:
        return Text('Sorry, there was an error loading the data!');
      case LoadingState.LOADING:
        return CircularProgressIndicator();
      default:
        return Container();
    }
  }
}
