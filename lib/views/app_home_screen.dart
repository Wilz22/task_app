import 'package:taskapp/views/app_phrases.dart';

import '/models/icons_data.dart';
import 'package:flutter/material.dart';
import 'package:taskapp/widgets/bottom_bar_view.dart';
import '/themes/app_themes.dart';
import 'app_tasks_data.dart';
import 'app_messages_table.dart';

class TaskappHomeScreen extends StatefulWidget {
  final int? initialIndex;

  const TaskappHomeScreen({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<TaskappHomeScreen> createState() => _TaskappHomeScreenState();
}

class _TaskappHomeScreenState extends State<TaskappHomeScreen>
    with TickerProviderStateMixin {
  int? currentIndex;
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: TaskappTheme.background,
  );

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    if (currentIndex != null) {
      tabIconsList[currentIndex!].isSelected = true;
    }

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = AllPhrasesScreen(animationController: animationController);
    setTabBody();
  }

  void setTabBody() {
    if (currentIndex == null) {
      setRemoveAllSelection();
      tabBody = AllPhrasesScreen(animationController: animationController);
    } else if (currentIndex == 0) {
      tabBody = AppTasksData(animationController: animationController);
    } else if (currentIndex == 1) {
      tabBody = MessagesTable(animationController: animationController);
    } else {
      setRemoveAllSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TaskappTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  void setRemoveAllSelection() {
    for (final tab in tabIconsList) {
      tab.isSelected = false;
    }
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            if (!mounted) {
              return;
            }
            setState(() {
              setRemoveAllSelection();
              tabBody =
                  AllPhrasesScreen(animationController: animationController);
            });
          },
          changeIndex: (int index) {
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      AppTasksData(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MessagesTable(animationController: animationController);
                  // tabBody = const MessagesTable(
                  //   title: 'Mensajes Motivacionales',
                  // );
                });
              });
            }
          },
        ),
      ],
    );
  }
}
