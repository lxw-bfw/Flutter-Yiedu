import 'package:flutter/material.dart';
import 'package:projectpractice/common/Http.dart';
import 'package:projectpractice/widget/GradientBox.dart';
//类别展示页面：其中类别显示我们使用grid网格布局使用GridView

class VaryPage extends StatefulWidget {
  VaryPage({Key key}) : super(key: key);

  @override
  _VaryPageState createState() => _VaryPageState();
}

// 界面状态还有样式的控制
class _VaryPageState extends State<VaryPage> with AutomaticKeepAliveClientMixin {

@override
  bool get wantKeepAlive => true;

  //一级类别数组:这里需要将json数组转为dart对象,渲染左侧导航栏
  List<String> vary1 = [];
  List<bool> selects = []; //选中状态切换
  List<Widget> varySecond = [];
  var secondInfo = [];
  String currenVaryName = '获取中...';

  @override
  void initState() {
    super.initState();
    //初始化状态
    //获取一级类别
    getSecodVary();
  }

  //获取不大与10个的二级类别
  getSecodVary(){
    Http.getData(
      '/kindInfo/getHigherLevel',
      (data){
        print(data);
        secondInfo = data['data'];
        currenVaryName = secondInfo[0]['kindName'];
        setState(() {
          
        });
        getVary1();
      },
      params: {'level':3,'pageNum':1,'pageSize':10},
      errorCallBack: (error){
        print('error:$error');
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    //这就是一个新的页面虽然不会覆盖状态栏，但是你可以根据自己的需要定制页面。
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //左边类别切换栏
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(top: 10.0),
              height: double.infinity, //高度占据全屏
              decoration: BoxDecoration(
                  color: Color.fromRGBO(242, 244, 248, 1.0),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //TODO:根据后台获取的一级类别数组数据生成widget数组，后台传过来的是json字符串。
                  children: varySecond),
            ),
          ), //左边类别切换栏结束

          //右边对应的二级类别
          Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    //每一类别对应一个推荐二级类别
                   Padding(
                     padding: EdgeInsets.only(bottom: 20.0),
                     child:  GradientBox(
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
                      children: <Widget>[
                        //使用GridView.build进行构建
                        GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/html.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              'HTML/CSS'
                            )
                          ],
                        ), 
                        ),
                         GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/JS.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              'Javascript'
                            )
                          ],
                        ), 
                        ),
                         GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/Vue.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              'Vue.js'
                            )
                          ],
                        ), 
                        ),
                         GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/React.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              'React.Js'
                            )
                          ],
                        ), 
                        ),
                         GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/Angular.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              'Angular'
                            )
                          ],
                        ), 
                        ),
                         GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/Nodejs.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              'Node.js'
                            )
                          ],
                        ), 
                        ),
                         GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/jQuery.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              'jQuery'
                            )
                          ],
                        ), 
                        ),
                         GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/Bootstrap.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              'Bootstrap'
                            )
                          ],
                        ), 
                        ),
                         GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/SASS.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              'SASS/LESS'
                            )
                          ],
                        ), 
                        ),
                         GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/xioacx.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              '小程序'
                            )
                          ],
                        ), 
                        ),
                         GestureDetector(
                          onTap: (){
                            //TODO:进入对应的课程列表
                          },
                          child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image(
                              image: AssetImage('images/tools.png'),
                              fit:BoxFit.cover,
                            ),
                            Text(
                              '前端工具'
                            )
                          ],
                        ), 
                        ),
                        
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    )
// This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  //TODO:获取一级类别
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
    setState(() {
      
    });
    return varySecond;
  }

  //渲染单个类别
  Widget getWidgetVaryItem1(String item, index) {
    return GestureDetector(
        //TODO:点击一级类别，获取对应的二级类别
        onTap: () {
          print(index);
          currenVaryName = secondInfo[index]['kindName'];
          setState(() {
            
          });
            for (var i = 0; i < selects.length; i++) {
              if (selects[i]) {
                selects[i] = false;
              }
            }
            selects[index] = true;
            getVary1();

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
}
