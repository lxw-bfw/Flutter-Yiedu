import 'package:flutter/material.dart';
import 'package:projectpractice/common/Http.dart';
import 'package:projectpractice/widget/GradientBox.dart';
import 'package:projectpractice/pages/CourseList.dart';
//类别展示页面：其中类别显示我们使用grid网格布局使用GridView

class VaryPage extends StatefulWidget {
  VaryPage({Key key}) : super(key: key);

  @override
  _VaryPageState createState() => _VaryPageState();
}

// 界面状态还有样式的控制
class _VaryPageState extends State<VaryPage> {
 
  //一级类别数组:这里需要将json数组转为dart对象,渲染左侧导航栏
  List<String> vary1 = [];
  List<String> vary2 = [];
  List<bool> selects = []; //选中状态切换
  List<Widget> varySecond = [];
  List<Widget> varyThird = [];
  var secondInfo = [];
  var thirdInfo = [];
  String currenVaryName = '获取中...';
  var _scaffoldkey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String message) {
    var snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    //初始化状态
    //获取二级类别
    getSecodVary();
  }

  getSecodVary() {
    Http.getData(
        '/kindInfo/getHigherLevel',
        (data) {
          secondInfo = data['data'];
          currenVaryName = secondInfo[0]['kindName'];
          setState(() {});
          getVary1();
          // 获取三级类别
          getThirdVary(() {
            setVary2(secondInfo[0]['kid']);
          });
        },
        params: {'level': 3, 'pageNum': 1, 'pageSize': 100},
        errorCallBack: (error) {
          print('error:$error');
           if (!(error.contains('subtype of type'))) {
            showSnackBar('获取课程信息失败，请检查网络状况再刷新试试');
          }
        });
  }

  getThirdVary(cabll) {
    Http.getData(
        '/kindInfo/getHigherLevel',
        (data) {
          thirdInfo = data['data'];
          cabll();
        },
        params: {'level': 4, 'pageNum': 1, 'pageSize': 100},
        errorCallBack: (error) {
          print('error:$error');
          if (!(error.contains('subtype of type'))) {
            showSnackBar('获取课程信息失败，请检查网络状况再刷新试试');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    //这就是一个新的页面虽然不会覆盖状态栏，但是你可以根据自己的需要定制页面。
    return Scaffold(
        key: _scaffoldkey,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //左边类别切换栏
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0),
                    // height: double.infinity, //高度占据全屏
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(242, 244, 248, 1.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //TODO:根据后台获取的一级类别数组数据生成widget数组，后台传过来的是json字符串。
                        children: varySecond.length != 0
                            ? varySecond
                            : <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 7.0),
                                  child: Text('暂无分类信息'),
                                )
                              ]),
                  ),
                ), //左边类别切换栏结束

                //右边对应的二级类别
                Expanded(
                    flex: 6,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      child: Column(
                        children: <Widget>[
                          //每一类别对应一个推荐二级类别
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: GradientBox(
                              heigth: 80.0,
                              title: currenVaryName,
                              introduce: '小白也可以学好',
                              leftColor: Colors.orange,
                              rightColor: Colors.deepOrange,
                            ),
                          ),
                          // 下面是gridview布局https://www.jianshu.com/p/fb3bf633ee12
                          GridView.count(
                              shrinkWrap: true,
                              //水平子Widget之间间距
                              crossAxisSpacing: 10.0,
                              //垂直子Widget之间间距
                              mainAxisSpacing: 30.0,
                              //GridView内边距
                              // padding: EdgeInsets.all(10.0),
                              //一行的Widget数量
                              crossAxisCount: 3,
                              //子Widget宽高比例
                              childAspectRatio: 1.0,
                              //子Widget列表
                              children: varyThird.length == 0
                                  ? <Widget>[Text('暂无分类')]
                                  : varyThird)
                        ],
                      ),
                    ))
              ],
            ),
          ),
        )

// This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  //TODO:获取二级类别
  List<Widget> getVary1() {
    vary1 = [];
    for (var i = 0; i < secondInfo.length; i++) {
      vary1.add(secondInfo[i]['kindName']);
      if (i == 0) {
        selects.add(true);
      } else {
        selects.add(false);
      }
    }
    varySecond = [];
    for (var i = 0; i < vary1.length; i++) {
      varySecond.add(getWidgetVaryItem1(vary1[i], i));
    }
    setState(() {});
    return varySecond;
  }

  //渲染单个类别
  Widget getWidgetVaryItem1(String item, index) {
    return GestureDetector(
        //TODO:点击二级类别，获取对应的二级类别
        onTap: () {
          print(secondInfo[index]['kid']);
          currenVaryName = secondInfo[index]['kindName'];
          setState(() {});
          for (var i = 0; i < selects.length; i++) {
            if (selects[i]) {
              selects[i] = false;
            }
          }
          selects[index] = true;
          getVary1();
          // 获取对应的三级类别
          setVary2(secondInfo[index]['kid']);
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: Row(
            children: <Widget>[
              //TODO:切换状态
              Icon(
                Icons.unfold_less,
                color: selects[index] ? Colors.red : Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Text(
                  item,
                  style: TextStyle(
                      color: selects[index] ? Colors.red : Colors.grey,
                      fontSize: 14.0),
                ),
              )
            ],
          ),
        ));
  }

  List<Widget> setVary2(kid) {
    varyThird = [];
    for (var i = 0; i < thirdInfo.length; i++) {
      if (kid == thirdInfo[i]['higherId']) {
        setState(() {
          varyThird.add(getWidgetVaryItem2(
              thirdInfo[i]['kindName'], thirdInfo[i]['kid']));
        });
      }
    }

    return varyThird;
  }

  // 获取单个三级类别
  Widget getWidgetVaryItem2(String name, kid) {
    return GestureDetector(
      onTap: () {
        //TODO:进入对应的课程列表
        print(kid);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CourseList(
            id: kid,
            cname: name,
          );
        }));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image(
            image: AssetImage('images/html.png'),
            fit: BoxFit.cover,
          ),
          Text(name)
        ],
      ),
    );
  }
}
