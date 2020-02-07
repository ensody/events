import 'package:events/common/ui/listview.dart';
import 'package:events/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_state/reactive_state.dart';

void main() {
  testWidgets('InfiniteListView', (WidgetTester tester) async {
    const loadDelay = Duration(milliseconds: 5);
    var allData = List.generate(300, (index) => index + 1);
    final loaded = Value(<int>[]);
    Future<void> loadMore() async {
      await delay(loadDelay - Duration(milliseconds: 1));
      loaded.update((loaded) =>
          loaded.addAll(allData.sublist(loaded.length, loaded.length + 100)));
    }

    final itemExtent = 100.0;
    final Widget widget = Directionality(
      textDirection: TextDirection.ltr,
      child: AutoBuild(builder: (context, get, track) {
        final data = get(loaded);
        return InfiniteListView(
            lastLoadedIndex: data.length - 1,
            finished: data.length == allData.length,
            loadMore: loadMore,
            itemExtent: itemExtent,
            itemBuilder: (context, index) => Text('Item ${data[index]}'));
      }),
    );

    // Initially only a progress indicator is visible since no data is loaded
    expect(loaded.value.length, equals(0));
    await tester.pumpWidget(widget);
    expect(loaded.value.length, equals(0));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Now data should be loaded
    await tester.pumpWidget(widget, loadDelay);
    expect(loaded.value.length, equals(100));
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Test loading more data
    final ScrollableState scrollable = tester.state(find.byType(Scrollable));
    Future<void> scrollToEnd() async {
      scrollable.position.jumpTo(itemExtent * (loaded.value.length - 3));
    }

    await scrollToEnd();
    await tester.pumpWidget(widget);
    await tester.pumpWidget(widget);
    expect(find.text('Item 100'), findsOneWidget);
    expect(find.text('Item 101'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpWidget(widget, loadDelay);
    expect(loaded.value.length, equals(200));
    expect(find.text('Item 101'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await scrollToEnd();
    await tester.pumpWidget(widget);
    await tester.pumpWidget(widget);
    expect(find.text('Item 200'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpWidget(widget, loadDelay);
    expect(loaded.value.length, equals(300));
    await scrollToEnd();
    await tester.pumpWidget(widget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.pumpWidget(widget, loadDelay);
    expect(loaded.value.length, equals(300));
    expect(find.text('Item 300'), findsOneWidget);
  });
}
