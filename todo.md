<!--
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2019-11-22 09:54:43
 * @LastEditors: lxw
 * @LastEditTime: 2020-03-26 16:52:34
 -->
<!-- TODO: -->
<!-- 1. 页面架构：必须搞完。 -->
<!-- 2. 页面主题配置：颜色 + 白天与夜间模式切换 -->
3. 加入一些特效：b站视频。
> 1. 路由页面的跳转动画：就是要第一个：fade类型的
4. 登录状态判断：对于需要登录才能操作的地方，以及需要登录才可以显示的页面：可以根据全局状态管理获取用户是否登录，做相关判断，显示不同的布局
5. 保存一些代码
>  Color theme;
>    Brightness brightnessStyle;//用户指定app的亮度模式：夜间、白天
6. 第三方相关
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
 - 银行、信用卡记账app：外包项目，当时甲方公司运营人员去微信开放平台注册，申请，我负责提供app包名和app签名。通过审核后他们将appid等我需要的相关信息发给我，我负责和后台配合，实现微信支付的功能
 - 此项目：此项目使用flutter开发，微信支付sdk打算使用fluwx ，已经为app申请了appid，时间原因和微信支付需要公司认证等，没有继续实现整个功能






问题记录：
1. 暂时不做持久化了，不方便演示，如果需要持久化的话，把那句注释去掉就行了。
2. 根据课程id获取课程没有做分页。
3. 没有根据更高级的课程类别id获取对应的课程

