import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dz_2/resources/app_color.dart';

import '../changenotif.dart';

// ignore: must_be_immutable
class StepCookWidget extends StatefulWidget {
  var stepcookInfo = [];
  var stepNumber = 0;
  var chekValues =
      []; // список значений false по количеству строк в списке stepcookInfo

  StepCookWidget({
    Key? key,
    required this.stepcookInfo,
    required this.stepNumber,
    required this.chekValues,
  }) : super(key: key);

  @override
  State<StepCookWidget> createState() => _StepCookWidgetState();
}

class _StepCookWidgetState extends State<StepCookWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    bool ready = Provider.of<Test>(context).kok;

    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.stepcookInfo.length,
          itemBuilder: (BuildContext context, int index) {
            var instructionNumber = index + 1;
            final instructionText = widget.stepcookInfo[index];
            return Padding(
                padding: const EdgeInsets.only(top: 24, left: 15, right: 15),
                child: Column(
                  children: [
                    Card(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ready
                              ? const Color.fromARGB(85, 46, 204, 112)
                              : const Color(0xffECECEC),
                        ),
                        child: Center(
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Text(
                                instructionNumber.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40,
                                  color: ready
                                      ? const Color(0xff2ECC71)
                                      : const Color(0xffC2C2C2),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 38, top: 10, bottom: 10),
                              child: SizedBox(
                                width: 220,
                                child: Center(
                                  child: Text(
                                    instructionText,
                                    style: TextStyle(
                                      color: ready
                                          ? ColorApp.textStyleDarkGreen
                                          : ColorApp.colorGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 33, left: 3),
                                  child: AnimatedBuilder(
                                    animation: _animation!,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _animation?.value,
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Checkbox(
                                              tristate: false,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              side: BorderSide(
                                                  width: 4,
                                                  color: ready
                                                      ? ColorApp
                                                          .textColorDarkGreen
                                                      : ColorApp.colorGrey),
                                              value: widget.chekValues[index],
                                              onChanged: ready
                                                  ? (value) {
                                                      setState(() {
                                                        if (widget.chekValues[
                                                            index] = value!) {
                                                          _controller
                                                              ?.forward();
                                                        } else {
                                                          _controller
                                                              ?.reverse();
                                                        }
                                                      });

                                                      // widget.chekValues[
                                                      //     index] = value;
                                                    }
                                                  : null),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 10),
                                  child: Text(
                                    '2',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: ready
                                            ? ColorApp.textColorDarkGreen
                                            : ColorApp.colorGrey),
                                  ),
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    ),
                  ],
                ));
          }),
    );
  }
}
