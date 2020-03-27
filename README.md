<!--
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2019-11-18 09:28:11
 * @LastEditors: lxw
 * @LastEditTime: 2020-03-27 17:02:43
 -->
## 易教育App —— flutter开发的简单在线教育平台安卓客户端

ps：边开发边学习，功能仍在完善当中...

## 简单架构相关

### flutter app简单架构考虑
1. 简述
> 考虑到json -> dart model; <br/> 全局数据配置文件；<br/> 共享状态数据配置文件 <br/> 数据持久化实现
> app页面架构，页面Widget，复用Widget，跨组件共享的State类

2. 页面管理
> 页面架构:骨架frame页面（基本的骨架:提供顶部搜索、底部tab。），tabview页面。非tabview页面是脱离页面脚手架的所以可以全新定义（可以不使用scafold，可以直接return MatrainApp自定义页面顶部等，比如customerview那个案例）

3. 数据管理相关
 - 数据持久化、状态共享——简述
>  共享状态 —— app部分数据在所有组件之间的共享
> 数据持久化 —— 部分数据需要在用户手动清除前进行持久化存储在本地
> 共享与持久化关系：持久化同时又需要共享的数据：数据更新，调用共享状态方法，同时进行持久化存储。
- 数据持久化、状态共享——实现方案
> common文件夹下封装通用方法类：
  > - 全局变量Global类：保存全局变量信息，信息数据属性、数据持久化相关方法--静态方法，方便使用，app载入数据初始化，但是对于数据修改需要触发多个页面的ui更新的还是使用状态共享合适。这里是作为一个app整体的部分全局数据、方法的管控以及app每次重新载入的数据初始化：登录用户信息等是否缓存，是:登录状态，否：非登录状态
  > - 状态共享管理 :  `实现方案(Provider)` 管控app全局状态共享，只要是相关的状态共享就需要它，比如登录状态，调用它对应类内部封装属性或方法判断，状态更新调用它对应类内部封装的方法进行更新。跨页面状态共享的地方使用它来获取对应的状态实现多个地方的状态共享，及时更新信息。（app内部状态共享：所有组件共享，使用和修改都需要调用相关的方法），采用方案是全局变量(登录用户信息类，账号信息类、数据信息持久化相关方法（增、删）)
  > 关系：全局变量Global提供载入app的数据初始化以及为Provider相关管控类提供部分数据封装类入User类。provide负责 实现App状态共享，维护需要全局状态共享的数据：提供修改和获取等相关方法
  - 应用
  ```dart
   // 退出登录，调用封装的全局静态方法清除持久化的用户信息
        Global.clearUser();
  // 使用provide更新状态，通知其他页面
        User user1 = Global.user;
        user1.userInfo = null;
        userModel.changeUserInfo(user1);
  ```
- app入口初始化信息后再构建app视图等
 ```dart
 void main() => Global.init().then((e) => runApp(MyApp()));
 ```

4. 网络请求相关
 - 数据层  json -> dart Model类
 > 根据后台接口相关的实体类的json数据，生成相对应的Dart Model类，方便我们获取后台数据后进行对数据业务逻辑的操作，使用这种方式不容易出错
 > 补充:每一个实体类json，我们可以生成一个对应的Dart Model类
 > 补充：对于涉及用户账号信息、登录状态、用户设备app配置信息等需要进行持久化，此时我们至少需要建立两个关联的json文件来生成对于的Dart Model类
 >如本项目例子: `user.json` 与 `userInfo.json`
> `userInfo.json`对于后台接口的用户账号信息，`user.json`则对应我们本设备app用户登录状态、app配置相关信息，如下

