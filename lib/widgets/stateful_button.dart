import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/screen_size.dart';
import 'package:clinicpro/utilities/styles.dart';

class StatefulButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String buttonText;
  final EdgeInsets? margin;
  final double? height;
  final double? width;

  const StatefulButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.margin,
    this.width,
    this.height,
  });

  @override
  State<StatefulButton> createState() => _StatefulButtonState();
}

class _StatefulButtonState extends State<StatefulButton> {
  bool _isLoading = false;
  final Color _progressColor = Styles.whiteColor;

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      minimumSize: Size(widget.width ?? getProrataWidth(1200),
          widget.height ?? getProrataHeight(60)),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getProrataWidth(8)),
      ),
    );

    return Center(
        child: SizedBox(
            width: widget.width ?? 1200,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: getProrataHeight(20)),
              child: TextButton(
                onPressed: () async {
                  _changeLoading();
                  await widget.onPressed.call();
                  _changeLoading();
                },
                style: flatButtonStyle,
                child: _isLoading
                    ? CircularProgressIndicator(color: _progressColor)
                    : Text(widget.buttonText ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Styles.whiteColor,
                          fontSize: getProrataHeight(18),
                        )),
              ),
            )));
  }
}
