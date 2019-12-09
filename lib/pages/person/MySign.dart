import 'package:flutter/material.dart';
import 'package:projectpractice/pages/course/RecentLearning.dart';
import 'package:projectpractice/pages/person/DetailSign.dart';
import 'package:projectpractice/pages/person/SignExchange.dart';


class MySign extends StatefulWidget {
  @override
  _MySignState createState() => _MySignState();
}

class _MySignState extends State<MySign> {
  var _tabs = <String>[
    "积分明细",
    "积分兑换",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length, // This is the number of tabs.
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: SliverAppBar(
                  leading: new IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text('我的积分'),
                  centerTitle: false,
                  pinned: true,
                  floating: false,
                  snap: false,
                  primary: true,
                  expandedHeight: 230.0,
                  elevation: 10,
                  //是否显示阴影，直接取值innerBoxIsScrolled，展开不显示阴影，合并后会显示
                  forceElevated: innerBoxIsScrolled,

                  actions: <Widget>[
                    new IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        print("更多");
                      },
                    ),
                  ],

                  flexibleSpace: new FlexibleSpaceBar(
                    background: Image.asset("images/bg4.jpg", fit: BoxFit.fill),
                  ),

                  bottom: TabBar(
                    tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.white,
                    unselectedLabelStyle: TextStyle(fontSize: 17),
                    labelStyle: TextStyle(fontSize: 17),
                    indicatorColor: Colors.red,
                    indicatorWeight: 5,
                    isScrollable: true,
                  ),
                ),
              ),
            ];
          },
          body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: TabBarView(
              // These are the contents of the tab views, below the tabs.
              //TODO:点击切换不同
              children: <Widget>[
                DetailSign(),
                SignExchange()
              ],
            ),
          )),
    );
  }
}

