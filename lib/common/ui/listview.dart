import 'package:flutter/material.dart';

/// A [ListView] that loads data on-demand, page-by-page as you scroll.
class InfiniteListView extends StatelessWidget {
  // TODO: Add all other ListView attributes
  // TODO: Allow discarding previously loaded pages.
  // TODO: Adaptive batch/page size based on screen size.
  InfiniteListView(
      {@required this.lastLoadedIndex,
      @required this.finished,
      @required this.loadMore,
      @required this.itemBuilder,
      this.itemExtent,
      this.padding});

  final int lastLoadedIndex;
  final bool finished;
  final VoidCallback loadMore;
  final IndexedWidgetBuilder itemBuilder;
  final double itemExtent;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemExtent: itemExtent,
      itemCount: lastLoadedIndex + (finished ? 1 : 2),
      itemBuilder: buildItem,
    );
  }

  Widget buildItem(BuildContext context, int index) {
    if (index > lastLoadedIndex) {
      // TODO: We should pre-load at an earlier point
      loadMore();
      return Center(child: CircularProgressIndicator());
    }
    return itemBuilder(context, index);
  }
}
