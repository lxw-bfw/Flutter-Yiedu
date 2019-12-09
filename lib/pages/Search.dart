//使用SearchDelegate封装的一个搜索页面：这里是用于课程搜索
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:projectpractice/widget/Goodsbox.dart';
import 'package:projectpractice/widget/RatingBar.dart';

typedef SearchItemCall = void Function(String item);

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    //右侧显示内容 这里放清除按钮
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //左侧显示内容 这里放了返回按钮
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //TODO:点击了搜索，获取数据后显示查询到结果的页面
    //带下拉刷新，上拉加载的。不过listview的长度要加2，一个是第一行显示共加载多少条数据的，一个是最后一行显示加载更多的
    //这里我使用一个新的带自己状态的widget
    return searchResult(keywords: 'java',);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //点击了搜索窗显示的页面
    return SearchContentView(
      fback: (val) {
        query = val;
        print(query);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context);
  }
}

class SearchContentView extends StatefulWidget {
  SearchContentView({Key key, this.fback}) : super(key: key);

  var fback = (String content) {};

  @override
  _SearchContentViewState createState() => _SearchContentViewState();
}

class _SearchContentViewState extends State<SearchContentView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              '大家都在搜',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SearchItemView(),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              '历史记录',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SearchItemView(
            fb: (val) {
              widget.fback(val);
            },
          )
        ],
      ),
    );
  }
}

class SearchItemView extends StatefulWidget {
  SearchItemView({Key key, this.fb}) : super(key: key);

  var fb = (String searchContent) {};
  @override
  _SearchItemViewState createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  List<String> items = [
    '面试',
    'Studio3',
    '动画dfsfds',
    '自定义View',
    '性能优化',
    'gradle',
    'Camera',
    '代码混淆 安全',
    '逆向加固'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 10,
        // runSpacing: 0,
        children: items.map((item) {
          return SearchItem(
            title: item,
            fback: (val) {
              widget.fb(val);
            },
          );
        }).toList(),
      ),
    );
  }
}

class SearchItem extends StatefulWidget {
  @required
  final String title;

  SearchItem({Key key, this.title, this.fback}) : super(key: key);

  var fback = (String searchConten) {
    print(searchConten);
  };

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Chip(
          label: Text(widget.title),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onTap: () {
          //点击历史搜索或者是大家都在搜到item，把对应的字段赋值给query，点击搜索就可以搜索了
          print(widget.title);
        },
      ),
      color: Colors.white,
    );
  }
}

//查询结果显示
class searchResult extends StatefulWidget {
  //传如搜索关键词
  searchResult({Key key, this.keywords}) : super(key: key);
  final String keywords;
  @override
  _searchResultState createState() => _searchResultState();
}

class _searchResultState extends State<searchResult> {

  GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  //创建滚动监听控制器，赋值给可滚动的组件controle属性就可以监听滚动了
  ScrollController _scrollController = new ScrollController();
  // 数据源
  List<ChapterConten> _dataSource = List<ChapterConten>();
  // 当前加载的页数
  int _pageSize = 0;
  bool _isRefreshOk = false;//判断下拉刷新是否结束

  
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
        _isRefreshOk = true;
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
    _isRefreshOk = false;
    new Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  @override
  void initState() {
    //初始化数据：显示下拉刷新控件 + 获取数据
    showRefreshLoading();
    print(widget.keywords);
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
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      color: Theme.of(context).primaryColor, //定义上拉刷新circle组件的加载进度条颜色
      backgroundColor: Colors.white,
      child:  ListView.builder(
          shrinkWrap: true,
          physics: new AlwaysScrollableScrollPhysics(),
          itemCount: _dataSource.isEmpty ? 1 : _dataSource.length+2,
          itemBuilder: (BuildContext context, int index) {
            return items(context, index);
          }),
    );
  }

  //TODO:需要判断真实数据为空和不为空的情况。
   Widget items(context,index){
     if (index == 0 && _isRefreshOk ) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 12.0),
          child: Text(
            '共找到${_dataSource.length}个相关内容',
          ),
        );  
     } else if (index == _dataSource.length+2 && _isRefreshOk) {
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
     //搜索到的课程列表:
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
//课程章节 实体类
class ChapterConten {
  bool isParentTitle;
  String title;
}