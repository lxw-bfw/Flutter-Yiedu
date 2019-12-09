//进入修改信息页面
import 'package:flutter/material.dart';

class ChangeInfo extends StatefulWidget {
  ChangeInfo({this.id, this.info, this.vary});

  int id;
  String info;
  String vary;
  @override
  _ChangeInfoState createState() => _ChangeInfoState();
}

class _ChangeInfoState extends State<ChangeInfo> {
  //通过全局的key用来获取form表单组件
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  //修改的信息
  String info = '';

  //点击登录按钮
  void login() {
    //读取当前的form状态
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      print(info);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    info = widget.info;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                  onTap: () {
                    //调用save方法
                    login();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 16),
                    child: Text(
                      '保存',
                      style: TextStyle(
                          color: Color.fromRGBO(56, 56, 56, 1.0),
                          fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                widget.vary,
                style: TextStyle(
                    color: Color.fromRGBO(56, 56, 56, 1.0),
                    fontWeight: FontWeight.bold),
              ),
            )),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            child: Form(
              key: _formKey, //设置globalKey，用于后面获取FormState
              autovalidate: true, //开启自动校验,
              child: Column(
                children: <Widget>[
                  //信息
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(51, 177, 123, 1.0),
                        ),
                        labelText: widget.vary,
                        hintText: info,
                        //获得焦点输入框下划线设为绿色
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green))),
                    keyboardType: TextInputType.number, //弹出数字键盘
                    //校验手机号
                    validator: (v) {
                      return v.trim().length > 0 ? null : "${widget.vary}不能为空";
                    },
                    //当form表单调用保存方法sava回调函数
                    onSaved: (value) {
                      info = value;
                    },
                    //当输入内容发生改变的时候调用类似v-model绑定
                    onChanged: (value) {
                      info = value;
                    },
                  ),
                ],
              ),
            )));
  }
}
