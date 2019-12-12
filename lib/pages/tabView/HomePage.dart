import 'dart:math' as prefix0;

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:projectpractice/common/Http.dart';
import 'package:projectpractice/widget/Goodsbox.dart';
import 'package:projectpractice/widget/GradientBox.dart';
import 'package:projectpractice/widget/RatingBar.dart';
import 'package:projectpractice/widget/CourseBox.dart';
import 'package:projectpractice/pages/CourseList.dart';
import 'package:projectpractice/pages/course/CourseDetail.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// 界面状态还有样式的控制:首页:可以下拉刷新、轮播、
class _HomePageState extends State<HomePage> {
  //创建滚动监听控制器，赋值给可滚动的组件controle属性就可以监听滚动了
  ScrollController _scrollController = new ScrollController();
  GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  //TODO:轮播需要的图image widget，这里每一张轮播都对应一个课程，轮播图片使用课程里面的img
  List<Widget> imageList = List();
  //需要的图片数据
  List<String> imgData = List();

  //! 首页后去两个信息：精选一、首页推荐课程
  var varys1 = [];
  var course = [];

  @override
  void initState() {
    for (var i = 0; i < 8; i++) {
      varys1.add({'kindName': '获取中...'});
    }
    for (var i = 0; i < 4; i++) {
      course.add({
        'cname': '获取中...',
        'img': 'http://placehold.it/400x200?text=course...',
        'price': 1888.0
      });
    }
    //下拉刷新
    showRefreshLoading();
    //获取轮播图片数据
    imgData.add('http://placehold.it/400x200?text=course...');
    imgData.add('http://placehold.it/400x200?text=course...');
    imgData.add('http://placehold.it/400x200?text=course...');
    imgData.add('http://placehold.it/400x200?text=course...');
    

    super.initState();

    //*监听滚动加载，这里不需要用到
    // _scrollController.addListener(() {
    //   var position = _scrollController.position;
    //   // 小于50px时候，触发上拉加载
    //   if (position.maxScrollExtent - position.pixels < 50) {
    //     // _loadMore();
    //   }
    // });
    //*初始化listview列表数据这里是首页不需要
    // _generateData();
  }

  //随机获取8个课程二级类别
  getVarys() {
    Http.getData(
        '/kindInfo/getHigherLevel',
        (data) {
          //在count的范围之内随机获取到8个，如果不足8个的话就遍历count有些重复
          print(data['count']);
          var randomNum = []; //记录不同的随机数
          if (data['count'] >= 8) {
            for (var i = 0; i < 8; i++) {
              var num = prefix0.Random().nextInt(data['count']);
              if (randomNum.length != 0) {
                for (var j = 0; j < randomNum.length; j++) {
                  while (randomNum[j] == num) {
                    num = prefix0.Random().nextInt(data['count']);
                  }
                }
              }
              randomNum.add(num);
            }
            print(randomNum);
          } else {
            //如果是小于8个的话，我们从这里还是去8次随机数，只是有重复的
            for (var i = 0; i < 8; i++) {
              var num = prefix0.Random().nextInt(data['count']);
              randomNum.add(num);
            }
          }
          //把随机对用的数据放置进list里面再触发组件重新渲染。
          varys1 = [];
          for (var i = 0; i < randomNum.length; i++) {
            varys1.add(data['data'][randomNum[i]]);
          }
          setState(() {});
        },
        params: {'level': 3, 'pageNum': 1, 'pageSize': 1000},
        errorCallBack: (error) {
          print('error:$error');
        });
  }

  //获取推荐课程需要分页：换一批
  int pageNum = 1;
  int pageSize = 4;
  int totalPage = 1; //总页数,需要获取后台数据后进行渲染
  var carousIds = [];//记录轮播课程的课程id
  getRecommendCourse() {
    Http.getData(
        '/crouseInfo/selectAll',
        (data) {
          //分页总数
          totalPage = data['count'] ~/ 4;
          print(data);
          imgData = [];
          for (var i = 0; i < data['data'].length; i++) {
            if (data['data'][i]['img'] == null) {
              data['data'][i]['img'] =
                  'http://placehold.it/400x200?text=course...';
            } else {
              if (imgData.length < 4) {
                imgData.add(data['data'][i]['img']);
                carousIds.add(data['data'][i]['cid']);
              }
            }
          }
          //下面的推荐课程列表渲染
          course = data['data'];
          setState(() {});
        },
        params: {'pageNum': pageNum, 'pageSize': pageSize},
        errorCallBack: (error) {
          print('error:$error');
        });
  }

