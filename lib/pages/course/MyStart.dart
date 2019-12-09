import 'package:flutter/material.dart';
import 'package:projectpractice/widget/Goodsbox.dart';
import 'package:projectpractice/widget/RatingBar.dart';

class MyStart extends StatefulWidget {
  @override
  _MyStartState createState() => _MyStartState();
}

class _MyStartState extends State<MyStart> with SingleTickerProviderStateMixin {
//!这里关于tab的切换我不对应切换tabview，flutter的tabbar一般是配合tabview进行widget的切换，但是我这里是希望
//!视图是一样的就是一个RefreshIndicator组件，通过listview显示列表，只是切换不同的tab获取不同的数据
//!这里需要监听到tab的切换，需要使用自定义controller
  TabController _tabController;
  int _currentIndex = 0; //选中下标
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
  List<String> _dataSource = List<String>();
  // 当前加载的页数
  int _pageSize = 0;
//加载数据
  void _loadData(int index) {
    for (var i = 0; i < 15; i++) {
      _dataSource.add((i + 15 * index).toString());
    }
  }

  //TODO:每次下拉刷新的时候触发
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
  Future<Null> _loadMoreData() {
    return Future.delayed(Duration(seconds: 1), () {
      print("正在加载更多...");

      setState(() {
        _pageSize++;
        _loadData(_pageSize);
      });
    });
  }

  // 手动调用刷新控件：初始化页面的时候
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  @override
  void initState() {
    // 创建Controller
    _tabController = TabController(length: tabs.length, vsync: this);
    //!监听tab改变，以便做一些处理。
    _tabController.addListener(() => _onTabChanged());
    //初始化数据：显示下拉刷新控件 + 获取数据
    showRefreshLoading();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
    super.initState();
  }

  //切换tabview的时候获取对应发起请求类别的数据
  _onTabChanged() {
    if (_tabController.index.toDouble() == _tabController.animation.value) {
      //赋值 并更新数据
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
            tabs: tabs.map((e) => Tab(text: e)).toList(),
            isScrollable: true, //是否可滑动
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            indicatorWeight: 2,
            indicatorColor: Colors.red,
            labelStyle: TextStyle(fontSize: 14),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              '我的收藏',
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
          itemCount: _dataSource.isEmpty ? 0 : _dataSource.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return items(context, index);
          },
        ),
      ),
    );
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
      );
    }
    //课程列表:
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      height: 90.0,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Goodsbox(
              imgsrc: 'images/courselist-1.jpg',
              heigth: 80.0,
              title: '',
              introduce: '',
              opc: 0.0,
            ),
          ),
          Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Java通用型支付+电商平台双系统高级开发工程师课程',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1.0), fontSize: 16.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RatingBar(
                          clickable: false,
                          size: 15,
                          color: Colors.green,
                          padding: 0.5,
                          value: 4.8,
                        ),
                        Text(
                          '4.8分',
                          style: TextStyle(
                              color: Color.fromRGBO(168, 168, 168, 1.0)),
                        ),
                        Text(
                          '10人学过',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color.fromRGBO(168, 168, 168, 1.0)),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '￥1298',
                          style: TextStyle(
                              color: Color.fromRGBO(168, 168, 168, 1.0)),
                        )
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
