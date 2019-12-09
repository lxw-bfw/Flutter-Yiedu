import 'package:flutter/material.dart';
import 'package:projectpractice/widget/RatingBar.dart';

class CourseDetail extends StatefulWidget {
  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: const Color(0xF2F6FCff)),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              margin: const EdgeInsets.only(top: 10.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
              height: 130.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
                    child: Text(
                      '跟简七一起学理财',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(9.0, 10.0, 0.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            RatingBar(
                              clickable: false,
                              size: 17.0,
                              color: Colors.green,
                              padding: 0.5,
                              value: 4.8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                '4.8分',
                                style: TextStyle(
                                    color: Color.fromRGBO(168, 168, 168, 1.0),
                                    fontSize: 15.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                '10人学过',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color.fromRGBO(168, 168, 168, 1.0),
                                    fontSize: 15.0),
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 3.0),
                          decoration: BoxDecoration(
                              border: new Border.all(
                                  color: Colors.blue, width: 1.0),
                              borderRadius: BorderRadius.circular(3.0) // 边色与边宽度
                              ),
                          child: Text(
                            '独家',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Color.fromRGBO(207, 207, 207, 1.0),
                    height: 5.0,
                    indent: 0.0,
                  ),
                  Text(
                    '学习中',
                    style: TextStyle(
                        color: Color.fromRGBO(224, 80, 45, 1.0),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            //
             Container(
                margin: const EdgeInsets.only(top: 15.0),
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 12.0),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '适用人群',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 0.0),
                      child: Text(
                        '零基础小白学理财，这门课就够了！',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Divider(
                      color: Color.fromRGBO(207, 207, 207, 1.0),
                      height: 2.0,
                      indent: 0.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 0.0),
                      child: Text(
                        '课程简介',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    //使用流式布局放置多行文本
                    Wrap(
                      children: <Widget>[
                        Text(
                          '这是课程简介' * 20,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
          ],
        ));
  }
}
