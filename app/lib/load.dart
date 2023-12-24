import 'package:flutter/cupertino.dart';

class LoadPage extends StatelessWidget {
  const LoadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
            child: Text('The Marina',
                style: TextStyle(
                    // fontFamily: 'JetBrains Mono',
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: CupertinoTheme.of(context).primaryColor))));
  }
}
