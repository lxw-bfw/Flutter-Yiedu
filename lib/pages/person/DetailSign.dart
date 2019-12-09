import 'package:flutter/material.dart';
import 'package:projectpractice/widget/Loading.dart';
import 'package:projectpractice/widget/LoadResultInfo.dart';

//积分明细页面widget:需要实现下拉加载上拉加载更多。
class DetailSign extends StatefulWidget {
  @override
  _DetailSignState createState() => _DetailSignState();
}

class _DetailSignState extends State<DetailSign> {
  GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  //创建滚动监听控制器，赋值给可滚动的组件controle属性就可以监听滚动了
  ScrollController _scrollController = new ScrollController();
  // 数据源
  List<String> _dataSource = List<String>();
  // 当前加载的页数
  int _pageSize = 0;
  //首次加载标致
  bool isOk = false;
//加载数据
  void _loadData(int index) {
    // for (var i = 0; i < 15; i++) {
    //   _dataSource.add((i + 15 * index).toString());
    // }
    _dataSource = [];
    //加载完毕
    isOk = true;
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
    // TODO: implement initState
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Builder(
          builder: (BuildContext context) {
            return CustomScrollView(
              key: PageStorageKey<String>('积分明细'),
              physics: AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                //显示我的积分总额和兑换总额
                SliverPadding(
                  padding: const EdgeInsets.all(10.0),
                  sliver: SliverFixedExtentList(
                    itemExtent:40, //item高度或宽度，取决于滑动方向
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(top:5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '积分 100',
                              style: TextStyle(fontSize: 15, color: Colors.red),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 7),
                              height: 25,
                              decoration: BoxDecoration(
                                  border: Border(
                                      left:
                                          BorderSide(color: Colors.redAccent))),
                            ),
                            Text(
                              '已兑换 0',
                              style: TextStyle(fontSize: 15, color: Colors.red),
                            ),
                          ],
                        ),
                      );
                    }, childCount: 1),
                  ),
                ),
                if (isOk && !_dataSource.isEmpty) //有数据显示
                  SliverPadding(
                    padding: const EdgeInsets.all(10.0),
                    sliver: SliverFixedExtentList(
                      itemExtent: 80.0, //item高度或宽度，取决于滑动方向
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return items(context, index);
                        },
                        childCount:
                            _dataSource.isEmpty ? 0 : _dataSource.length + 1,
                      ),
                    ),
                  ),
                if (!isOk) //数据加载中...
                  SliverPadding(
                    padding: const EdgeInsets.all(10.0),
                    sliver: SliverFixedExtentList(
                      itemExtent: 100, //item高度或宽度，取决于滑动方向
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Loading(
                          text: '玩命加载中...',
                        );
                      }, childCount: 1),
                    ),
                  ),
                if (isOk && _dataSource.isEmpty) //数据加载好了但是为空
                  SliverPadding(
                    padding: const EdgeInsets.all(10.0),
                    sliver: SliverFixedExtentList(
                      itemExtent: 300, //item高度或宽度，取决于滑动方向
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return LoadResultInfo(
                          info: '当前无积分明细信息',
                        );
                      }, childCount: 1),
                    ),
                  ),
              ],
            );
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
    //积分明细表
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 10, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '购买课程',
                  style: TextStyle(
                      fontSize: 16.0, color: Color.fromRGBO(80, 80, 80, 1.0)),
                ),
                Text(
                  '11月19日 18:21',
                  style: TextStyle(
                      fontSize: 16.0, color: Color.fromRGBO(80, 80, 80, 1.0)),
                )
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  children: <Widget>[
                    Text(
                      '-20.00',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color.fromRGBO(80, 80, 80, 1.0)),
                    ),
                    Text(
                      '剩余80',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color.fromRGBO(80, 80, 80, 1.0)),
                    )
                  ],
                ),
              ))
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(207, 207, 207, .5)))),
    );
  }
}
