import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:projectpractice/common/InfoNotify.dart';
import 'dart:math';
import 'package:projectpractice/pages/course/couseInfo/Chapter.dart';
import 'package:projectpractice/pages/course/couseInfo/CourseDetail.dart';
import 'package:projectpractice/pages/course/couseInfo/CourseComment.dart';
import 'package:provider/provider.dart';

//TODO:在视频无法播放的时候全屏模型的时候无法真正的全屏宽度，只能占用一部分。

class CourseVideo extends StatefulWidget {
  CourseVideo({this.url, this.vidoeInfo, this.cid});
  //课程于视频id，这里模拟视频url参数
  final String url; //课程第一节视频地址
  final String vidoeInfo; //该课程的所有视频信息
  final int cid;
  @override
  _CourseVideoState createState() => _CourseVideoState();
}

class _CourseVideoState extends State<CourseVideo> {
  final FijkPlayer player = FijkPlayer();
  int _selectIndex = 0;
  var videoInfoMap;

  @override
  void initState() {
    super.initState();
    print(widget.vidoeInfo);
    //视频信息转map
    videoInfoMap = json.decode(widget.vidoeInfo);
    print(videoInfoMap.length);
    //初始化换取课程、视频相关数据
    print(widget.url);
    var hostNmae = 'http://47.103.223.248:8080/YIedu/';
    player.setDataSource(hostNmae + widget.url, autoPlay: true);
  }

  VideoInfoProfider videoInfoProfider = new VideoInfoProfider();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VideoInfoProfider>(
      builder: (_) => videoInfoProfider,
      child: Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 230.0,
            child: FijkView(
                //!fijkview分为两个区域：容器view区一般是占慢宽度和外层父组件的高度，video显示区域可能会被裁剪导致只占部分区域
                player: player, //!通过控制fit参数可以控制视频在 FijkView 中的填充裁剪模式。
                color: Colors.white,
                fit: FijkFit(
                  aspectRatio:
                      double.infinity, //设置infinity使得视频区于fijkview区域宽高比一致
                ),
                //自定义显示ui界面//其中FijkPanelWidgetBuilder 返回的 Widget实际上会在组件树中作为一个stack
                panelBuilder: (FijkPlayer player, BuildContext context,
                    Size viewSize, Rect texturePos) {
                  return CustomFijkPanel(
                      player: player,
                      buildContext: context,
                      viewSize: viewSize,
                      texturePos: texturePos,
                      videoUrl: widget.url,
                      videoInfos: videoInfoMap);
                }),
          ),
          //!视频播放区域结束，底部内容切换tab开始
          /**
         *!由于两层嵌套column里面无法使用listveiw，所以视频底部的tab栏 + 带listview的子页面我打算放在这里的同一层column
         */
          //tab栏部分
          Container(
              height: 54.0,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 4.0)
              ]),
              //tab栏
              child: DefaultTabController(
                length: 3,
                child: Container(
                  child: TabBar(
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.black,
                    indicatorWeight: 2,
                    indicatorColor: Colors.red,
                    labelStyle: TextStyle(fontSize: 14),
                    tabs: <Widget>[
                      Tab(
                          text: '章节',
                          icon: GestureDetector(
                            onTap: () {
                              print('章节');
                              setState(() {
                                _selectIndex = 0;
                              });
                            },
                            child: Icon(
                              Icons.book,
                              size: 20.0,
                            ),
                          )),
                      Tab(
                          text: '详情',
                          icon: GestureDetector(
                            onTap: () {
                              print('详情');
                              setState(() {
                                _selectIndex = 1;
                              });
                            },
                            child: Icon(
                              Icons.book,
                              size: 20.0,
                            ),
                          )),
                      Tab(
                          text: '评论',
                          icon: GestureDetector(
                            onTap: () {
                              print('评论');
                              setState(() {
                                _selectIndex = 2;
                              });
                            },
                            child: Icon(
                              Icons.book,
                              size: 20.0,
                            ),
                          ))
                    ],
                  ),
                ),
              )),

          Expanded(child: showView())
        ],
      )),
    );
  }

  //!每次销毁页面的时候把视频销毁
  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  //根据点击不同的tab切换不同的tabview
  Widget showView() {
    if (_selectIndex == 0) {
      return Consumer<VideoInfoProfider>(builder: (_, videoModel, __) {
        return Chapter(
          id: 1,
          videoInfo: widget.vidoeInfo,
          changeVideo: (vurl, index) {
            print(videoModel.title);
            print('新的播放地址$vurl');
            print(videoInfoMap[index - 1]['title']);
            videoModel.changeTitle(videoInfoMap[index - 1]['title']);
            //更换新的视频播放
            //todo:
            var hostNmae = 'http://47.103.223.248:8080/YIedu/';
            player.reset().then((info) {
              player.setDataSource(hostNmae + vurl, autoPlay: true);
            }).catchError((err) {
              print('载入出错...');
            });
          },
        );
      });
    } else if (_selectIndex == 1) {
      return CourseDetail(
        cid: widget.cid,
      );
    } else {
      return CourseComment(
        cid: widget.cid,
      );
    }
  }
}

