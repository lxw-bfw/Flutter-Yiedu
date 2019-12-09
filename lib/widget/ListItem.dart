import 'package:flutter/material.dart';

//封装的一个列表项组件
class ListItem extends StatelessWidget {

  ListItem(
      {Key key,this.height,this.LeftIconData,this.title,this.rightIconData}): super(key: key);

  final double height;
  final IconData LeftIconData;
  final String title;
  final IconData rightIconData;    

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(left: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Icon(
                  LeftIconData,
                  color: Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Color.fromRGBO(80, 80, 80, 1.0),
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    rightIconData,
                    size: 30.0,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
