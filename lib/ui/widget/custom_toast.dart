import 'package:admin_peka/ui/widget/responsive_widget.dart';
import 'package:flutter/material.dart';

import '../../common/styles.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({required this.msg, this.isError = false, Key? key})
      : super(key: key);

  final String msg;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isSmallScreen(context)
        ? _body(true, context)
        : _body(false, context);
  }

  Widget _body(bool isSmall, BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: isSmall
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.width / 4,
        margin: const EdgeInsets.only(bottom: 30, right: 24, left: 24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: kWhiteColor,
          boxShadow: [
            BoxShadow(
                color: kBlackColor.withOpacity(0.25),
                blurRadius: 6,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isError
                    ? Colors.red.withOpacity(0.2)
                    : Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.only(
                      left: 4, right: 5.5, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    color: isError ? Colors.red : Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    child: Icon(
                      isError ? Icons.close : Icons.done_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    alignment: Alignment.center,
                  )),
            ),
            Expanded(
              child: Text(
                msg,
                style: blackTextStyle.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
