import 'package:flutter/material.dart';
import 'package:projectpractice/common/Global.dart';
import 'package:projectpractice/common/InfoNotify.dart';
import 'package:projectpractice/models/index.dart';
import 'package:projectpractice/pages/Qidong.dart';
import 'package:projectpractice/pages/tabView/UnLogin.dart';
import 'package:provider/provider.dart';
import 'package:projectpractice/pages/tabView/HomePage.dart';
import 'package:projectpractice/pages/tabView/VaryPage.dart';
import 'package:projectpractice/pages/tabView/MyCourse.dart';
import 'package:projectpractice/pages/tabView/PersonPage.dart';
import 'package:projectpractice/pages/Search.dart';

//app每次启动要重新初始化全局变量：Global.init
// 全局状态管理应用再整个app：provider
//使用 Provider.of<T>(context) 获取指定类型的数据。
void main() =>
    Global.init().then((e) => runApp(ChangeNotifierProvider<UserModel>.value(
          notifier: UserModel(),
          child: MyApp(),
        )));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 获取User信息状态管理UserModel类
    UserModel userModel = Provider.of<UserModel>(context);
    // 获取用户的主题设置，如果为null就设置默认值。下次通过UserMOdel更改之后重新绘制这里
    Color curTheme = userModel.user.theme==null?  Colors.blue : Color(userModel.user.theme);
    Brightness curBrightness =
        userModel.user.brightnessStyle!=null ? userModel.user.brightnessStyle=='dark'? Brightness.dark : Brightness.light : Brightness.light ;
    return MaterialApp(
      title: '易教育',
      //!全局配置导航栏主题：主题更新需要。
      theme: ThemeData(
        brightness: curBrightness, //指定亮度主题，有白色/黑色两种可选.:夜间模式与白天模式的切换,默认是白天模式
        primaryColor:curTheme, // 状态栏颜色可以选择改变，状态管理
      ),
      home: Qidong(),
    );
  }
}

//开始
// 使用Material组件库提供的页面脚手架Scaffold + TabBar + drawer实现一个app的基础页面骨架
class FramePage extends StatefulWidget {
  @override
  _FramePageState createState() => _FramePageState();
}

// app脚手架页：顶部搜索框，消息框，白色背景，底部导航栏
class _FramePageState extends State<FramePage>
    with SingleTickerProviderStateMixin {
// widget管理的相关状态属性
  int _selectIndex = 0; //当前页面

  //定义一个pagecontroller 用于控制指定页面的显
  final PageController _controller = PageController(
    initialPage: 0,
  );

 //登录展示的tabview
  List<Widget> _pages = [
    //添加需要显示的页面
    HomePage(),
    VaryPage(),
    MyCourse(),//我的学习需要根据登录状态显示不同页面
    PersonPage(),
  ];
  //未登录展示的tabview
  List<Widget> _unLoginpages = [
    //添加需要显示的页面
    HomePage(),
    VaryPage(),
    UnLogin(),//我的学习需要根据登录状态显示不同页面
    PersonPage(),
  ];


  //state生命周期中的一个：做一些一次性操作，初始化什么的
  @override
  void initState() {
    super.initState();
  }

// 构建ui界面，这里我需要对顶部导航栏appBar做一些自定义实现我们需要的搜索框还有...
  @override
  Widget build(BuildContext context) {
      UserModel userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        child: Offstage(
          offstage: _selectIndex == 2 || _selectIndex == 3 ? true : false,
          child: AppBar(
            //搜索框
            title: GestureDetector(
              onTap: () {
                //点击进入使用 searchDelegate实现的搜索页面
                 showSearch(context: context,delegate: SearchBarDelegate());
              },
              child: Container(
                margin: EdgeInsets.only(left: 13.0),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 4.0),
                height: 35.0,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    Text(
                      '搜索优质课程',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
              ),
            ),
            actions: <Widget>[
// 导航栏右侧菜单
              IconButton(
                icon: Icon(
                  Icons.email,
                  size: 32.0,
                  color: Colors.white,
                ),
                onPressed: () {},
              )
            ], //
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
//底部导航栏

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                '首页',
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), title: Text('分类')),
          BottomNavigationBarItem(icon: Icon(Icons.book), title: Text('我的学习')),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('账号'))
          // BottomNavigationBarItem(icon: Icon(Icons.perso), title: Text('账号')),
        ],
        type: BottomNavigationBarType
            .fixed, //底部导航栏的类型，有fixed和shifting两个类型，显示效果不一样，使用fixed默认图标会显示对应状态颜色比如没有选择或者是选择
        currentIndex: _selectIndex,
        fixedColor:Provider.of<UserModel>(context).user.theme == null? Colors.blue : Color(Provider.of<UserModel>(context).user.theme),
        onTap: _onItemTapped,
      ),
      body: PageView(controller: _controller, children: userModel.isLogin? _pages:_unLoginpages),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.palette),
        backgroundColor:Provider.of<UserModel>(context).user.theme == null? Colors.blue : Color(Provider.of<UserModel>(context).user.theme),
        onPressed: () {
          //TODO:弹出菜单(测试)，建议是跳转路由页面，跳转到一个选择主题颜色页面
          List<Color> selectColrs = Global.themes;
          List<Widget> options = [];
          UserModel userModel = Provider.of<UserModel>(context);
          Color curTheme1 = Provider.of<UserModel>(context).user.theme == null? Colors.blue : Color(Provider.of<UserModel>(context).user.theme);
          for (var i = 0; i < selectColrs.length; i++) {
            var sl = new SimpleDialogOption(
              child: ListTile(
                leading: new Icon(
                  curTheme1 == selectColrs[i]
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selectColrs[i],
                ),
                title:
                    new Text('主题$i', style: TextStyle(color: selectColrs[i])),
              ),
              onPressed: () {
                // options[i].
                //选择主题颜色，通知userModel更新：
                var colors = [0xffe91e63,0xff2196f3,0xff00bcd4,0xffffc107,0xff4caf50,0xffcddc39];

                print(selectColrs[i]);
                User user1 = Global.user;
                user1.theme = colors[i];
                userModel.changeUserInfo(user1);
                //TODO:调用Global saveUser持久化用户信息
                Navigator.of(context).pop();
              },
            );
            options.add(sl);
          }
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return new SimpleDialog(
                  title: new Text('选择主题颜色'),
                  children: options,
                );
              });
        },
      ),
    );
  }

//点击底部导航栏，跳转到对应的页面，改变索引
  void _onItemTapped(int index) {
    _controller.jumpToPage(index);
    setState(() {
      _selectIndex = index;
    });
  }

  void _onAdd() {}
}
