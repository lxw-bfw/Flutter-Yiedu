import 'package:flutter/material.dart';
import 'package:projectpractice/widget/Goodsbox.dart';
import 'package:projectpractice/widget/RatingBar.dart';
import 'package:projectpractice/common/InfoNotify.dart';
import 'package:provider/provider.dart';



class RecentLearnig extends StatefulWidget {
  @override
  _RecentLearnigState createState() => _RecentLearnigState();
}

class _RecentLearnigState extends State<RecentLearnig> {
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
//创建一个当前页面需要provider管理状态的实体类
CheceBox checeBox = new CheceBox();
  @override
  Widget build(BuildContext context) {
    //  var checkBox = Provider.of<CheceBox>(context);
    //!在根节点订阅我们对应的provider 实体类
    //!使用的时候如果只想要更新的地方进行刷新，不想更新后触发整个页面widget build就使用consumer方式包裹需要更新状态的组件。
    return ChangeNotifierProvider<CheceBox>(
      builder: (_) => checeBox,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              '最近学习',
              style: TextStyle(
                  color: Color.fromRGBO(56, 56, 56, 1.0),
                  fontWeight: FontWeight.bold),
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 5.0, 10.0, 0),
                child: GestureDetector(onTap: () {
                  //点击编辑按钮改变是否显示复选框按钮的状态
                }, child: Consumer<CheceBox>(
                  builder: (_, checkModel, __) {
                    return GestureDetector(
                        onTap: () {
                          print(checkModel.isShowDelete);
                          if (checkModel.isShowDelete) {
                            checkModel.toggleShow(false);
                          } else {
                            checkModel.toggleShow(true);
                          }
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              checkModel.isShowDelete ? '取消' : '编辑',
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1.0),
                                  fontSize: 16.0),
                            ),
                            if(checkModel.isShowDelete) IconButton(icon: Icon(Icons.remove),color:Colors.red,onPressed: (){
                               //删除选中的课程
                               print(checkModel.deleteIds);
                            },)
                          ],
                        ));
                  },
                ))),
          ],
        ),
        body: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _onRefresh,
          color: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          child: ListView.builder(
            physics: new AlwaysScrollableScrollPhysics(),
            itemCount: _dataSource.isEmpty? 0:_dataSource.length +1,
            itemBuilder: (BuildContext context, int index) {
              return Items(
                context: context,
                index: index,
                datas: _dataSource,
              );
            },
          ),
        ),
      ),
    );
  }
  //  @override
  //  void dispose() {
  //   // TODO: implement dispose
  //   checeBox = null;
  //   super.dispose();
  // }
}

//由于item有自己的状态所以通过一个带状态的widget，
//跨组件的状态传递：isShowdelet。还有选中的哪些item的id
//!使用provider来定义管理这些
class Items extends StatefulWidget {
  Items({this.context, this.index,this.datas});
  final BuildContext context;
  final int index;
  final List<String> datas;

  @override
  _itemsState createState() => _itemsState();
}

class _itemsState extends State<Items> {
  bool check = false;

  @override
  Widget build(BuildContext context) {
    if (widget.index == widget.datas.length) {
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
    //课程列表
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                child: Icon(
                  Icons.timer,
                  color: Color.fromRGBO(172, 170, 170, 1.0),
                ),
              ),
              Text(
                '11月29日',
                style: TextStyle(
                    color: Color.fromRGBO(172, 170, 170, 1.0), fontSize: 16),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  border: new Border(
                      left: BorderSide(
                          width: 2.0,
                          color: Color.fromRGBO(172, 170, 170, 1.0)))),
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
              height: 90.0,
              child: Row(
                children: <Widget>[
                  //如果点击编辑按钮就在这里显示一个复选框
                  //这里通过provider该管理是否要显示
                  //局部小空间进行更新
                  Consumer<CheceBox>(
                    builder: (_, chece, __) {
                      if (chece.isShowDelete) {
                        return new Checkbox(
                          value: check,
                          activeColor: Colors.blue,
                          onChanged: (bool val) {
                            // val 是布尔值
                            setState(() {
                              check = val;
                            });
                            //
                            if (val) {
                              chece.deleteIds.add(widget.index);
                              chece.changeDeleteIds(chece.deleteIds);
                            } else {
                              //删除当前index
                              chece.deleteIds.remove(widget.index);
                              chece.changeDeleteIds(chece.deleteIds);
                            }
                          },
                        );
                      } else {
                        return Text('');
                      }
                    },
                  ),
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
                              'flutter开发第一步-Dart通用性编程',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1.0),
                                  fontSize: 16.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '学习至7-2 继承',
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(168, 168, 168, 1.0)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
