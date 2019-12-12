import 'package:flutter/material.dart';
import 'package:projectpractice/widget/RatingBar.dart';

//课程盒子widget
class CourseBox extends StatelessWidget {
CourseBox({Key key,this.imgsrc,this.title,this.score,this.studenNum,this.price}) : super(key: key);

final String imgsrc;
final String title;
final double score;//评分
final int studenNum;//学生人数
final double price;//价格
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image(
            image: NetworkImage(imgsrc),
            height: 100.0,
            fit: BoxFit.cover,
          ),
          Text(
            title,
            maxLines: 1,
            overflow:TextOverflow.ellipsis,
            style: TextStyle(
                color: Color.fromRGBO(151, 151, 151, 1.0),
                fontSize: 17.0,
                fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RatingBar(
                clickable: false,
                size: 15,
                color: Colors.green,
                padding: 0.5,
                value: score,
              ),
              Text(
                score.toString()+'分',
                style: TextStyle(color: Colors.black),
              ),
              Text(
                studenNum.toString()+'人学过',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
          Text(
            '￥ '+price.toString(),
            style: TextStyle(
                color: Color.fromRGBO(238, 104, 72, 1.0),
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
