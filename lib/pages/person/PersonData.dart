import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectpractice/common/InfoNotify.dart';
import 'dart:io';
import 'package:projectpractice/pages/person/ChangeInfo.dart';
import 'package:projectpractice/pages/login/BindPhone.dart';
import 'package:provider/provider.dart';

class PersonData extends StatefulWidget {
  @override
  _PersonDataState createState() => _PersonDataState();
}

class _PersonDataState extends State<PersonData> {
  //选择图片上传——图片文件数组
  File _image;

  //定义个人列表信息
  List<PersonInfno> lists = [];

  //工具类：时间戳转时间格式,参数：毫秒
  getTime(val) { 
    return DateTime.fromMicrosecondsSinceEpoch(val).toString().substring(0,10);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    //个人相关信息渲染，从持久化信息中获取
    lists = [
      new PersonInfno(
          left1: Text(
            '头像',
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          right2: _image == null
              ? new ClipOval(
                  child: Image.asset(
                  'images/header1.jpeg',
                  width: 55.0,
                  height: 55.0,
                  fit: BoxFit.fill,
                ))
              : new ClipOval(
                  child: Image.file(
                    _image,
                    fit: BoxFit.fill,
                    width: 55,
                    height: 55,
                  ),
                ),
          rIcon: Icon(
            Icons.chevron_right,
            size: 34,
          )),
      new PersonInfno(
          left1: Text(
            '昵称',
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          right2: Text(
            userModel.user.userInfo.petname == null
                ? '未设置'
                : userModel.user.userInfo.petname,
            style: TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
          rIcon: Icon(
            Icons.chevron_right,
            size: 34,
          )),
      new PersonInfno(
          left1: Text(
            '性别',
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          right2: Text(
            userModel.user.userInfo.stusex == null
                ? '未设置'
                : userModel.user.userInfo.stusex,
            style: TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
          rIcon: Icon(
            Icons.chevron_right,
            size: 34,
          )),
      new PersonInfno(
          left1: Text(
            '生日',
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          right2: Text(
            userModel.user.userInfo.birthday == null
                ? '未设置'
                : getTime(userModel.user.userInfo.birthday),
            style: TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
          rIcon: Icon(
            Icons.chevron_right,
            size: 34,
          )),
      new PersonInfno(
          left1: Text(
            '手机号',
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          right2: Text(
            '去绑定',
            style: TextStyle(color: Colors.grey, fontSize: 16.0),
          ),
          rIcon: Icon(
            Icons.chevron_right,
            size: 34,
          ))
    ];
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              '个人信息',
              style: TextStyle(
                  color: Color.fromRGBO(56, 56, 56, 1.0),
                  fontWeight: FontWeight.bold),
            ),
          )),
      body: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (BuildContext context, int index) {
          return items(context, index);
        },
      ),
    );
  }

  Widget items(context, index) {
    if (index == 0) {
      return GestureDetector(
        onTap: () {
          //头像上传，点击底部弹出选择窗口
          if (index == 0) {
            showDemoActionSheet(
              context: context,
              child: CupertinoActionSheet(
                title: const Text('选中图片'),
                //message: const Text('Please select the best mode from the options below.'),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: const Text('相册获取'),
                    onPressed: () {
                      Navigator.pop(context, 'Gallery');
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('拍照获取'),
                    onPressed: () {
                      Navigator.pop(context, 'Camera');
                    },
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text('取消'),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                ),
              ),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(flex: 1, child: lists[index].left1),
              Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _image == null
                          ? new ClipOval(
                              child: Image.asset(
                              'images/header1.jpeg',
                              width: 55.0,
                              height: 55.0,
                              fit: BoxFit.fill,
                            ))
                          : new ClipOval(
                              child: Image.file(
                                _image,
                                fit: BoxFit.fill,
                                width: 55,
                                height: 55,
                              ),
                            ),
                      lists[index].rIcon
                    ],
                  ))
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
        UserModel userModel = Provider.of<UserModel>(context);
         //!点击对应的信息进入编辑修改
          var datas = ['', '', 1999, '去绑定'];
          if (userModel.user.userInfo.petname!=null) {
            datas[0] = userModel.user.userInfo.petname;
          }
          if (userModel.user.userInfo.stusex!=null) {
            datas[1] = userModel.user.userInfo.stusex;
          }
          if (userModel.user.userInfo.birthday!=null) {
            datas[2] = userModel.user.userInfo.birthday.toString();
          }
          var vary = ['修改昵称', '修改性别', '修改生日', '绑定手机号'];
          if (datas[index - 1] == '去绑定') {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BindPhone();
            }));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangeInfo(
                id: 1,
                info: datas[index - 1],
                vary: vary[index - 1],
              );
            }));
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(flex: 1, child: lists[index].left1),
              Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[lists[index].right2, lists[index].rIcon],
                  ))
            ],
          ),
        ),
      );
    }
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        if (value == "Camera") {
          getImageByCamera();
        } else if (value == "Gallery") {
          getImageByGallery();
        }
      }
    });
  }

  //拍照获取
  Future getImageByCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  //相册获取
  Future getImageByGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
}

//个人信息list item信息
class PersonInfno {
  PersonInfno({this.left1, this.right2, this.rIcon});
  //左边信息--组件类型，根据你的需要自定义组件
  Widget left1;
  //右边信息--组件类型，根据你的需要自定义组件
  Widget right2;
  Icon rIcon = Icon(Icons.chevron_right);
}
