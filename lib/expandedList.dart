import 'package:flutter/material.dart';

class MyExpandableListView extends StatefulWidget {
  const MyExpandableListView({super.key});

  @override
  State<StatefulWidget> createState() => _MyNestedListViewState();
}

class _MyNestedListViewState extends State<MyExpandableListView> {
  // Create ScrollControllers for the outer and inner ListView.builders
  final ScrollController outerScrollController = ScrollController();

  final ScrollController innerScrollController = ScrollController();
  bool makeChildScrollable = true;

  @override
  void dispose() {
    outerScrollController.dispose();
    innerScrollController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    innerScrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    // if (!makeChildScrollable) {
    //   setState(() {
    //     print("listScroll making true reach the top");
    //
    //     makeChildScrollable = true;
    //   });
    // }
    if (innerScrollController.position.pixels ==
        innerScrollController.position.maxScrollExtent) {
      print("tryScrolling true but not scroll");
    }
    if (innerScrollController.keepScrollOffset) {}
    //   if (innerScrollController.offset >=
    //       innerScrollController.position.maxScrollExtent &&
    //       !innerScrollController.position.outOfRange) {
    //     // setState(() {
    //     //   print("listScroll reach the bottom");
    //     //   makeChildScrollable = false;
    //     // });
    //   }
    //   if (innerScrollController.offset <=
    //       innerScrollController.position.minScrollExtent &&
    //       !innerScrollController.position.outOfRange) {
    //     // setState(() {
    //     //   print("listScroll reach the top");
    //     //   makeChildScrollable = false;
    //     // });
    //   }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight=MediaQuery.of(context).size.height;
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Expandable List View Example'),
            ),
            body:CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: Text('Nested Vertical Lists Example'),
                  floating: false,
                  pinned: true,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int verticalIndex) {
                      return Container(
                        height: screenHeight, // Set the height to the screen height
                        child: ListView.builder(
                          itemCount: 20, // Number of items in each vertical list
                          itemBuilder: (context, itemIndex) {
                            // Calculate the total height based on item count
                            final totalHeight = 50.0 * 20;

                            return Container(
                              height: totalHeight < screenHeight ? totalHeight : null, // Set height if less than screen height
                              margin: EdgeInsets.all(8.0),
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  'List $verticalIndex - Item $itemIndex',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    childCount: 5, // Number of vertical lists
                  ),
                ),
              ],
            )));
  }
}

class _MyExpandableListView extends State<MyExpandableListView> {
  final List<String> categories = ['Category 1', 'Category 2', 'Category 3'];
  late ScrollController _childScrollController;
  late ScrollController _parentScrollController;
  bool makeChildScrollable = true;

  @override
  void initState() {
    _childScrollController = ScrollController();
    _parentScrollController = ScrollController();
    _childScrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (!makeChildScrollable) {
      setState(() {
        makeChildScrollable = true;
      });
    }
    if (_childScrollController.offset >=
            _childScrollController.position.maxScrollExtent &&
        !_childScrollController.position.outOfRange) {
      setState(() {
        print("listScroll reach the bottom");
        makeChildScrollable = false;
      });
    }
    if (_childScrollController.offset <=
            _childScrollController.position.minScrollExtent &&
        !_childScrollController.position.outOfRange) {
      setState(() {
        print("listScroll reach the top");
        makeChildScrollable = false;
      });
    }
  }

  final Map<String, List<String>> categoryItems = {
    'Category 1': ['Item 1', 'Item 2', 'Item 3'],
    'Category 2': ['Item 4', 'Item 5'],
    'Category 3': ['Item 6', 'Item 7', 'Item 8'],
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Expandable List View Example'),
            ),
            body: ListView.builder(
              controller: _parentScrollController,
              physics:
                  !makeChildScrollable ? NeverScrollableScrollPhysics() : null,
              itemCount: 2000,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(index.toString()),
                  children: <Widget>[
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(children: [
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                              controller: _childScrollController,
                              itemCount: 200,
                              itemExtent: 100,
                              physics: makeChildScrollable
                                  ? NeverScrollableScrollPhysics()
                                  : null,
                              itemBuilder:
                                  (BuildContext context, int itemIndex) {
                                final item = itemIndex;
                                return ListTile(
                                  title: Text(itemIndex.toString()),
                                  trailing: Image.asset('assets/cat.png'),
                                  // Add other widgets or actions here
                                );
                              },
                            ),
                          )
                        ]))
                  ],
                );
              },
            )));
  }
}
