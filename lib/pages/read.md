<!--
 * @Description: 
 * @version: 
 * @Author: lxw
 * @Date: 2019-11-22 10:18:49
 * @LastEditors: lxw
 * @LastEditTime: 2019-11-22 10:30:47
 -->
1. 页面级存放目录
> framPage:页面架构页：包含顶部状态栏、底部导航栏。这里面我不把它抽离成一个独立的页面，也就是把它放在main.dart里面。
> 4个底部导航栏切换对应的4个tabView页面，这些页面是再架构页的body里面的，我在想顶部有些tabView是需要自定义的，可以在对应的页面再创建带有自己顶部状态栏的页面。