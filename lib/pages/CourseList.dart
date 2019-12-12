import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectpractice/common/Http.dart';
import 'package:projectpractice/pages/Search.dart';
import 'package:projectpractice/pages/course/CourseDetail.dart';
import 'package:projectpractice/widget/Goodsbox.dart';
import 'package:projectpractice/widget/LoadResultInfo.dart';
import 'package:projectpractice/widget/RatingBar.dart';

//课程列表页面：点击二级课程分类。查询到的课程显示在此页面
class CourseList extends StatefulWidget {
  //TODO:接收父页面的类别id参数以便查询课程
  CourseList({Key key, this.id, this.cname}) : super(key: key);
  //类别id
  final int id;
  final String cname;

  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
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
  //判断是否需要显示加载进度条，
  //每次进入请求数的时候设置未true
  bool isLoad = false;
  bool isInfoEmpty = false;

  getCourseByKid() {
    isLoad = true;
    setState(() {});
    Http.getData(
        '/crouseInfo/selectByKid',
        (data) {
          //获取到了数据后进行渲染
          print(data);
          if (data['data'] != null) {
            for (var i = 0; i < data['data'].length; i++) {
              if (data['data'][i]['img'] == null ||
                  !data['data'][i]['img'].contains('http')) {
                data['data'][i]['img'] =
                    'http://placehold.it/400x200?text=course...';
              }
            }
            _dataSource = data['data'];
          } else {
            _dataSource = [];
          }
          isLoad = false;
          isInfoEmpty = true;
          
          setState(() {});
        },
        params: {'kid': widget.id},
        errorCallBack: (error) {
          print('error:$error');
        });
  }

  //每次下拉刷新的时候触发
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(seconds: 2), () {
      print("正在刷新...");
      _pageSize = 0; //重新刷新：分页为0重新请求数据
      _dataSource.clear();
      getCourseByKid();
    });
  }

  // 加载更多
  Future<Null> _loadMoreData() {
    isLoad = true;
    setState(() {});
    return Future.delayed(Duration(seconds: 1), () {
      isLoad = false;
      setState(() {});
      print("正在加载更多...");
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
    print(widget.id);
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
    //因为本路由没有使用Scaffold，为了让子级Widget(如Text)使用
    //Material Design 默认的样式风格,我们使用Material作为本路由的根。
    return Material(
        //!包裹一个带上拉刷新和下拉加载的控件
        child: RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
      child: CustomScrollView(
        physics: new AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        slivers: <Widget>[
          //AppBar，包含一个导航栏
          SliverAppBar(
            pinned: true,
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  //点击进入使用 searchDelegate实现的搜索页面
                  showSearch(context: context, delegate: SearchBarDelegate());
                },
                child: Icon(
                  Icons.search,
                  size: 30.0,
                ),
              )
            ],
            expandedHeight: 180.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.cname),
              background: Image.asset(
                "./images/bg111.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          //List:课程列表listview
          new SliverFixedExtentList(
            itemExtent: _dataSource.isEmpty ? 500.0 : 110.0, //item的高度是50
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                //创建列表项
                return items(context, index);
              },
              childCount: _dataSource.isEmpty ? 1 : _dataSource.length + 1,
              //根据获取到的数据动态赋值
            ),
          ),
        ],
      ),
    ));
  }

  // 自定义列表item控件:listview里面通过遍历数据项加载这里的widget赋值数据
  Widget items(context, index) {
    if (_dataSource.isEmpty) {
      return Center(
        child: isInfoEmpty
            ? LoadResultInfo(
                info: '空空如也',
              )
            : Text(''),
      );
    } else if (index == _dataSource.length) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (isLoad)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                  ),
                ),
              if (isLoad)
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
    return GestureDetector(
      onTap: (){
        //点击进入课程详情页面
        Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CourseDetail(courseDetail: json.encode(_dataSource[index]),);
        }));
      },
      child:Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      height: 90.0,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Goodsbox(
              imgsrc: _dataSource[index]['img'],
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
                      _dataSource[index]['cname'],
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
                          '￥${_dataSource[index]['price']}',
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
    ),
    ) ;
    
  }
}
