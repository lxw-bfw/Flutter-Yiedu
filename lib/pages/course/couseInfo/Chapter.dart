import 'dart:convert';

import 'package:flutter/material.dart';

class Chapter extends StatefulWidget {
  Chapter({Key key, this.id}) : super(key: key);
  final int id;
  @override
  _ChapterState createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
//用一个key来保存下拉刷新控件RefreshIndicator
  // 用一个key来保存下拉刷新控件RefreshIndicator
  GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  //创建滚动监听控制器，赋值给可滚动的组件controle属性就可以监听滚动了
  ScrollController _scrollController = new ScrollController();
  // 数据源
  List<ChapterConten> _dataSource = List<ChapterConten>();
  // 当前加载的页数
  int _pageSize = 0;

  //!加载数据：一次性获取全部
  void _loadData(int index) {
    var charpter =
        '[{"isParentTitle":true,"title":"课程介绍相关"},{"isParentTitle":false,"title":"1-1 课程相关技术分享"},{"isParentTitle":false,"title":"1-2 课程开发环境搭建"},{"isParentTitle":false,"title":"1-3 课程开发环境搭建"},{"isParentTitle":false,"title":"1-4 课程开发环境搭建"},{"isParentTitle":false,"title":"1-5 课程开发环境搭建"}]';
    List items = json.decode(charpter);
    for (var i = 0; i < items.length; i++) {
      var d = new ChapterConten();
      d.isParentTitle = items[i]["isParentTitle"];
      d.title = items[i]["title"];
      _dataSource.add(d);
    }
  }

  //每次下拉刷新的时候触发
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(seconds: 2), () {
      print("正在刷新...");
      _pageSize = 0; //重新刷新：分页为0重新请求数据
      _dataSource.clear();
      setState(() {
        _loadData(_pageSize);
      });
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

  @override
  void initState() {
    //初始化数据：显示下拉刷新控件 + 获取数据
    showRefreshLoading();
    print(widget.id);
    //!这里已经没用了
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     _loadMoreData();
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //带下拉刷新上拉加载
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      color: Theme.of(context).primaryColor, //定义上拉刷新circle组件的加载进度条颜色
      backgroundColor: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          physics: new AlwaysScrollableScrollPhysics(),
          itemCount: _dataSource.isEmpty ? 0 : _dataSource.length,
          itemExtent: 50.0, //强制高度为50.0
          itemBuilder: (BuildContext context, int index) {
            return items(context, index);
          }),
    );
  }

  Widget items(context, index) {
    if (index == _dataSource.length) {
      return IntrinsicHeight(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Text('加载中...', style: TextStyle(fontSize: 16.0)),
                )
              ],
            ),
          ),
        ),
      );
    }
    // 章节列表:每一行一个课程item：固定高度
    return IntrinsicHeight(
      child: Container(
          height: 40, child: getRow(_dataSource[index].isParentTitle, index)),
    );
  }

  //根据是不是标题显示列表内容
  Widget getRow(isTitle, index) {
    if (isTitle) {
      return Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(_dataSource[index].title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),),
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
             Padding(
               padding: const EdgeInsets.only(right: 8.0),
               child:  Icon(Icons.play_circle_filled,color: Colors.grey,size: 20.0,),
             ),
            Text(_dataSource[index].title,style: TextStyle(color: Colors.grey),)
          ],
        ),
      );
    }
  }
}

//课程章节 实体类
class ChapterConten {
  bool isParentTitle;
  String title;
}
