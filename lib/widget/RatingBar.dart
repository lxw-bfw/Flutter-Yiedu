import 'package:flutter/material.dart';

typedef void OnValueChanged(double value);

/**
 * 自定义星星评分控件
 */
class RatingBar extends StatefulWidget {

  //星星大小
  final double size;
  //星星间距
  final double padding;
  //星星改变事件回调
  final OnValueChanged onValueChangedCallBack;
  //值
  double value;
  //是否可点击
  final bool clickable;
  //颜色
  final Color color;

  // 获取键
  GlobalKey<RatingBarState> getKey() {
    return this.key;
  }

  @override
  createState() => RatingBarState();

  RatingBar({
    GlobalKey<RatingBarState> key,
    this.padding = 0.0,
    this.onValueChangedCallBack,
    this.value = 0.0,
    this.clickable = false,
    this.size = 20,
    this.color = Colors.yellow}) :super(key: key);
}

class RatingBarState extends State<RatingBar> {
  @override
  Widget build(BuildContext context) {
    return widget.clickable ? _getClickRatingBar() : _getRatingBar(
        widget.value);
  }

  /**
   * 不可点击的星星评分条
   */
  _getRatingBar(double value) {
    if (value >= 5) {
      value = value % 5;
      if (value == 0) value = 5;
    }
    double step = 0.5;
    double start = 0;
    double size = widget.size;
    double padding = widget.padding;
    Color color = widget.color;
    if (value > start && value < start + step) {
      return new Row(
        children: <Widget>[
          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
        ],
      );
    }
    else if (value >= start + step && value < start + 2 * step) {
      return new Row(
        children: <Widget>[
          Icon(Icons.star_half, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
        ],
      );
    }
    else if (value >= start + 2 * step && value < start + 3 * step) {
      return new Row(
        children: <Widget>[
          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
        ],
      );
    }
    else if (value >= 3 * step && value < start + 4 * step) {
      return new Row(
        children: <Widget>[
          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_half, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
        ],
      );
    }
    else if (value >= 4 * step && value < start + 5 * step) {
      return new Row(
        children: <Widget>[
          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
        ],
      );
    }
    else if (value >= 5 * step && value < start + 6 * step) {
      return new Row(
        children: <Widget>[
          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_half, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
        ],
      );
    }
    else if (value >= 6 * step && value < start + 7 * step) {
      return new Row(
        children: <Widget>[
          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
        ],
      );
    }
    else if (value >= 7 * step && value < start + 8 * step) {
      return new Row(
        children: <Widget>[
          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_half, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
        ],
      );
    }
    else if (value >= 8 * step && value < start + 9 * step) {
      return new Row(
        children: <Widget>[
          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_border, color: color, size: size,),
        ],
      );
    }
    else if (value >= 9 * step && value < start + 10 * step) {
      return new Row(
        children: <Widget>[
          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star_half, color: color, size: size,),
        ],
      );
    }
    else {
      return new Row(
        children: <Widget>[
          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
          Padding(padding: EdgeInsets.only(right: padding),),

          Icon(Icons.star, color: color, size: size,),
        ],
      );
    }
  }

  /**
   * 可点击的星星评分条
   */
  _getClickRatingBar() {
    double size = widget.size;
    double padding = widget.padding;
    Color color = widget.color;
    bool isClick = widget.clickable;
    var realValue = widget.value % 5;
    if (widget.value >= 5 && realValue == 0) {
      realValue = 5;
    }
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new GestureDetector(
          child: Icon(
              realValue >= 1 ? Icons.star : Icons.star_border, color: color,
              size: size),
          onTap: !isClick ? null : () {
            double value = realValue >= 1 ? 0 : 1;
            setState(() {
              widget.value = value;
            });
            if (widget.onValueChangedCallBack != null) {
              widget.onValueChangedCallBack(value);
            }
          },
        ),
        Padding(padding: EdgeInsets.only(right: padding)),

        new GestureDetector(
          child: Icon(
              realValue >= 2 ? Icons.star : Icons.star_border, color: color,
              size: size),
          onTap: !isClick ? null : () {
            double value = realValue >= 2 ? 0 : 2;
            setState(() {
              widget.value = value;
            });
            if (widget.onValueChangedCallBack != null) {
              widget.onValueChangedCallBack(value);
            }
          },
        ),
        Padding(padding: EdgeInsets.only(right: padding)),

        new GestureDetector(
          child: Icon(
              realValue >= 3 ? Icons.star : Icons.star_border, color: color,
              size: size),
          onTap: !isClick ? null : () {
            double value = realValue >= 3 ? 0 : 3;
            setState(() {
              widget.value = value;
            });
            if (widget.onValueChangedCallBack != null) {
              widget.onValueChangedCallBack(value);
            }
          },
        ),
        Padding(padding: EdgeInsets.only(right: padding)),

        new GestureDetector(
          child: Icon(
              widget.value >= 4 ? Icons.star : Icons.star_border, color: color,
              size: size),
          onTap: !isClick ? null : () {
            double value = realValue >= 4 ? 0 : 4;
            setState(() {
              widget.value = value;
            });
            if (widget.onValueChangedCallBack != null) {
              widget.onValueChangedCallBack(value);
            }
          },
        ),
        Padding(padding: EdgeInsets.only(right: padding)),

        new GestureDetector(
          child: Icon(
              realValue >= 5 ? Icons.star : Icons.star_border, color: color,
              size: size),
          onTap: !isClick ? null : () {
            double value = realValue >= 5 ? 0 : 5;
            setState(() {
              widget.value = value;
            });
            if (widget.onValueChangedCallBack != null) {
              widget.onValueChangedCallBack(value);
            }
          },
        ),
      ],
    );
  }
}