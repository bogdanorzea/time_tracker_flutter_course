import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: TabItemData.allTabs.keys.map(_buildItem).toList(),
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];

        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: widgetBuilders[item],
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(t) {
    final itemData = TabItemData.allTabs[t];
    final color = currentTab == t ? Colors.indigo : Colors.grey;

    return BottomNavigationBarItem(
      icon: Icon(itemData.icon, color: color),
      label: itemData.title,
    );
  }
}
