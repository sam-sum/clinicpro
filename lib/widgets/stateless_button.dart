import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/screen_size.dart';
import 'package:clinicpro/utilities/styles.dart';

class StatelessButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final EdgeInsets? padding;

  const StatelessButton({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.margin,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : Theme.of(context).primaryColor,
      minimumSize:
          Size(width ?? getProrataWidth(1200), height ?? getProrataHeight(60)),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getProrataWidth(30)),
      ),
    );

    return Center(
        child: SizedBox(
            width: width ?? 1200,
            child: Padding(
              padding: padding ??
                  EdgeInsets.symmetric(vertical: getProrataHeight(20)),
              child: TextButton(
                onPressed: onPressed,
                style: flatButtonStyle,
                child: Text(buttonText ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Styles.whiteColor,
                      fontSize: getProrataHeight(18),
                    )),
              ),
            )));
  }
}