//自定义视频上面的ui--个性化UI
/**
 * @name: 
 * @description: 
 * @msg: 
 * @param {type} player 播放器 FijkPlayer 对象，播放逻辑控制需要它，通过它来实现ui的更新，viewSize对应 FijkView 的实际显示大小，
 * ************* texturePos FijkView 中实际视频显示的相对位置，这个相对位置可能超出 FijkView 的实际大小
 * @return: 
 */
class CustomFijkPanel extends StatefulWidget {
  final FijkPlayer player;
  final BuildContext buildContext;
  final Size viewSize;
  final Rect texturePos;
  final String videoUrl; //视频url
  var videoInfos; //所有视频信息
  final changeVideoPlay;

  CustomFijkPanel(
      {@required this.player,
      this.buildContext,
      this.viewSize,
      this.texturePos,
      this.videoUrl,
      this.videoInfos,
      this.changeVideoPlay});

  @override
  _CustomFijkPanelState createState() => _CustomFijkPanelState();
}

class _CustomFijkPanelState extends State<CustomFijkPanel> {
  FijkPlayer get player => widget.player;
  bool _playing = false;
  bool _isError = false; //出错处理，如果视频播放错误的话中间显示提示信息，重置视频状态。
  bool _isComplete = false; //播放完成标志，显示对应的ui：播放下一节课程
  bool _isUnLoad = false; //是否未初始化到播放状态
  bool _isBuffer = false; //是否正在缓冲
  String videoTime = '00:00'; //视频时长
  String curTime = '00:00';
  StreamSubscription _currentPosSubs;
  Duration _currentPos;
  double _playSpeed; //倍速设置
  bool _isScreen = false; //全屏判断，需要修改一下ui界面
  //!折中解决全屏ui界面无法响应更新问题：全屏后暂停视频，点击播放按钮进行手动设置状态
  double voiceNum = 45; //当前视频音量 0 - 100
  bool _isVoice = false; //是否显示音量控件

  //进度条相关属性:https://blog.csdn.net/mengks1987/article/details/85107866
  double _value = 0;
  int _dollars = 40;
  double slideMaxNum = 0; //进度条的最大进度

  //课程视频播放相关
  int currentVideoIndex = 0; //当前播放视频的索引

  //是否使用provide进行状态的更新，由于全屏模式下自定义视频播放ui重新刷新，报找不到顶层组件的widget provider
  bool isUserProvider = true;

