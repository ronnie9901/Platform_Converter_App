import 'package:flutter/cupertino.dart';

Text buildCupertinoText(BuildContext context,String text) {
  return Text(
    text,
    style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.label, context,
      ),
    ),
  );
}