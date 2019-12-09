//课程考试列表
import 'package:flutter/material.dart';


//我的课程考试
//!说明：根据tab切换不同的状态请求数据，点击对应的课程根据_currentIndex判断是什么状态，如果是待考试就进入考试页面如果是已完成就进入成绩查询页面.....
class ExaminationList extends StatefulWidget {
  @override
  _ExaminationListState createState() => _ExaminationListState();
}

class _ExaminationListState extends State<ExaminationList> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  List tabs = [
    '待考试',
    '已完成',
    '未开放',
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
    //!根据_currentIndex请求不同的状态课程
    var text = _currentIndex==0? '考试已经开始，点击进入' : _currentIndex==1? '已完成,点击进入查询考试':'考试未开放';
    for (var i = 0; i < 15; i++) {
      _dataSource.add(text);
    }
  }

  //TODO:每次下拉刷新的时候触发,还有切换状态的时候触发，根据状态值发起新的请求。
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(seconds: 2), () {
      print("正在刷新...");
      print(_currentIndex);
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
    //创建controller
    _tabController = TabController(length: tabs.length,vsync: this);
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
            tabs: tabs.map((e)=>Tab(text: e,)).toList(),
            labelColor: Colors.red,
            unselectedLabelColor:Colors.black,
            indicatorWeight: 2,
            indicatorColor: Colors.red,
            labelStyle: TextStyle(fontSize: 14),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              '课程考试',
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
                    image: AssetImage('images/courselist-1.jpg'),
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
                      'Java基础课程考试',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1.0),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _dataSource[index],
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
    );
  }
}
