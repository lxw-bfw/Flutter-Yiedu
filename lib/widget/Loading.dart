import 'package:flutter/material.dart';
//首次页面数据请求中
class Loading extends StatelessWidget {
 Loading({this.text});
  String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(text, style: TextStyle(fontSize: 16.0)),
          )
        ],
      ),
    );
  }
}