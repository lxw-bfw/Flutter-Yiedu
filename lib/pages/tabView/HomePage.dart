import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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

  //TODO:轮播需要的图image widget
  List<Widget> imageList = List();
  //需要的图片数据
  List<String> imgData = List();

  @override
  void initState() {
    //获取轮播图片数据
    imgData.add(
        'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2726034926,4129010873&fm=26&gp=0.jpg');
    imgData.add(
        'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3485348007,2192172119&fm=26&gp=0.jpg');
    imgData.add(
        'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2594792439,969125047&fm=26&gp=0.jpg');
    imgData.add(
        'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=190488632,3936347730&fm=26&gp=0.jpg');
    imageList
      ..add(Image.network(
        'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2726034926,4129010873&fm=26&gp=0.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3485348007,2192172119&fm=26&gp=0.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2594792439,969125047&fm=26&gp=0.jpg',
        fit: BoxFit.fill,
      ))
      ..add(Image.network(
        'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=190488632,3936347730&fm=26&gp=0.jpg',
        fit: BoxFit.fill,
      ));

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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return CourseList(id: 0,);
                                        }));
                                      },
                                      child: Goodsbox(
                                        imgsrc: 'images/course-bg1.jpg',
                                        heigth: 65.0,
                                        title: 'Java工程师',
                                        introduce: '综合就业排名第一名',
                                        opc: 0.6,
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
                                        print(0);
                                      },
                                      child: Goodsbox(
                                        imgsrc: 'images/course-bg2.png',
                                        heigth: 65.0,
                                        title: '前端工程师',
                                        introduce: '小白也可以学好',
                                        opc: 0.6,
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
                                        print(0);
                                      },
                                      child: Goodsbox(
                                        imgsrc: 'images/course-bg3.png',
                                        heigth: 65.0,
                                        title: 'Python工程师',
                                        introduce: '应用最广泛的语言',
                                        opc: 0.6,
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
                                          print(0);
                                        },
                                        child: Goodsbox(
                                          imgsrc: 'images/courser-bg6.png',
                                          heigth: 65.0,
                                          title: 'Android工程师',
                                          introduce: '移动市场份额第一',
                                          opc: 0.6,
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
                                          print(0);
                                        },
                                        child: Goodsbox(
                                          imgsrc: 'images/courser-bg7.png',
                                          heigth: 65.0,
                                          title: 'PHP攻城狮',
                                          introduce: 'Web开发首选语言',
                                          opc: 0.6,
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
                                        print(0);
                                      },
                                      child: GradientBox(
                                        heigth: 65.0,
                                        title: 'Java全栈',
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
                                        print(0);
                                      },
                                      child: GradientBox(
                                        heigth: 65.0,
                                        title: '大前端',
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
                                        print(0);
                                      },
                                      child: GradientBox(
                                        heigth: 65.0,
                                        title: 'Java架构师',
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return CourseDetail();
                                        }));
                                        print(0);
                                      },
                                      child: CourseBox(
                                        imgsrc: 'images/course2.jpg',
                                        title: '跟简七学理财',
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
                                        imgsrc: 'images/course1.jpg',
                                        title: '轻松手绘：用简笔画提升你的技巧',
                                        score: 3.5,
                                        studenNum: 10,
                                        price: 198.0,
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
                                          imgsrc: 'images/course3.png',
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
                                          imgsrc: 'images/course4.jpg',
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
                                //TODO:
                                print(0);
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
    await Future.delayed(Duration(seconds: 2), () {
      // _list = List.generate(15, (i) => "我是刷新出的数据${i}");
      print('触发下拉刷新');
      // setState(() {});
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
        onTap: (index) => print('点击了第$index'),
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
