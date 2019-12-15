//启动页
import 'package:flutter/material.dart';
import 'package:projectpractice/main.dart';
import 'package:projectpractice/pages/login/LoginByPhone.dart';
import 'package:projectpractice/pages/login/Regist.dart';

class Qidong extends StatefulWidget {
  Qidong({Key key}) : super(key: key);

// 管理此widget状态和界面的State实例
  @override
  QidongState createState() => QidongState();
}

// 界面状态还有样式的控制
class QidongState extends State<Qidong> {


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
       Navigator.push(context, MaterialPageRoute(builder: (context) {
       return FramePage();
       }));
       //如果需要接收页面返p回参数
       //onPressed: () async {
       // 打开TipRoute，并等待返回结构,
       //!Navigator.push用于打开一个新页面，且返回一个Future对象，（异步的），而且Future里面包含了
       //!新路由出栈（即关闭刚才打开的页面）时的返回数据。所以这里通过await获取Future对象里面的数据。。
       //var result = await Navigator.push
    });
    // return Future.delayed(Duration(seconds: 2), () {
    //   print("正在刷新...");
    //   _pageSize = 0; //重新刷新：分页为0重新请求数据
    //   _dataSource.clear();
    //   getCourseByKid();
    // });
  }

// 构建ui界面
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/qidon1.jpg'),
                    fit: BoxFit.cover)),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 30.0, horizontal: 12.0),
                  
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image(
                      image: AssetImage('images/courseLogo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //其他方式登录是位于底部：使用绝对定位布局
          Positioned(
            bottom: 0.0,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 39.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 380.0,
                      padding: EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                         Container(
                           margin: EdgeInsets.only(right: 13.0),
                           width: 100.0,
                           child: Divider(
                                height: 2.5, indent: 0.0, color: Colors.black),
                         ),
                         Container(
                            width: 100.0,
                           child: Text('开发团队介绍'),
                         ),
                         Container(
                            width: 110.0,
                           child:  Divider(
                                height: 2.5, indent: 0.0, color: Colors.black),
                         )
                        ],
                      ),
                    ),
                    Container(
                      width: 310.0,
                      margin: EdgeInsets.only(top: 10.0),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: Text('第十六小组',style: TextStyle(color: Colors.red),),
                      )
                      
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
