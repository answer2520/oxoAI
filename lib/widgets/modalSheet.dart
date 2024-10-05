import 'package:flutter/material.dart';

class ModalBottomSheetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Talk with AI', style: TextStyle(fontSize: 18)),
          // Add more content to your modal bottom sheet here
        ],
      ),
    );
  }
}
