import 'package:flutter/material.dart' hide Builder;
import 'flutter_built_redux.dart';
import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

part 'main.g.dart';

void main() {
  // 创建store
  final store = new Store(
      reducerBuilder.build(),
      new Counter(),
      new CounterActions()
  );
//  MyApp();
  runApp(new ConnectionExample(store));
}

//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//
//        primarySwatch: Colors.blue,
//      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}

/// an example using `StoreConnection`
class ConnectionExample extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions> store;

  ConnectionExample(this.store);

  @override
  Widget build(BuildContext context) => new MaterialApp(
    title: 'flutter_built_redux_test',
    home: new ReduxProvider(
      store: store,
      child: new StoreConnection<Counter, CounterActions, int>(
        connect: (state) => state.count,
        builder: (BuildContext context, int count, CounterActions actions) {
          return new Scaffold(
            body: new Row(
              children: <Widget>[
                new RaisedButton(
                  onPressed: () => actions.increment(5),
                  child: new Text('Increment'),
                ),
                new Text('Count: $count'),
              ],
            ),
          );
        },
      ),
    ),
  );
}

/// an example using a widget that implements `StoreConnector`
class ConnectorExample extends StatelessWidget {
  final Store<Counter, CounterBuilder, CounterActions> store;

  ConnectorExample(this.store);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'flutter_built_redux_test',
      home: new ReduxProvider(
        store: store,
        child: new CounterWidget(),
      ),
    );
  }
}

/// [CounterWidget] impelments [StoreConnector] manually
class CounterWidget extends StoreConnector<Counter, CounterActions, int> {
  CounterWidget();

  @override
  int connect(Counter state) => state.count;

  @override
  Widget build(BuildContext context, int count, CounterActions actions) =>
      new Scaffold(
        body: new Row(
          children: <Widget>[
            new RaisedButton(
              onPressed: () {
                actions.increment(1);
              },
              child: new Text('Increment'),
            ),
            new Text('Count: $count'),
          ],
        ),
      );
}

ReducerBuilder<Counter, CounterBuilder> reducerBuilder = new ReducerBuilder()
..add(CounterActionsNames.increment, (s, a, b) {
  int count = s.count + a.payload;
  b..count = count;
});

abstract class CounterActions extends ReduxActions {
  factory CounterActions() => new _$CounterActions();
  CounterActions._();

  ActionDispatcher<int> increment;
}

abstract class Counter implements Built<Counter, CounterBuilder> {
  factory Counter() => new _$Counter._(count: 0);
  Counter._();

  int get count;
}