  @override
  Widget build(BuildContext context) {
    //这就是一个新的页面虽然不会覆盖状态栏，但是你可以根据自己的需要定制页面。
    return Scaffold(
        body: Container(
      //页面组件放置在占据全屏的带浅灰色的容器里面。
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: const Color(0xF2F6FCff)),
      child: RefreshIndicator(
        key: _refreshKey,
        color: Theme.of(context).primaryColor, //定义上拉刷新circle组件的加载进度条颜色
        backgroundColor: Colors.white, // 定义上拉刷新circle组件的背景颜色

        //!带下拉刷新上拉加载组件的child属性：必须是一个可以滚动的组件如listview，这里是首页布局，
        //! 不同于列表布局，列表布局一般是加载特别多的，且都是样式差不多的，但是这里首页有轮播、其他不同
        //! 的布局容器，但是没有涉及很多组件重复加载像列表那样，所以这里不使用listview这些基于Sliver的懒加载模型
        //!当然最好是使用了。我使用SingleChildScrollView
        //!性能是真的差啊，
        // child: ListView.builder(
        //   controller: _scrollController,
        //   itemCount: _list.length == 0 ? 0
        //       : isLoading ? _list.length + 1 : _list.length,
        //       itemBuilder: (context,index){
        //         return _getRow(context,index);
        //       },
        // ),
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //轮播控件
                  Container(
                      height: 210,
                      padding: EdgeInsets.all(17.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        //! 对于column由于其主轴是纵轴所以crossAxisAlignment对于它来说是水平方向。
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SwiperWidget(),
                          //活动通知
                          Container(
                            height: 20.0,
                            child: ListTile(
                              leading: Icon(
                                Icons.volume_up,
                                color: Colors.orangeAccent,
                              ),
                              contentPadding: EdgeInsets.all(0.0),
                              title: Text('新注册用户快来领取68元礼券>'),
                              trailing: Icon(Icons.more_horiz),
                              onTap: () {
                                //TODO:点击跳转到课程购买页面
                              },
                            ),
                          )
                        ],
                      )),
                  // 首页--展示推荐的课程类别
                  Container(
                    height: 210,
                    margin: EdgeInsets.only(top: 5.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 17.0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          leading: Text(
                            '精选类别一',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          title: Text(
                            '6个月，从零起步为工程师',
                            style: TextStyle(color: const Color(0x909399ff)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: EdgeInsets.only(right: 5.0),
                                    //实现背景图片(container1)上面有一层蒙版，其实就是使用flutter的相对定位布局：stack，里面的子组件默认是按照顺序覆盖
                                    //使用GestureDetector手势widget给其添加点击事件
                                    child: GestureDetector(
                                      onTap: () {
                                        // TODO:点击跳转到点击进入对应分类查询到课程列表页面
                                        //利用分类id获取课程
                                        print('分类id是${varys1[0]['kid']}');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CourseList(
                                            id: varys1[0]['kid'],
                                            cname:varys1[0]['kindName'],
                                          );
                                        }));
                                      },
                                      child: Goodsbox(
                                        imgsrc: 'images/course-bg1.jpg',
                                        heigth: 65.0,
                                        title: varys1[0]['kindName'],
                                        introduce: '综合就业排名第一名',
                                        opc: 0.6,
                                        imgType: 2,
                                      ),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    //实现背景图片(container1)上面有一层蒙版，其实就是使用flutter的相对定位布局：stack，里面的子组件默认是按照顺序覆盖
                                    padding: EdgeInsets.only(right: 5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // TODO:点击跳转到点击进入对应分类查询到课程列表页面
                                        print('分类id是${varys1[1]['kid']}');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CourseList(
                                            id: varys1[1]['kid'],
                                            cname:varys1[1]['kindName'],
                                          );
                                        }));
                                      },
                                      child: Goodsbox(
                                        imgsrc: 'images/course-bg2.png',
                                        heigth: 65.0,
                                        title: varys1[1]['kindName'],
                                        introduce: '小白也可以学好',
                                        opc: 0.6,
                                         imgType: 2,
                                      ),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    //实现背景图片(container1)上面有一层蒙版，其实就是使用flutter的相对定位布局：stack，里面的子组件默认是按照顺序覆盖
                                    padding: EdgeInsets.only(right: 0.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // TODO:点击跳转到点击进入对应分类查询到课程列表页面
                                        print('分类id是${varys1[2]['kid']}');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CourseList(
                                            id: varys1[2]['kid'],
                                            cname:varys1[2]['kindName'],
                                          );
                                        }));
                                      },
                                      child: Goodsbox(
                                        imgsrc: 'images/course-bg3.png',
                                        heigth: 65.0,
                                        title: varys1[2]['kindName'],
                                        introduce: '应用最广泛的语言',
                                        opc: 0.6,
                                         imgType: 2,
                                      ),
                                    )))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 5.0),
                                      //实现背景图片(container1)上面有一层蒙版，其实就是使用flutter的相对定位布局：stack，里面的子组件默认是按照顺序覆盖
                                      child: GestureDetector(
                                        onTap: () {
                                          // TODO:点击跳转到点击进入对应分类查询到课程列表页面
                                         print('分类id是${varys1[3]['kid']}');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CourseList(
                                            id: varys1[3]['kid'],
                                            cname:varys1[3]['kindName'],
                                          );
                                        }));
                                        },
                                        child: Goodsbox(
                                          imgsrc: 'images/courser-bg6.png',
                                          heigth: 65.0,
                                          title: varys1[3]['kindName'],
                                          introduce: '移动市场份额第一',
                                          opc: 0.6,
                                           imgType: 2,
                                        ),
                                      ))),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      //实现背景图片(container1)上面有一层蒙版，其实就是使用flutter的相对定位布局：stack，里面的子组件默认是按照顺序覆盖
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // TODO:点击跳转到点击进入对应分类查询到课程列表页面
                                          print('分类id是${varys1[4]['kid']}');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CourseList(
                                            id: varys1[4]['kid'],
                                            cname:varys1[4]['kindName'],
                                          );
                                        }));
                                        },
                                        child: Goodsbox(
                                          imgsrc: 'images/courser-bg7.png',
                                          heigth: 65.0,
                                          title: varys1[4]['kindName'],
                                          introduce: 'Web开发首选语言',
                                          opc: 0.6,
                                          imgType: 2,
                                        ),
                                      ))),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  //首页-推荐类别2
                  Container(
                    height: 135,
                    margin: EdgeInsets.only(top: 5.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 17.0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          leading: Text(
                            '精选类别二',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          title: Text(
                            '1年以上程序员首选',
                            style: TextStyle(color: const Color(0x909399ff)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: EdgeInsets.only(right: 5.0),
                                    //实现背景图片(container1)上面有一层蒙版，其实就是使用flutter的相对定位布局：stack，里面的子组件默认是按照顺序覆盖
                                    child: GestureDetector(
                                      onTap: () {
                                        //TODO:点击跳转到课程列表页面
                                        print(0);print('分类id是${varys1[5]['kid']}');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CourseList(
                                            id: varys1[5]['kid'],
                                            cname:varys1[5]['kindName'],
                                          );
                                        }));
                                      },
                                      child: GradientBox(
                                        heigth: 65.0,
                                        title: varys1[5]['kindName'],
                                        introduce: '从后端走向全栈',
                                        leftColor: Colors.lightBlueAccent,
                                        rightColor: Colors.blue,
                                      ),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    //实现背景图片(container1)上面有一层蒙版，其实就是使用flutter的相对定位布局：stack，里面的子组件默认是按照顺序覆盖
                                    padding: EdgeInsets.only(right: 5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        //TODO:点击跳转到课程列表页面
                                        print(0);print('分类id是${varys1[6]['kid']}');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CourseList(
                                            id: varys1[6]['kid'],
                                            cname:varys1[6]['kindName'],
                                          );
                                        }));
                                      },
                                      child: GradientBox(
                                        heigth: 65.0,
                                        title: varys1[6]['kindName'],
                                        introduce: '前端高级进阶',
                                        leftColor: Colors.orangeAccent,
                                        rightColor: Colors.deepOrange,
                                      ),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    //实现背景图片(container1)上面有一层蒙版，其实就是使用flutter的相对定位布局：stack，里面的子组件默认是按照顺序覆盖
                                    padding: EdgeInsets.only(right: 0.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        //TODO:点击跳转到课程列表页面
                                       print('分类id是${varys1[7]['kid']}');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CourseList(
                                            id: varys1[7]['kid'],
                                            cname:varys1[7]['kindName'],
                                          );
                                        }));
                                      },
                                      child: GradientBox(
                                        heigth: 65.0,
                                        title: varys1[7]['kindName'],
                                        introduce: '专家系统养成',
                                        leftColor: Colors.purpleAccent,
                                        rightColor: Colors.deepPurple,
                                      ),
                                    )))
                          ],
                        )
                      ],
                    ),
                  ),
                  //首页--推荐课程展示列表
                  Container(
                    height: 460,
                    margin: EdgeInsets.only(top: 5.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 17.0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(0.0),
                          leading: Text(
                            '精选好课',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          title: Text(
                            '优质课程,不容错过',
                            style: TextStyle(color: const Color(0x909399ff)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: EdgeInsets.only(right: 5.0),
                                    //课程简介布局；顶部图片 + 底部文字信息等
                                    child: GestureDetector(
                                      onTap: () {
                                        //TODO:点击进入课程购买--介绍页面
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CourseDetail();
                                        }));
                                        print(0);
                                      },
                                      child: CourseBox(
                                        imgsrc: course[0]['img'],
                                        title: course[0]['cname'],
                                        score: 4.5,
                                        studenNum: 10,
                                        price: course[0]['price'],
                                      ),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    //实现背景图片(container1)上面有一层蒙版，其实就是使用flutter的相对定位布局：stack，里面的子组件默认是按照顺序覆盖
                                    padding: EdgeInsets.only(right: 5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        //TODO:点击进入课程购买--介绍页面
                                        print(0);
                                      },
                                      child: CourseBox(
                                        imgsrc: course[1]['img'],
                                        title: course[1]['cname'],
                                        score: 3.5,
                                        studenNum: 10,
                                        price: course[1]['price'],
                                      ),
                                    ))),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 5.0),
                                      //课程简介布局；顶部图片 + 底部文字信息等
                                      child: GestureDetector(
                                        onTap: () {
                                          //TODO:点击进入课程购买--介绍页面
                                          print(0);
                                        },
                                        child: CourseBox(
                                          imgsrc:
                                              'http://placehold.it/400x200?text=course...',
                                          title: 'Java并发编程精讲',
                                          score: 4.5,
                                          studenNum: 10,
                                          price: 398.0,
                                        ),
                                      ))),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      //实现背景图片(container1)上面有一层蒙版，其实就是使用flutter的相对定位布局：stack，里面的子组件默认是按照顺序覆盖
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          //TODO:点击进入课程购买--介绍页面
                                          print(0);
                                        },
                                        child: CourseBox(
                                          imgsrc:
                                              'http://placehold.it/400x200?text=course...',
                                          title: 'Java数据结构与算法',
                                          score: 3.5,
                                          studenNum: 10,
                                          price: 198.0,
                                        ),
                                      ))),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                //TODO:换一批课程
                                if (pageNum < totalPage) {
                                  pageNum++;
                                } else {
                                  pageNum = 1;
                                }
                                getRecommendCourse();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.refresh,
                                    color: Color.fromRGBO(128, 128, 128, 1.0),
                                  ),
                                  Text(
                                    '换一批',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(128, 128, 128, 1.0),
                                        fontSize: 16.0),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        onRefresh: _onRefresh,
      ),
    )
