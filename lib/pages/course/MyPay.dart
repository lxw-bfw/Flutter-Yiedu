import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectpractice/common/Global.dart';
import 'package:projectpractice/common/Http.dart';
import 'package:projectpractice/pages/course/CourseVieo.dart';
import 'package:projectpractice/widget/Goodsbox.dart';
import 'package:projectpractice/widget/LoadResultInfo.dart';
import 'package:projectpractice/widget/RatingBar.dart';

//我的购买
class MyPay extends StatefulWidget {
  @override
  _MyPayState createState() => _MyPayState();
}

class _MyPayState extends State<MyPay> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  List tabs = [
    '全部',
    'java',
    'js',
    'html',
    'css',
    'nodejs',
    'vue',
    'springboot'
  ];
  //用一个key来保存下拉刷新控件RefreshIndicator
  // 用一个key来保存下拉刷新控件RefreshIndicator
  GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  //创建滚动监听控制器，赋值给可滚动的组件controle属性就可以监听滚动了
  ScrollController _scrollController = new ScrollController();
  // 数据源
  var _dataSource = [];
  // 当前加载的页数
  int _pageSize = 0;
//加载数据

  //每次下拉刷新的时候触发
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(seconds: 2), () {
      print("正在刷新...");
      _pageSize = 0; //重新刷新：分页为0重新请求数据
      _dataSource.clear();
      getMypayCourse();
      setState(() {});
    });
  }

  // 加载更多

  // 手动调用刷新控件：初始化页面的时候
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  getMypayCourse() {
    Http.getData(
        '/orderInfo/multiCriteriaQuery',
        (data) {
          print(data);
          _dataSource = [];
          var sid = Global.user.userInfo.stuid;
          for (var i = 0; i < data['data'].length; i++) {
            if (sid == data['data'][i]['stuid']) {
              print(sid);
              //根据cid获取对应的课程信息
              Http.getData(
                  '/crouseInfo/selectByPrimaryKey',
                  (data) {
                    print(data);
                    if (data['data']['img'] == null ||
                        !data['data']['img'].contains('http')) {
                      data['data']['img'] =
                          'http://placehold.it/400x200?text=course...';
                    }
                    _dataSource.add(data['data']);
                    setState(() {});
                  },
                  params: {'cid': data['data'][i]['cid']},
                  errorCallBack: (error) {
                    print(error);
                  });
            }
          }
          setState(() {});
        },
        params: {'onpay': 1},
        errorCallBack: (error) {
          print(error);
        });
  }

  @override
  void initState() {
    //创建controller
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() => _onTabChanged());
    //初始化数据：显示下拉刷新控件 + 获取数据
    showRefreshLoading();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    super.initState();
  }

  //切换tabview的时候获取对应发起请求类别的数据
  _onTabChanged() {
    if (_tabController.index.toDouble() == _tabController.animation.value) {
      //赋值TODO:并更新数据
      this.setState(() {
        print(_tabController.index);
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
            isScrollable: true,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            indicatorWeight: 2,
            indicatorColor: Colors.red,
            labelStyle: TextStyle(fontSize: 14),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              '已购买',
              style: TextStyle(
                  color: Color.fromRGBO(56, 56, 56, 1.0),
                  fontWeight: FontWeight.bold),
            ),
          )),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        child: ListView.builder(
          physics: new AlwaysScrollableScrollPhysics(),
          itemCount: _dataSource.isEmpty ? 1 : _dataSource.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return items(context, index);
          },
        ),
      ),
    );
  }

  Widget items(context, index) {
    if (_dataSource.isEmpty) {
      //空的情况
      return Container(
        height: 300,
        alignment: Alignment.center,
        child: LoadResultInfo(
          info: '空空如也',
        ),
      );
    } else if (index == _dataSource.length) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   width: 20,
              //   height: 20,
              //   child: CircularProgressIndicator(
              //     strokeWidth: 4.0,
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              //   child: Text('加载中...', style: TextStyle(fontSize: 16.0)),
              // )
            ],
          ),
        ),
      );
    }
    //课程列表:
    return GestureDetector(
      onTap: () {
        Http.getData(
            '/videoInfo/selectByCid',
            (data) {
              var url;
              if (data['data'].length == 0) {
                url = '';
              } else {
                url = data['data'][0]['vurl'];
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CourseVideo(
                  url: url,
                  vidoeInfo: json.encode(
                    data['data'],
                  ),
                  cid: _dataSource[index]['cid'],
                );
              }));
            },
            params: {'cid': _dataSource[index]['cid']},
            errorCallBack: (error) {
              print('error:$error');
            });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        height: 100.0,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                height: 90.0,
                //设置背景颜色加遮罩层
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(_dataSource[index]['img']),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        _dataSource[index]['cname'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1.0),
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(7, 1, 7, 1),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(214, 197, 142, 0.6),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          '分享返现￥14.70',
                          style: TextStyle(
                              color: Colors.deepOrange, fontSize: 12.0),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '已经全部更新 . 已经阅读至第一章节',
                            style: TextStyle(
                                color: Color.fromRGBO(168, 168, 168, 1.0),
                                fontSize: 13.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