- `userInfo.json`
```json
{
    "stuid": "ST20191205001",
    "roleId": 3,
    "petname": "宏野鬼眼",
    "stuname": "杰克",
    "stupassword": "123456",
    "stusex": "男",
    "stuage": 18,
    "birthday": null,
    "role": null,
    "phone": "13454454554",
    "email": "1143134444@qq.com",
    "qq": "1143134444",
    "registertime": 1575705233000,
    "address": "暂无信息",
    "stuintroduce": "暂无信息",
    "integral": null,
    "state": 0
  }
```
- `user.json`
```json
{
    "userInfo":"$userInfo",
    "theme":"user's app theme",
    "brightnessStyle":"brightnessStyle"
}
```
应用，调用后台接口可获取到用户账号信息也就是userInfo信息
```dart
 var userInfo1 =  new UserInfo.fromJson(uInfo);
 print(userInfo1.petname);
```
- flutter网络请求插件——Dio
> http.dart封装基于Dio的两个请求方法——get、post，通过回调函数监听请求成功和失败将其暴露出来
    

### flutter开发经验
- 开发环境
> vscode 开发、调试、打包flutter，hot load模式，便于开发调试

- flutter本身；构建页面的Widget + 数据状态
> 无状态Widget无需数据交互，带状态的Widge需要数据交互等相关业务逻辑，数据驱动不同Widget构建的ui进行更新
- 标签
`flutter组件Widget——局部组件的、构建功能组件的、构建完整页面脚手架等到`、`flutter使用Widget实现布局`、`flutter异步`、`flutter状态共享`、`flutter 数据持久化`


## 简单开发过程相关