// This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  @override
  void dispose() {
    print("RefreshListPage _dispose()");
    _scrollController?.dispose();
    super.dispose();
  }

  //TODO:触发下拉刷新，重新获取数据渲染
  Future<void> _onRefresh() async {
    print("RefreshListPage _onRefresh()");
    print('触发下拉刷新');
    pageNum = 1;
    getVarys();
    getRecommendCourse();
  }

  //页面inti的时候调用这个下拉刷新
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      _refreshKey.currentState.show().then((e) {});
      return true;
    });
  }

  // void _generateData() async {
  //   await Future.delayed(Duration(seconds: 2), () {
  //     print("RefreshListPage _generateData()");
  //     _list = List.generate(20, (i) => "我是初始化的数据${i}");
  //     setState(() {});
  //   });
  // }

  bool isLoading = false;

  // void _loadMore() async {
  //   print("RefreshListPage _loadMore()");
  //   if (!isLoading) {
  //     isLoading = true;
  //     setState(() {});
  //     Future.delayed(Duration(seconds: 3), () {
  //       print("RefreshListPage isLoading = ${isLoading}");
  //       isLoading = false;
  //       _list = List.from(_list);
  //       _list.addAll(List.generate(5, (index) => "上拉加载个数${index}"));
  //       setState(() {});
  //     });
  //   }
  // }

  // Widget _getRow(BuildContext context, int index) {
  //   if (index < _list.length) {
  //     return ListTile(
  //       title: Text(_list[index]),
  //     );
  //   }
  //   return _getMoreWidget();
  // }

  //返回一个widget组件--显示加载中...
  // Widget _getMoreWidget() {
  //   return Center(
  //     child: Padding(
  //       padding: EdgeInsets.all(10.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           SizedBox(
  //             width: 20,
  //             height: 20,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 4.0,
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
  //             child: Text('加载中...', style: TextStyle(fontSize: 16.0)),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //封装轮播控件类
  Widget SwiperWidget() {
    return Container(
      height: 140,
      //圆角效果
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black54, offset: Offset(0.0, 4.0), blurRadius: 4.0),
        ],
        borderRadius: BorderRadius.circular(8.0), //3像素圆角
      ),
      child: Swiper(
        itemCount: 4,
        itemBuilder: _swiperBuilder,
        //分页指示器
        pagination: SwiperPagination(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 10),
            builder: DotSwiperPaginationBuilder(
                color: Colors.white70,
                activeColor: Colors.redAccent,
                space: 2,
                activeSize: 15)),
        controller: SwiperController(),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        onTap: (index){
          print('课程id是${carousIds[index]}');
        }
      ),
    );
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    //对轮播的图片组件进行美化：圆角边框加阴影
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(imgData[index]), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
    );
  }
}
