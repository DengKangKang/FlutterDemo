import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: ListViewWithPrependedData(),
    );
  }
}

class ListViewWithPrependedData extends StatefulWidget {
  const ListViewWithPrependedData({Key? key}) : super(key: key);

  @override
  _ListViewWithPrependedDataState createState() => _ListViewWithPrependedDataState();
}

class _ListViewWithPrependedDataState extends State<ListViewWithPrependedData> {
  //列表数据
  late List<String> items;

  //前置列表用来下拉加载历史消息
  late List<String> preItems;

  Key key = const Key('ListCenter');

  @override
  void initState() {
    super.initState();
    // 初始化列表数据
    preItems = [];
    items = List.generate(20, (index) => 'Item ${index + 1}');
  }

  void prependData() {
    setState(() {
      var historyMessage = List.generate(10, (index) => '历史消息 $index');
      // 在头部添加数据
      preItems.addAll(historyMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView with Prepended Data'),
      ),
      body: CustomScrollView(
        center: key,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = preItems[index];
                return ListTile(
                  iconColor: Colors.red,
                  title: Text(item),
                );
              },
              childCount: preItems.length,
            ),
          ),
          SliverList(
            key: key,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item),
                );
              },
              childCount: items.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: prependData,
      ),
    );
  }
}
