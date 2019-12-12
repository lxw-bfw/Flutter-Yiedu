import 'package:flutter/material.dart';

//封装一个背景图片带蒙版，蒙版上面有文字的widget：参数：图片地址 + 盒子高度 + 文字 + 控制蒙版的透明度
class Goodsbox extends StatelessWidget {
  Goodsbox({Key key, this.imgsrc, this.heigth, this.title,this.introduce, this.opc,this.imgType}) : super(key: key);

  final String imgsrc;
  final double heigth;
  final String title;
  final String introduce;
  final double opc;
  final int imgType ;//加载图片的方式，默认是网络图片，传2的话是本地图片
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: heigth,
          //设置背景颜色加遮罩层
          decoration: BoxDecoration(
            image: DecorationImage(
                image: imgType==2? AssetImage(imgsrc) : NetworkImage(imgsrc), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        Container(
          height: heigth,
          alignment: Alignment.center,
          child:Column(
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.0
                ),
              ),
            ],
          ) ,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, opc),
            borderRadius: BorderRadius.circular(5.0),
          ),
        )
      ],
    );
  }
}
