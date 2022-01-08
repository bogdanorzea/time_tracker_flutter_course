import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/empty_content.dart';

typedef ItemWidgetBUilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBUilder<T> itemBuilder;

  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final items = snapshot.data;
      if (items.isNotEmpty) {
        return ListView.separated(
          itemCount: items.length + 2,
          itemBuilder: (context, index) {
            if (index == 0 || index == items.length + 1) return SizedBox();

            return itemBuilder(
              context,
              items[index - 1],
            );
          },
          separatorBuilder: (context, index) => Divider(height: 0.5),
        );
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: "Can't load items right now",
      );
    }

    return Center(child: CircularProgressIndicator());
  }
}
