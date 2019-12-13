//课程评论
import 'package:flutter/material.dart';
import 'package:projectpractice/common/Global.dart';
import 'package:projectpractice/common/Http.dart';
import 'package:projectpractice/common/Utils.dart';
import 'package:projectpractice/widget/ListItem.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projectpractice/widget/LoadResultInfo.dart';

class CourseComment extends StatefulWidget {
  CourseComment({Key key, this.cid}) : super(key: key);
  final int cid;
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
  var _dataSource = [];
  // 当前加载的页数
  int _pageSize = 1;
  // 当前评论数据总条数
  int totalSize = 0;
  //判断是否是最后一条数据
  bool isEnd = false;

  //评论text
  String commonText;

  //加载数据
  // void _loadData(int index) {
  //   for (var i = 0; i < 15; i++) {
  //     _dataSource.add((i + 15 * index).toString());
  //   }
  // }

  //每次下拉刷新的时候触发
  Future<Null> _onRefresh() {
    return Future.delayed(Duration(seconds: 2), () {
      print("正在刷新...");
      _pageSize = 1; //重新刷新：分页为0重新请求数据
      _dataSource.clear();
      searchComments();
    });
  }

  // 加载更多
  Future<Null> _loadMoreData() {
    return Future.delayed(Duration(seconds: 1), () {
      print("正在加载更多...");
      if (_pageSize >= totalSize) {
        //没有数据了
        isEnd = true;
        setState(() {});
        return;
      }
      _pageSize = _pageSize + 1;
      print('_pagesize$_pageSize');
      searchComments();
    });
  }

  // 手动调用刷新控件：初始化页面的时候
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  //分页查询该课程的评论，如果是触发下拉刷新的话，那么当前页数重置为1，每次请求固定请求6条数据，总是页数是总数目除以每次请求是数据加一
  searchComments() {
    Http.getData(
        '/comment/selectByMultiple',
        (data) {
          print(_pageSize);
          print(data);
          totalSize = data['count'] ~/ 6 + 1;
          for (var i = 0; i < data['data'].length; i++) {
            _dataSource.add(data['data'][i]);
          }
          setState(() {});
        },
        params: {'pageNum': _pageSize, 'pageSize': 6, 'cid': widget.cid},
        errorCallBack: (error) {
          print('error:${error}');
        });
  }

  @override
  void initState() {
    //初始化数据：显示下拉刷新控件 + 获取数据
    showRefreshLoading();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('4324234234234');
        _loadMoreData();
      }
    });
    super.initState();
  }

// 调用发送评论接口
  sendComman(String text) {
    print(widget.cid);
    var user = Global.user;
    print(user.userInfo.stuid);
    Http.postData(
        '/comment/insert',
        (data) {
          print(data);
          //重新刷新
          showRefreshLoading();
        },
        params: {
          'cid': widget.cid,
          'content': text,
          'stuid': user.userInfo.stuid
        },
        errorCallBack: (error) {
          print('error:${error}');
        });
  }
  replyComman(text,comId){
      var user = Global.user;
      print(user.userInfo.stuid);
      Http.postData(
        '/reply/insert',
        (data){
         print(data);
         showRefreshLoading();
        },
        params: {'comId':comId,'content':text,'stuid':user.userInfo.stuid},
        errorCallBack: (error){
          print('error:${error}');
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        RefreshIndicator(
          key: _refreshKey,
          onRefresh: _onRefresh,
          color: Theme.of(context).primaryColor, //定义上拉刷新circle组件的加载进度条颜色
          backgroundColor: Colors.white,
          child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              physics: new AlwaysScrollableScrollPhysics(),
              itemCount: _dataSource.isEmpty ? 1 : _dataSource.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return items(context, index);
              }),
        ),
        //评论输入框
        Padding(
          padding: const EdgeInsets.only(top: 460),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "骚年，说点什么吧！",
              hintStyle: TextStyle(
                color: Colors.red,
              ),
            ),
            onChanged: (value) {
              commonText = value;
            },
            //键盘回车，发送评论
            onSubmitted: (text) {
              print('submit $commonText');
              sendComman(commonText);
              Fluttertoast.showToast(
                  msg: "评论成功",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white);
            },
          ),
        )
      ],
    );
  }

  //!构建评论列表：这里的话：如果别人回复的话只显示三条回复，点击进入对应页面查看全部回复，这样不用嵌套listview
  Widget items(context, index) {
    if (_dataSource.isEmpty) {
      return Container(
        height: 270,
        alignment: Alignment.center,
        child: LoadResultInfo(
          info: '空空如也',
        ),
      );
    } else if (index == _dataSource.length) {
      return IntrinsicHeight(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (!isEnd)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: isEnd
                      ? Text('已经到底了...', style: TextStyle(fontSize: 16.0))
                      : Text('加载中...', style: TextStyle(fontSize: 16.0)),
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
        height: _dataSource[index]['list'].length == 0
            ? 110.0
            : _dataSource[index]['list'].length == 2 ? 180 : 220,
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
                      GestureDetector(
                        onTap: () {
                          showDialog<Null>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                title: new Text(
                                    '回复${_dataSource[index]['phone']}:'),
                                content: new SingleChildScrollView(
                                  child: new ListBody(
                                    children: <Widget>[
                                      TextField(
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          hintText: "骚年，说点什么吧！",
                                          hintStyle: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                        //键盘回车，发送评论
                                        onSubmitted: (text) {
                                          print('submit $text');
                                          replyComman(text,_dataSource[index]['comId']);
                                          Fluttertoast.showToast(
                                              msg: "回复成功",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIos: 1,
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white);
                                              Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  new FlatButton(
                                    child: new Text('确定'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          ).then((val) {
                            print(val);
                          });
                        },
                        child: Text(
                          _dataSource[index]['phone'] == Global.user.userInfo.phone? '我自己' :_dataSource[index]['phone'] ,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1.0),
                              fontSize: 16.0),
                        ),
                      ),

                      //显示评论根据是否用评论进行返回
                      Row(
                        children: <Widget>[
                          Text(
                            Utils.getTime(_dataSource[index]['comTime']),
                            style: TextStyle(
                                color: Color.fromRGBO(168, 168, 168, 1.0)),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _dataSource[index]['content'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
                          ),
                        ],
                      ),
                      //别人的回复：动态显示
                      getRecovery(_dataSource[index]['list'])
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  //动态显示回去评论；根据是否有评论,recoms是回复评论的数组
  Widget getRecovery(recoms) {
    //回复不为空
    if (recoms.length != 0) {
      //循环构建最多三个评论组件
      List<Widget> replyWidget = [];
      var replyLength = recoms.length>=3? 3 : recoms.length;
      for (var i = 0; i < replyLength; i++) {
        replyWidget.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                child: Text(
                  "${recoms[i]['stuid']}:",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0, 0),
                child: Text(
                  recoms[i]['content'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
            ],
          ),
        );
      }
      if (recoms.length>3) {
        replyWidget.add(Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Center(child: Text('查看更多回复',style: TextStyle(color: Colors.blue),),)
        ));
      }
      return Container(
        height: recoms.length == 2 ? 80.0 : recoms.length >= 3 ? 130.0 : 50.0,
        decoration: BoxDecoration(
            color: Color.fromRGBO(229, 229, 229, 1.0),
            borderRadius: BorderRadius.circular(3.0)),
        child: Column(
            //TODO:只显示三个人评论，最大占一行
            children: replyWidget),
      );
    } else {
      return Container();
    }
  }
}
