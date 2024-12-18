import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:taskapp/themes/app_themes.dart';

class CardsShowData extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? labelText;
  final String? descriptionText;
  final VoidCallback onTap;

  const CardsShowData({
    Key? key,
    required this.labelText,
    required this.descriptionText,
    required this.onTap,
    this.animationController,
    this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //String formattedTime = DateFormat.jm().format(DateTime.now());
    return GestureDetector(
      // Envolver el widget en GestureDetector
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animationController!,
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - animation!.value), 0.0),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 40, right: 40, top: 10, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: TaskappTheme.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: TaskappTheme.grey.withOpacity(0.2),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 12, left: 24, right: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        labelText!, // Utiliza el texto proporcionado
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontFamily: TaskappTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 26,
                                          color: TaskappTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 6, bottom: 6),
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: TaskappTheme.background,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, top: 6, bottom: 12),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      descriptionText!,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: TaskappTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                            TaskappTheme.grey.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
