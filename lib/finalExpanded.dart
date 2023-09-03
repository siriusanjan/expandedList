import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListExpand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Expandable List"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ExpandableListView(
            title: "Title $index",
          );
        },
        itemCount: 100,
      ),
    );
  }
}

class ExpandableListView extends StatefulWidget {
  final String title;

  const ExpandableListView({super.key, required this.title});

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;
  ScrollController scrollController = ScrollController();
  bool makeChildScrollable = true;

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    print(scrollController.position);
    // if (!makeChildScrollable) {
    //   setState(() {
    //     print("listScroll making true reach the top");
    //
    //     makeChildScrollable = true;
    //   });
    // }
    print("makeChildScroll");
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      print("tryScrolling true but not scroll");
      setState(() {
        makeChildScrollable = false;
      });
    } else if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        makeChildScrollable = false;
      });
    } else if (!makeChildScrollable) {
      setState(() {
        makeChildScrollable = true;
      });
    }
    if (scrollController.keepScrollOffset) {}
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      // setState(() {
      //   print("listScroll reach the bottom");
      //   makeChildScrollable = false;
      // });
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      // setState(() {
      //   print("listScroll reach the top");
      //   makeChildScrollable = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          expandFlag
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        expandFlag = !expandFlag;
                      });
                    }),
                Text(
                  widget.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          ),
          ExpandableContainer(
              expandedHeight: MediaQuery.of(context).size.height.toDouble(),
              expanded: expandFlag,
              child: ListView.builder(
                controller: scrollController,
                physics: makeChildScrollable
                    ? null
                    : const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        color: Colors.black),
                    child: ListTile(
                      title: Text(
                        "Cool $index",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.local_pizza,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                itemCount: 100,
              ))
        ],
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
        decoration:
            BoxDecoration(border: Border.all(width: 1.0, color: Colors.blue)),
      ),
    );
  }
}
