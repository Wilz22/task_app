import 'package:taskapp/views/app_home_screen.dart';
import 'package:taskapp/widgets/cards_data.dart';

import '/widgets/title_view.dart';
import 'package:flutter/material.dart';
import '/themes/app_themes.dart';

class AllPhrasesScreen extends StatefulWidget {
  const AllPhrasesScreen({Key? key, this.animationController})
      : super(key: key);

  final AnimationController? animationController;
  @override
  State<AllPhrasesScreen> createState() => _AllPhrasesScreenState();
}

class _AllPhrasesScreenState extends State<AllPhrasesScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(
      TitleView(
        titleTxt: 'Formularios',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 0, 1.0,
                curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      CardsShowData(
        labelText: 'Mensaje motivacional',
        descriptionText: '* Presiona para poder ingresar un mensaje',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 5, 1.0,
                curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        onTap: () {
          if (!mounted) {
            return;
          }
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TaskappHomeScreen(
                  initialIndex: 1, // Pasa el índice inicial
                ),
              ),
            );
          });
        },
      ),
    );
    listViews.add(
      CardsShowData(
        labelText: 'Tareas',
        descriptionText: '* Presiona para poder ingresar tareas',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval((1 / count) * 5, 1.0,
                curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
        onTap: () {
          if (!mounted) {
            return;
          }
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TaskappHomeScreen(
                  initialIndex: 0, // Pasa el índice inicial
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TaskappTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  // Widget getAppBarUI() {
  //   return Column(
  //     children: <Widget>[
  //       AnimatedBuilder(
  //         animation: widget.animationController!,
  //         builder: (BuildContext context, Widget? child) {
  //           return FadeTransition(
  //             opacity: topBarAnimation!,
  //             child: Transform(
  //               transform: Matrix4.translationValues(
  //                   0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   color: TaskappTheme.white.withOpacity(topBarOpacity),
  //                   borderRadius: const BorderRadius.only(
  //                     bottomLeft: Radius.circular(32.0),
  //                   ),
  //                   boxShadow: <BoxShadow>[
  //                     BoxShadow(
  //                         color: TaskappTheme.grey
  //                             .withOpacity(0.4 * topBarOpacity),
  //                         offset: const Offset(1.1, 1.1),
  //                         blurRadius: 10.0),
  //                   ],
  //                 ),
  //                 child: Column(
  //                   children: <Widget>[
  //                     SizedBox(
  //                       height: MediaQuery.of(context).padding.top,
  //                     ),
  //                     Padding(
  //                       padding: EdgeInsets.only(
  //                           left: 16,
  //                           right: 16,
  //                           top: 16 - 8.0 * topBarOpacity,
  //                           bottom: 12 - 8.0 * topBarOpacity),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: <Widget>[
  //                           Expanded(
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Text(
  //                                 'Training',
  //                                 textAlign: TextAlign.left,
  //                                 style: TextStyle(
  //                                   fontFamily: TaskappTheme.fontName,
  //                                   fontWeight: FontWeight.w700,
  //                                   fontSize: 22 + 6 - 6 * topBarOpacity,
  //                                   letterSpacing: 1.2,
  //                                   color: TaskappTheme.darkerText,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             height: 38,
  //                             width: 38,
  //                             child: InkWell(
  //                               highlightColor: Colors.transparent,
  //                               borderRadius: const BorderRadius.all(
  //                                   Radius.circular(32.0)),
  //                               onTap: () {},
  //                               child: Center(
  //                                 child: Icon(
  //                                   Icons.keyboard_arrow_left,
  //                                   color: TaskappTheme.grey,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(
  //                               left: 8,
  //                               right: 8,
  //                             ),
  //                             child: Row(
  //                               children: <Widget>[
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(right: 8),
  //                                   child: Icon(
  //                                     Icons.calendar_today,
  //                                     color: TaskappTheme.grey,
  //                                     size: 18,
  //                                   ),
  //                                 ),
  //                                 Text(
  //                                   '15 May',
  //                                   textAlign: TextAlign.left,
  //                                   style: TextStyle(
  //                                     fontFamily: TaskappTheme.fontName,
  //                                     fontWeight: FontWeight.normal,
  //                                     fontSize: 18,
  //                                     letterSpacing: -0.2,
  //                                     color: TaskappTheme.darkerText,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           SizedBox(
  //                             height: 38,
  //                             width: 38,
  //                             child: InkWell(
  //                               highlightColor: Colors.transparent,
  //                               borderRadius: const BorderRadius.all(
  //                                   Radius.circular(32.0)),
  //                               onTap: () {},
  //                               child: Center(
  //                                 child: Icon(
  //                                   Icons.keyboard_arrow_right,
  //                                   color: TaskappTheme.grey,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       )
  //     ],
  //   );
  // }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: TaskappTheme.white, // Opacidad fija
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: TaskappTheme.grey
                      .withOpacity(0.4), // Sin opacidad variable
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8.0, // Valores estáticos
                  bottom: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Tareas',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: TaskappTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 22, // Sin dependencia de topBarOpacity
                            letterSpacing: 1.2,
                            color: TaskappTheme.darkerText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 38,
                      width: 38,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {},
                        child: const Center(
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: TaskappTheme.grey,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.calendar_today,
                              color: TaskappTheme.grey,
                              size: 18,
                            ),
                          ),
                          Text(
                            '18 Dec',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: TaskappTheme.fontName,
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              letterSpacing: -0.2,
                              color: TaskappTheme.darkerText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 38,
                      width: 38,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {},
                        child: const Center(
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: TaskappTheme.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
