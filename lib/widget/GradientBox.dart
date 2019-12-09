import 'package:flutter/material.dart';

//封装一个背景颜色渐变的盒子
class GradientBox extends StatelessWidget {
  GradientBox(
      {Key key, this.heigth, this.title, this.introduce, this.leftColor,this.rightColor})
      : super(key: key);

  final double heigth;
  final String title;
  final String introduce;
  final Color leftColor;
  final Color rightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heigth,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            maxLines: 1,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            introduce,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 14.0),
          ),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [leftColor,rightColor]),
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