  @override
  void initState() {
    print('看看我有没有重新刷新');
    super.initState();
    widget.player.addListener(_playerValueChanged);
    //使用api的stream方法，来监听视频频繁变化的信息：播放位置，缓冲状况
    _currentPos = widget.player.currentPos;
    try {
      _currentPosSubs = widget.player.onCurrentPosUpdate.listen((v) {
        //注意当前视频状态
        setState(() {
          //更新显示当前播放到的时间
          var timeStr = v.toString();
          curTime = timeStr[0] == '0'
              ? timeStr.substring(2, 7)
              : timeStr.substring(0, 7);
          //更新显示当前进度条的位置
          if (double.parse(v.inSeconds.toString()) >= 0 &&
              double.parse(v.inSeconds.toString()) <= slideMaxNum) {
            _value = double.parse(v.inSeconds.toString());
          }
        });
      });
    } catch (e) {}
  }

/**
 * !监听视频部分状态信息的改变，根据状态来切换对应的ui，比如视频载入前等待进度条等等待。同时获取视频相关信息——仅在这里监听变化不频繁的信息，其实通过player入口对象可以获取我们需要的全部信息了。
 * started	媒体（视频、音频）正在播放中。
   paused	媒体（视频、音频）播放暂停。
   completed	媒体（视频、音频）播放完成。 可重新从头开始播放。
   stopped	播放器各种线程占用资源都已经释放。 音频设备关闭。
   end	播放器中所有需要手动释放的内存都释放完成。
处于此状态的播放器只能等待垃圾回收进行内存释放。
   error	播放器出现错误。
 */
  void _playerValueChanged() {
    FijkValue value = player.value;
    print('播放状态_播放状态_播放状态' + value.state.toString());
    //!palyer对象value对象里面的state保存了视频播放状态：初始化，开始，完成等，状态改变就会回调这里。

    //获取一些我们需要的信息//TODO:设置视频时长还有进度条大小：进度条的值设置为以秒为单位——暂时
    if (value.prepared) {
      print('视频时长时长---${value.duration}');
      print('视频时长时间戳--${value.duration.inSeconds}');
      var timeStr = value.duration.toString();

      setState(() {
        //显示更新播放时长
        videoTime = timeStr[0] == '0'
            ? timeStr.substring(2, 7)
            : timeStr.substring(0, 7);
        //显示进度条max大小
        slideMaxNum = double.parse(value.duration.inSeconds.toString());
      });
    }
    //根据不同状态切换ui
    switch (value.state) {
      case FijkState.started:
        setState(() {
          _playing = true;
          _isError = false;
          _isComplete = false;
          _isUnLoad = false;
        });
        break;
      case FijkState.completed:
        setState(() {
          _playing = false;
          _isError = false;
          _isComplete = true;
          _isUnLoad = false;
        });
        break;
      case FijkState.error:
        //重置视频reset
        setState(() {
          print('错误错误info${FijkState.error}');
          _playing = false;
          _isError = true;
          _isComplete = false;
          _isUnLoad = false;
        });
        break;
      case FijkState.paused:
        //重置视频reset
        setState(() {
          isUserProvider = true;
          _playing = false;
          _isError = false;
          _isComplete = false;
          _isUnLoad = false;
        });
        break;
      default:
        setState(() {
          _playing = false;
          _isError = false;
          _isComplete = false;
          //生命周期中，只有start算得上是真正的开始播放，其他的处理error、pause、stop、complete都需要进行的一个等待
          //参考播放状态：https://fijkplayer.befovy.com/docs/zh/fijkstate.html#%E5%8F%AF%E6%92%AD%E6%94%BE%E7%8A%B6%E6%80%81
          if (value.state != FijkState.stopped ||
              value.state != FijkState.end ||
              value.state != FijkState.paused) {
            //显示一个加载等待
            _isUnLoad = true;
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
      print(flutterErrorDetails.toString());
      return Center(
        child: Text(
          "视频播放中",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
        ),
      );
    };
    // texturePos 可能超出 viewSize 大小，所以先进行大小约束。
    Rect rect = Rect.fromLTRB(
        max(0.0, widget.texturePos.left), //视频相对FijkView位置左边
        max(0.0, widget.texturePos.top), //视频相对FijkView位置上边
        min(widget.viewSize.width, widget.texturePos.right),
        min(widget.viewSize.height, widget.texturePos.bottom));

    return Positioned.fromRect(
      rect: rect,
      //TODO:手势事件：去掉定位好了可以布局了,使用GestureDetector监听手势变化：双击，滑动
      child: Container(
          width: double.infinity,
          height: 230.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  //视频底部控件父层。根据全屏和非全屏控制局部ui widget,使用三元表达式
                  Container(
                      width: double.infinity,
                      height: _isScreen ? 370.0 : 230.0,
                      alignment: Alignment.bottomLeft,
                      //视频底部控件
                      child: Container(
                        width: double.infinity,
                        height: 40.0,
                        decoration:
                            BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          //底部播放控制按钮，进度条，全屏播放按钮
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(
                                  _playing ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  _playing
                                      ? widget.player.pause()
                                      : widget.player.start();
                                  setState(() {
                                    print('${player.value.fullScreen}---播放模式');
                                    if (!player.value.fullScreen) {
                                      _isScreen = false;
                                      isUserProvider = true;
                                    } else {
                                      _isScreen = true;
                                      isUserProvider = false;
                                    }
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                curTime,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                margin: const EdgeInsets.only(top: 0.0),
                                // width: _isScreen ? 520.0 : 220.0,
                                child: Slider(
                                  value: _value, //!表示当前进度条的处于的进度位置，单位是秒
                                  min: 0,
                                  max: slideMaxNum, //最大值，根据视频的时长而定
                                  onChanged: (newValue) {
                                    //TODO:用户手动改变视频播放进度
                                    setState(() {
                                      _value = newValue;
                                    });
                                    //拖动进度条，改变视频进度，只能在视频播放的情况下调用
                                    if (widget.player.value.state ==
                                            FijkState.started ||
                                        widget.player.value.state ==
                                            FijkState.prepared ||
                                        widget.player.value.state ==
                                            FijkState.paused ||
                                        widget.player.value.state ==
                                            FijkState.completed) {
                                      int position =
                                          newValue.toInt(); //去掉小数转int
                                      widget.player.seekTo(position * 1000);
                                    }
                                  },
                                  onChangeStart: (startValue) {
                                    //进度条开始
                                  },
                                  onChangeEnd: (endValue) {
                                    //进度条结束
                                  },
                                  label: '$_value dollars',
                                  semanticFormatterCallback: (newValue) {
                                    return '${newValue.round()} dollars';
                                  },
                                  activeColor: Color.fromRGBO(206, 14, 14, 1.0),
                                  inactiveColor:
                                      Color.fromRGBO(244, 244, 244, 0.5),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                videoTime,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(
                                  _isScreen
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (_isScreen) {
                                    //退出全屏
                                    player.pause();
                                    widget.player.exitFullScreen();
                                  } else {
                                    //进入全屏
                                    setState(() {
                                      isUserProvider = false;
                                    });
                                    player.pause();
                                    player.enterFullScreen();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )),

                  //顶部导航栏
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 35.0, horizontal: 0.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                    size: 35.0,
                                  ),
                                  onPressed: () {
                                    //路由返回
                                    Navigator.pop(context);
                                  },
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 0.0),
                                    child: isUserProvider
                                        ? Consumer<VideoInfoProfider>(
                                            builder: (_, videoModel, __) {
                                            return Text(
                                              widget.videoInfos.length == 0
                                                  ? '暂无视频'
                                                  : videoModel.title == '视频状态管理'
                                                      ? widget.videoInfos[
                                                              currentVideoIndex]
                                                          ['title']
                                                      : videoModel.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0),
                                            );
                                          })
                                        : Text(
                                            '全屏播放中',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0),
                                          )),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                                alignment: Alignment.topRight,
                                padding: const EdgeInsets.only(right: 5.0),
                                //弹出菜单控件
                                child: new PopupMenuButton<String>(
                                    onSelected: (String value) {
                                      setState(() {
                                        _playSpeed = double.parse(value);
                                      });
                                      print(_playSpeed);
                                      widget.player.setSpeed(_playSpeed);
                                    },
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuItem<String>>[
                                          new PopupMenuItem<String>(
                                              enabled: false,
                                              value: '0',
                                              child: new Text('播放倍速选择')),
                                          new PopupMenuItem<String>(
                                              value: '0.75',
                                              child: new Text('0.75')),
                                          new PopupMenuItem<String>(
                                              value: '1.0',
                                              child: new Text('1.0')),
                                          new PopupMenuItem<String>(
                                              value: '1.25',
                                              child: new Text('1.25')),
                                          new PopupMenuItem<String>(
                                              value: '1.5',
                                              child: new Text('1.5')),
                                          new PopupMenuItem<String>(
                                              value: '1.75',
                                              child: new Text('1.75')),
                                          new PopupMenuItem<String>(
                                              value: '2.0',
                                              child: new Text('2.0')),
                                        ])),
                          )
                        ],
                      )),
                  GestureDetector(
                    onDoubleTap: () {
                      _playing ? widget.player.pause() : widget.player.start();
                    },
                    onPanDown: (DragDownDetails e) {
                      //打印手指按下的位置(相对于屏幕)：此时
                      print("用户手指按下：${e.globalPosition}");
                    },
                    //手指滑动时会触发此回调
                    onPanUpdate: (DragUpdateDetails e) {
                      //用户手指滑动时，更新偏移，重新构建
                      //手指滑动的精确度不好控制，我这里把超过100转为100显示和小于0都转为0显示
                      // 显示是这样的，同样的音量设置也使用voiceNum这个值为准。
                      _isVoice = true;
                      if (voiceNum < 100 || voiceNum > 0) {
                        //向上
                        if (e.delta.dy <= 0) {
                          var num = voiceNum - 2 * e.delta.dy;
                          num = num > 100 ? 100 : num;
                          voiceNum = double.parse(num.round().toString());
                        } else {
                          var num = voiceNum - 2 * e.delta.dy;
                          num = num < 0 ? 0 : num;
                          voiceNum = double.parse(num.round().toString());
                        }
                      }
                      //把vouceNum设置在 0 - 1.0这范围。
                      player.setVolume(voiceNum * 0.01);
                      setState(() {
                        //出现音量提示
                        //由于这里面向上滑动的时候打印的y值是负数，向下的时候是正数，所以我们取个反
                        // 当前音量 + step *  -e.delta.dy
                        // print(-e.delta.dy);
                        // _top += e.delta.dy;
                      });
                    },
                    onPanEnd: (DragEndDetails e) {
                      //打印滑动结束时在x、y轴上的速度
                      print(e.velocity);
                      _isVoice = false;
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 70.0),
                      width: double.infinity,
                      height: 130.0,
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(0, 0, 0, .0)),
                    ),
                  ),
                  //音量提示
                  showVoice(),

