//课程考试列表
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectpractice/common/Global.dart';
import 'package:projectpractice/common/Http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectpractice/pages/course/CourseDetail.dart';

//我的订单
//!说明：根据tab切换不同的状态请求数据，点击对应的课程根据_currentIndex判断是什么状态，如果是待考试就进入考试页面如果是已完成就进入成绩查询页面.....
class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  List tabs = [
    '待支付',
    '已完成',
    '已失效',
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

//保存课程信息，跳转到课程详情页面需要
  var courseInfos = [];

  //TODO:每次下拉刷新的时候触发,还有切换状态的时候触发，根据状态值发起新的请求。
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(seconds: 1), () {
      print("正在刷新...");
      print(_currentIndex);
      _pageSize = 0; //重新刷新：分页为0重新请求数据
      _dataSource.clear();
      getOrders();
      setState(() {});
    });
  }

  // 加载更多
  // Future<Null> _loadMoreData() {
  //   return Future.delayed(Duration(seconds: 1), () {
  //     print("正在加载更多...");

  //     setState(() {
  //       _pageSize++;
  //       _loadData(_pageSize);
  //     });
  //   });
  // }

  // 手动调用刷新控件：初始化页面的时候
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  //根据当前的订单状态获取订单信息
  getOrders() {
    Http.getData(
        '/orderInfo/multiCriteriaQuery',
        (data) {
          print(data);
          courseInfos = [];
          var sid = Global.user.userInfo.stuid;
          for (var i = 0; i < data['data'].length; i++) {
            if (sid == data['data'][i]['stuid']) {
              print(sid);
              _dataSource.add({
                'orderId': data['data'][i]['orderId'],
                'price': data['data'][i]['price'],
                'img': '',
                'cname': '',
                'onpay': data['data'][i]['onpay']
              });
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
                    courseInfos.add(data['data']);
                    _dataSource[i]['img'] = data['data']['img'];
                    _dataSource[i]['cname'] = data['data']['cname'];
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
        params: {'onpay': _currentIndex},
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
          _scrollController.position.maxScrollExtent) {
        // _loadMoreData();
      }
    });
    super.initState();
  }

  //切换tabview的时候获取对应发起请求类别的数据
  _onTabChanged() {
    if (_tabController.index.toDouble() == _tabController.animation.value) {
      //赋值TODO:并更新数据
      this.setState(() {
        _currentIndex = _tabController.index;
      });
      showRefreshLoading();
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
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
              indicatorWeight: 2,
              indicatorColor: Colors.red,
              labelStyle: TextStyle(fontSize: 14),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                '我的订单',
                style: TextStyle(
                    color: Color.fromRGBO(56, 56, 56, 1.0),
                    fontWeight: FontWeight.bold),
              ),
            )),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: const Color(0xF2F6FCff)),
          child: RefreshIndicator(
            key: _refreshKey,
            onRefresh: _onRefresh,
            color: Theme.of(context).primaryColor,
            backgroundColor: Colors.white,
            child: ListView.builder(
              physics: new AlwaysScrollableScrollPhysics(),
              itemCount: _dataSource.isEmpty ? 0 : _dataSource.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return items(context, index);
              },
            ),
          ),
        ));
  }

  Widget items(context, index) {
    if (index == _dataSource.length) {
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
    //订单列表:
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              //阴影
              BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 4.0)
            ]),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text("订单编号:${_dataSource[index]['orderId']}"),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (_dataSource[index]['onpay'] == 0 ||
                            _dataSource[index]['onpay'] == 2)
                          GestureDetector(
                            onTap: () {
                              Http.getData(
                                  '/orderInfo/deleteByPrimaryKey',
                                  (data) {
                                    print(data);
                                    Fluttertoast.showToast(
                                        msg: "删除成功",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIos: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white);
                                    showRefreshLoading();
                                  },
                                  params: {
                                    'orderId': _dataSource[index]['orderId']
                                  },
                                  errorCallBack: (error) {
                                    print(error);
                                  });
                            },
                            child: Text(
                              '删除',
                              style: TextStyle(
                                  color: Color.fromRGBO(229, 229, 229, 1.0)),
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color.fromRGBO(80, 80, 80, 0.5)))),
            ),
            GestureDetector(
              onTap: () {
                print(courseInfos);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CourseDetail(
                    courseDetail: json.encode(courseInfos[index]),
                  );
                }));
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 0),
                      height: 70.0,
                      //设置背景颜色加遮罩层
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(_dataSource[index]['img']),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  if (_dataSource[index]['onpay'] == 1 ||
                                      _dataSource[index]['onpay'] == 0)
                                    Text(
                                      '实付 ',
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              168, 168, 168, 1.0),
                                          fontSize: 15.0),
                                    ),
                                  if (_dataSource[index]['onpay'] == 1 ||
                                      _dataSource[index]['onpay'] == 0)
                                    Text(
                                      "￥${_dataSource[index]['price']}",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 87, 51, 1.0),
                                          fontSize: 15.0),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Text('总价: '),
                          Text(
                            '￥${_dataSource[index]['price']}',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 87, 51, 1.0),
                                fontSize: 15),
                          )
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (_dataSource[index]['onpay'] == 0)
                          GestureDetector(
                            onTap: () {
                              //立即支付当前订单，即修改支付状态
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('支付确认'),
                                      content: Text('是否确认支付'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('是'),
                                          onPressed: () {
                                            Http.postData(
                                                '/orderInfo/updateByPrimaryKey',
                                                (data) {
                                                  print(data);
                                                  Fluttertoast.showToast(
                                                      msg: "支付成功",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIos: 1,
                                                      backgroundColor:
                                                          Colors.black,
                                                      textColor: Colors.white);
                                                  showRefreshLoading();
                                                  Navigator.pop(context);
                                                },
                                                params: {
                                                  "orderId": _dataSource[index]
                                                      ['orderId'],
                                                  'onpay': 1
                                                },
                                                errorCallBack: (error) {
                                                  print(error);
                                                });
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('否'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    );
                                  });
                            },
                            child: Text(
                              '立即支付',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 87, 51, 1.0),
                                  fontSize: 15),
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color.fromRGBO(80, 80, 80, 0.5)))),
            ),
          ],
        ));
  }
}
