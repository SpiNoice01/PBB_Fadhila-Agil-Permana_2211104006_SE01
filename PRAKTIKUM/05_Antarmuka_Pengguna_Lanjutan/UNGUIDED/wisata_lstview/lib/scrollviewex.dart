import 'package:flutter/material.dart';

class ScrollViewEx extends StatelessWidget {
  const ScrollViewEx({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        //Sliver App Bar
        const SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Demo'),
          ),
        ),
        //Sliver Grid
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: Text('Grid Item $index'),
              );
            },
            childCount: 20,
          ),
        ),
        //Sliver Fixed List
        SliverFixedExtentList(
          itemExtent: 50.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text('List Item $index'),
              );
            },
          ),
        ),
      ],
    );
  }
}