                  //视频状态消息提示：播放出错、正在缓冲，播放完毕显示播放下一节按钮
                  //根据不同的播放状态显示不的ui
                  showPlayInfo(),
                  //用于监听手势的布局
                ],
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.removeListener(_playerValueChanged);
    _currentPosSubs?.cancel();
  }

  // 音量控件
  Widget showVoice() {
    if (_isVoice) {
      return Container(
        width: 140.0,
        height: 60.0,
        margin: const EdgeInsets.fromLTRB(100.0, 100.0, 0.0, 0.0),
        padding: const EdgeInsets.only(left: 10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, .5),
            borderRadius: BorderRadius.circular(6.0)),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.volume_up,
              color: Colors.white,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
              child: Text(
                '当前音量$voiceNum',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showPlayInfo() {
    //正在缓冲
    if (_isBuffer) {
      return Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 85.0, horizontal: 160.0),
        child: Column(
          children: <Widget>[
            //加载进度条
            new CircularProgressIndicator(
              strokeWidth: 4.0,
              // backgroundColor: Colors.greenAccent,
              // value: 0.2,
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(206, 14, 14, 1.0)),
            ),
            Text(
              '正在缓冲...',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      );
    } else if (_isError) {
      return Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 100.0),
        padding: const EdgeInsets.only(left: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '抱歉，播放出了意外',
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.red,
                size: 38.0,
              ),
              onPressed: () {
                //TODO:重新播放
                //重置问题：重置回idle、或者是 initialized、 prepared、 paused、 completed、 stopped、 end、error。不会自动开始播放需要手动调用api
                //!且idle不能直接start
                //reset重新回退到为载入视频资源状态
                player.reset().then((info) {
                  //重新载入数据后自动播放
                  // print(info);
                  var hostNmae = 'http://47.103.223.248:8080/YIedu/';
                  player.setDataSource(hostNmae + widget.videoUrl,
                      autoPlay: true);
                }).catchError((err) {
                  print('载入出错...');
                });
              },
            )
          ],
        ),
      );
    } else if (_isComplete) {
      //播放完毕
      return Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 100.0),
        padding: const EdgeInsets.only(left: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '视频已经播放完毕',
              style: TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //重新播放播放
                    player.start();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    //TODO:播放下一节
                    //  player.start();
                  },
                ),
              ],
            )
          ],
        ),
      );
    } else if (_isUnLoad) {
      //显示初始化等待视频载入
      return Container(
        height: 230,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //加载进度条
            new CircularProgressIndicator(
              strokeWidth: 4.0,
              // backgroundColor: Colors.greenAccent,
              // value: 0.2,
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(206, 14, 14, 1.0)),
            ),
            Text(
              '正在载入视频...',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      );
    } else {
      //空组件
      return Container();
    }
  }
}
