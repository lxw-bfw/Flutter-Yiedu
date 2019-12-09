//课程评论
import 'package:flutter/material.dart';
import 'package:projectpractice/widget/ListItem.dart';

class CourseComment extends StatefulWidget {
  @override
  _CourseCommentState createState() => _CourseCommentState();
}

class _CourseCommentState extends State<CourseComment> {
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
      color: Theme.of(context).primaryColor, //定义上拉刷新circle组件的加载进度条颜色
      backgroundColor: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          physics: new AlwaysScrollableScrollPhysics(),
          itemCount: _dataSource.isEmpty ? 0 : _dataSource.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return items(context, index);
          }),
    );
  }

  //!构建评论列表：这里的话：如果别人回复的话只显示三条回复，点击进入对应页面查看全部回复，这样不用嵌套listview
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
    return IntrinsicHeight(
      //评论列表，根据是否有评论动态设置高度
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        height: index < 3 ? 200.0 : 110.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: new Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                )),
            Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        '黑崎一护',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1.0),
                            fontSize: 16.0),
                      ),
                      //显示评论根据是否用评论进行返回
                      Row(
                        children: <Widget>[
                          Text(
                            '2017-10-11',
                            style: TextStyle(
                                color: Color.fromRGBO(168, 168, 168, 1.0)),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '十分推荐这种课程,十分推荐这种课程',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
                          ),
                        ],
                      ),
                      //别人的回复：动态显示
                      getRecovery(index)
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  //动态显示回去评论；根据是否有评论
  Widget getRecovery(index) {
    //回复不为空
    if (index < 3) {
      return Container(
        height: 100.0,
        decoration: BoxDecoration(
            color: Color.fromRGBO(229, 229, 229, 1.0),
            borderRadius: BorderRadius.circular(3.0)),
        child: Column(
          //TODO:只显示三个人评论，最大占一行
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                  child: Text(
                    '白一护:',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                Expanded(
                  child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                  child: Text(
                    '麻麻，我想吃烤山药...' * 3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                  child: Text(
                    '露琪亚:',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                Expanded(
                  child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                  child: Text(
                    '吃，两块够吗.' * 3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
              ],
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                  child: Text(
                    '白一护:',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                Expanded(
                  child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                  child: Text(
                    '够了，谢谢麻麻，麻麻真好!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