###  第三方相关
- 微信登录
- 微信支付[参考](https://zhuanlan.zhihu.com/p/68971736)[参考](https://www.jianshu.com/p/2c9ca9a1b708)
  1. 微信支付流程——客户端、后台接口
  流程简述：客户端收集用户填写的订单表单相关信息，通过后台开发的接口将订单参数传给后台，后台调用微信统一下单接口，获得预支付订单id(prepayid)，签名sign，后将这些参数返回给客户端
    ```java
    // 相关接口参数
    params.put("appid", Const.APP_ID);//App ID
    params.put("body", "Test Goods");//商品名称
    params.put("mch_id", Const.MCH_ID);//商户号
    params.put("nonce_str", WXPayUtil.generateNonceStr());//随机字符串
    params.put("notify_url", Const.NOTIFY_URL);//支付结果回调地址
    params.put("out_trade_no", WXPayUtil.generateUUID());//订单号
    params.put("spbill_create_ip", "127.0.0.1");//  用户端实际ip
    params.put("total_fee", "1");//金额
    params.put("trade_type", "APP");//支付类型
    params.put("sign", sign(params));//签名
    ```
   后台调用统一下单接口成功后，将获取到的参数返回给客户端，供客户端唤起微信支付，主要包括下面的流程：
   - 初始化（注册）支付sdk--需要参数appId
   - 调用支付接口，传入后台穿过来的那些参数，如下：
   ```dart
    appId: res['appid'],
    partnerId: res['partnerid'],
    prepayId: res['prepay_id'],
    packageValue: res['package'],
    nonceStr: res['nonce_str'],
    timeStamp:  res['timestamp'],
    sign: res['sign'],
    signType: '',
    extData: ''
   ```
   监听支付结果,通过状态码判断支付成功还是失败
    

2. 微信支付需要去微信开放平台申请获取以下参数的信息
   >- App ID：在微信开放平台创建应用，配置应用包名和签名(确保签名与你app运行时的签名一致，可以通过app的包名利用工具来获取)
   >- API KEY: 微信商户平台设置
   >- 商户号: 微信商户平台商户号
3. 具体的申请流程   
```
微信开放平台 申请账号，
创建移动应用（Android的应用签名后面可以修改，只要你能保证你release的包签名跟这里填的一致即可. 签名获取:Gen_Signature_Android2）。
审核通过后就有了AppID
开发者资质认证，通过后申请支付权限
开通支付后续会引导你注册一个商户账号, 也就是微信支付-商户平台
商户ID 账户中心-个人信息-账号信息-登录账号
API密钥 账户中心-账户设置-API安全-设置API密钥
```

4. 开发案例
   - 存储卡、信用卡、记账管理app：外包项目，当时甲方公司运营人员去微信开放平台注册，申请，我负责提供app包名和app签名。通过审核后他们将appid等我需要的相关信息发给我，我负责和后台配合，实现微信支付的功能。[官网](http://al16346814.jz.fkw.com/)
   - 此项目：此项目使用flutter开发，微信支付sdk打算使用fluwx，但是由于申请微信开放平台貌似还是没有针对个体用户开放，申请过程还是需要填写企业认证相关信息，加上时间也不够了，后台小伙伴也没有打算对接微信支付，所以就没有实现微信支付

- 支付宝支付
<img src='http://img01.taobaocdn.com/top/i1/LB1n8NYKVXXXXbbXpXXXXXXXXXX'>

 支付宝的支付把很多重要的数据都是放在服务器后端的，所以服务器端操作比较繁琐，需要集成sdk，调用sdk相关接口等到，这里(fluter)客户端支付宝支付(安装支付宝flutter支付插件，不需要像安卓那样下载集成sdk)的代码就相对比较少，关键是下面两部(本项目使用的是支付宝沙箱环境)
  
  1. 安装  `flutter_alipay` 插件 [文档](https://pub.dev/packages/flutter_alipay)
   ```yaml
    flutter_alipay: ^0.1.0
   ```
   2. 根据用户下单参数调后台生成订单接口，获取支付包支付签名sign(用于在客户端调起支付宝支付)，下面是相关代码
   ```dart

   // 调用后台接口，获取相关数据
   DataUtils.payByAli(params).then((value) {
        if (value != null) {
          print('   ALiVVVVVV $value');

          var jsData = json.decode(value);
          int status = jsData['status'];
          String msg = jsData['msg'];
          if (status == Constant.SUCCESS_CODE) {
            AliPaySignBean aliPaySignBean =
            AliPaySignBean.fromJson(jsonDecode(value));
            AliPaySignInfo signInfo = aliPaySignBean.data.info;
            String sign = signInfo.sign;
            // 使用sign调起支付宝
            aliPay(sign);
          } else {
            Util.showToast(msg);
          }
        }
      }).catchError((e) {
        print(' ## $e');
      });

    // aliPay（）这个接口通过传入的sign调起支付宝支付，代码如下：  
      void aliPay(String sign) async {
    if (sign == null || sign.length == 0) {
      return;
    }
    FlutterAlipay.pay(
      sign,
      urlScheme: '你的ios urlScheme', //前面配置的urlScheme
       isSandbox: true //是否是沙箱环境，只对android有效
    ).then((payResult){
      _payResult = payResult;
      print('>>>>>  ${_payResult.toString()}');

      String payResultStatus = _payResult.resultStatus;
      if (payResultStatus == Constant.ALIPAY_SUCCESS) {
        payState = true;
        Util.showToast('支付成功');
      } else if (payResultStatus == Constant.ALIPAY_CANCLE) {
        payState = false;
        Util.showToast('支付取消');
      } else if (payResultStatus == Constant.ALIPAY_FAILE) {
        payState = false;
        Util.showToast('支付失败');
      } else if (payResultStatus == Constant.ALIPAY_WAITTING) {
        payState = false;
        Util.showToast('等待支付');
      } else if (payResultStatus == Constant.ALIPAY_NET_ERROR) {
        payState = false;
        Util.showToast('无网络');
      } else if (payResultStatus == Constant.ALIPAY_REPET) {
        payState = false;
        Util.showToast('重复支付');
      }
      jump2PayForCourseDetail();
      if (!mounted) return;
      setState(() {});
    }).catchError((e){
      _payResult = null;
      payState = false;
      Util.showToast('支付失败');
    });
  }
   ```
  
  ### 项目页面、业务逻辑等开发相关
  > 页面：顶部视频播放器窗口 + 中间tab切换 + 底部tab切换后渲染的不同ui页面：评论、详情、课程章节

  #### 难点
  1. 视频播放器(自定义需求)
    - 实现一个自定义视频播放器：自定义视频播放器ui页面实现 + 视频播放逻辑
  2. tab切换 + 不同页面渲染(局部渲染)
  



 



