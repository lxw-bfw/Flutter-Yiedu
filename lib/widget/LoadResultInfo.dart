
import 'package:flutter/material.dart';

//数据加载结果提示weiget：封装成全局widget方便多出复用
class LoadResultInfo extends StatelessWidget {
  LoadResultInfo({this.info});
  String info;
  @override
  Widget build(BuildContext context) {
    return Center(
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('images/infotip.jpg',width: 150,height: 120,),
          Text(info,style: TextStyle(color: Colors.black,fontSize: 14),)
        ],
      ) ,
    );
  }
}