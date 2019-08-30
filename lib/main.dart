import 'package:flutter/material.dart' hide Builder;
import 'flutter_built_redux.dart';
import 'package:built_redux/built_redux.dart';
import 'package:built_value/built_value.dart';

part 'main.g.dart';

// App入口
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 创建store
  final store = new Store(
      reducerBuilder.build(),     ///< Reducer
      new Counter(),              ///< State
      new CounterActions()        ///< Actions
  );

  @override
  Widget build(BuildContext context) {
    return ReduxProvider(         ///< 放在App入口处，确保所有子Widget可以访问redux state
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter_Redux Demo'),
      ),
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
    return StoreConnection<Counter, CounterActions, Counter>(       ///< 监听state变化，rebuild子widget
      connect: (state) => state,
      builder: (BuildContext context, Counter counter, CounterActions actions){
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'The current count is:',
                ),
                Text(
                  '${counter.count}',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => actions.increment(5),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}

// [ReducerBuilder]可以理解为 管理action和其Imp的容器
ReducerBuilder<Counter, CounterBuilder> reducerBuilder = new ReducerBuilder()
..add(CounterActionsNames.increment, (s, a, b) {
  int count = s.count + a.payload;
  b..count = count;
});

// Actions 在这里添加action
abstract class CounterActions extends ReduxActions {
  factory CounterActions() => new _$CounterActions();
  CounterActions._();

  ActionDispatcher<int> increment;
}

// State
abstract class Counter implements Built<Counter, CounterBuilder> {
  factory Counter() => new _$Counter._(count: 0);
  Counter._();

  int get count;
}