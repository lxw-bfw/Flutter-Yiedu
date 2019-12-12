import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:projectpractice/pages/course/RecentLearning.dart';
import 'package:projectpractice/pages/course/MyStart.dart';
import 'package:projectpractice/pages/course/MyPay.dart';
import 'package:projectpractice/pages/course/ExaminationList.dart';
import 'package:projectpractice/pages/login/LoginIndex.dart';

//未登录的时候显示的页面

class UnLogin extends StatefulWidget {
  UnLogin({Key key}) : super(key: key);

  @override
  _UnLoginState createState() => _UnLoginState();
}

// 界面状态还有样式的控制
class _UnLoginState extends State<UnLogin> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    //这就是一个新的页面虽然不会覆盖状态栏，但是你可以根据自己的需要定制页面。
    return Scaffold(
        body: Container(
      //页面组件放置在占据全屏的带浅灰色的容器里面。
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: const Color(0xF2F6FCff)),
      child: RefreshIndicator(
        color: Theme.of(context).primaryColor, //定义上拉刷新circle组件的加载进度条颜色
        backgroundColor: Colors.white, // 定义上拉刷新circle组件的背景颜色

        //!带下拉刷新上拉加载组件的child属性：必须是一个可以滚动的组件如listview，这里是首页布局，
        //! 不同于列表布局，列表布局一般是加载特别多的，且都是样式差不多的，但是这里首页有轮播、其他不同
        //! 的布局容器，但是没有涉及很多组件重复加载像列表那样，所以这里不使用listview这些基于Sliver的懒加载模型
        //!当然最好是使用了。我使用SingleChildScrollView
        //!性能是真的差啊，
        // child: ListView.builder(
        //   controller: _scrollController,
        //   itemCount: _list.length == 0 ? 0
        //       : isLoading ? _list.length + 1 : _list.length,
        //       itemBuilder: (context,index){
        //         return _getRow(context,index);
        //       },
        // ),
        child: ListView(
          controller: _scrollController,
          physics:
              new AlwaysScrollableScrollPhysics(), //保证listview何时都可以下拉，以触发下拉刷新
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //顶部背景
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginIndex();
                          }));
                        },
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/unloginbg1.jpg'),
                                  fit: BoxFit.cover)),
                        ),
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      height: 160.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0), //3像素圆角
                          color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 15.0),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                //进入登录页面
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginIndex();
                                }));
                              },
                              child: ListTile(
                                contentPadding: EdgeInsets.all(0.0),
                                leading: Text(
                                  '最近学习',
                                  style: TextStyle(
                                      color: Color.fromRGBO(80, 80, 80, 1.0),
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            Row(
                              //TODO:点击进入对应的课程继续学习。
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 6.0),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'images/course3.png'),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                          Text(
                                            'java初级教程...',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 6.0),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'images/course1.jpg'),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                          Text(
                                            'java初级教程...',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 6.0),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'images/course3.png'),
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                          Text(
                                            'java初级教程...',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                      )),
                  //收藏、购买、考试
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    height: 190.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0), //3像素圆角
                        color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginIndex();
                            }));
                          },
                          child: ListTile(
                            leading: Text(
                              '我的收藏',
                              style: TextStyle(
                                  color: Color.fromRGBO(80, 80, 80, 1.0),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              size: 30.0,
                            ),
                          ),
                        ),
                        Divider(
                            height: 1.0,
                            indent: 0.0,
                            color: Color.fromRGBO(207, 207, 207, 1.0)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginIndex();
                            }));
                          },
                          child: ListTile(
                            leading: Text(
                              '已购买',
                              style: TextStyle(
                                  color: Color.fromRGBO(80, 80, 80, 1.0),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              size: 30.0,
                            ),
                          ),
                        ),
                        Divider(
                            height: 1.0,
                            indent: 0.0,
                            color: Color.fromRGBO(207, 207, 207, 1.0)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginIndex();
                            }));
                          },
                          child: ListTile(
                            leading: Text(
                              '课程考试',
                              style: TextStyle(
                                  color: Color.fromRGBO(80, 80, 80, 1.0),
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              size: 30.0,
                            ),
                          ),
                        ),
                        Divider(
                            height: 1.0,
                            indent: 0.0,
                            color: Color.fromRGBO(207, 207, 207, 1.0))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        onRefresh: _onRefresh,
      ),
    )
// This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  @override
  void dispose() {
    print("RefreshListPage _dispose()");
    _scrollController?.dispose();
    super.dispose();
  }

  //TODO:触发下拉刷新，重新获取数据渲染
  Future<void> _onRefresh() async {
    print("RefreshListPage _onRefresh()");
    await Future.delayed(Duration(seconds: 2), () {
      // _list = List.generate(15, (i) => "我是刷新出的数据${i}");
      print('触发下拉刷新');
      // setState(() {});
    });
  }

  // void _generateData() async {
  //   await Future.delayed(Duration(seconds: 2), () {
  //     print("RefreshListPage _generateData()");
  //     _list = List.generate(20, (i) => "我是初始化的数据${i}");
  //     setState(() {});
  //   });
  // }

  bool isLoading = false;

  // void _loadMore() async {
  //   print("RefreshListPage _loadMore()");
  //   if (!isLoading) {
  //     isLoading = true;
  //     setState(() {});
  //     Future.delayed(Duration(seconds: 3), () {
  //       print("RefreshListPage isLoading = ${isLoading}");
  //       isLoading = false;
  //       _list = List.from(_list);
  //       _list.addAll(List.generate(5, (index) => "上拉加载个数${index}"));
  //       setState(() {});
  //     });
  //   }
  // }

  // Widget _getRow(BuildContext context, int index) {
  //   if (index < _list.length) {
  //     return ListTile(
  //       title: Text(_list[index]),
  //     );
  //   }
  //   return _getMoreWidget();
  // }

  //返回一个widget组件--显示加载中...
  // Widget _getMoreWidget() {
  //   return Center(
  //     child: Padding(
  //       padding: EdgeInsets.all(10.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           SizedBox(
  //             width: 20,
  //             height: 20,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 4.0,
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
  //             child: Text('加载中...', style: TextStyle(fontSize: 16.0)),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

}
