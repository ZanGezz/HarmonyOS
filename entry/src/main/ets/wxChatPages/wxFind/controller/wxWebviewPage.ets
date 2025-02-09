import { webview } from '@kit.ArkWeb';
import { NaviPage } from '../../wxBase/NaviPage';
import Alert from '../../wxComponents/wxAlert/Alert'
import { GIF, Toast } from '../../wxComponents/wxAlert/AlertOptions';
import { AlertType } from '../../wxComponents/wxAlert/AlertTypes';
import JsBridge from '../../wxComponents/wxJSBridge/JSBridge';
import { ParamsItem } from '../../wxComponents/wxJSBridge/JSBridgeOptions';
import Logger from '../../wxTools/Logger';
import { JSON } from '@kit.ArkTS';
import { Constants } from '../../wxTools/Constants';

@ComponentV2
export struct WebviewPage {

  // 导航控制器
  @Param @Once stack: NavPathStack = new NavPathStack()
  @Local webUrl: string = ''
  @Local progress: number = 0
  @Local progressVisible: Visibility = Visibility.Visible

  private WebController: webview.WebviewController = new webview.WebviewController()
  // ****************接收H5的调用原生的事件和参数
  onMessageFromH5: (funcName: string,callID: number, params: string) => void = (funcName: string,callID: number, params: string) => {
    Logger.info(funcName)
    Logger.info(params)
    let param: ParamsItem = {callID: 10001, data:'liushuai'}
    // ******************使用callback和callID给H5端回调
    this.jsBridge.callback(callID, JSON.stringify(param))
    // 前端页面函数无参时，将param删除。
    //this.WebController.runJavaScript(`changeMessage(${JSON.stringify(param)})`)
    //this.WebController.runJavaScript('changeMessage()')
  }
  private jsBridge: JsBridge = new JsBridge(this.WebController, this.onMessageFromH5)


  build() {
    NavDestination(){

      Stack() {
        // 导航头
        NaviPage({
          currentNavi: this.stack,
          title: '详情',
          backGroundColor: 'app.color.wxWhiteColor',
          showBottomLine: true
        })

        Row()
          .width(this.progress*Constants.SCREEN_WIDTH)
          .height(1)
          .backgroundColor($r('app.color.Color_200_109_103'))
          .margin({top: Constants.NAVI_HEIGHT-1})
          .visibility(this.progressVisible)

        Column(){

          Web({src: $rawfile('index.html'),controller: this.WebController})
            .onAppear(()=>{
            })
            .onPageBegin(()=>{
              // 初始化initJsBridge
              this.jsBridge.initJsBridge()
            })
            .onPageEnd(()=>{
              this.progressVisible = Visibility.Hidden
            })
            .onProgressChange((event)=>{
              this.progress = event.newProgress/100
            })
            .javaScriptProxy(this.jsBridge.javaScriptProxy())
            .javaScriptAccess(true)
            .domStorageAccess(true)
            .imageAccess(true)
            .onAlert((event)=>{
              Alert.showDialog(this.getUIContext(), {alertType: AlertType.Alert_Type_Toast, content: event.message,duration: 2500 })
              event.result.handleCancel()
              return true
            })
        }
        .margin({top: Constants.NAVI_HEIGHT})
        Button('runJavaScript')
          .onClick(() => {
            // 前端页面函数无参时，将param删除。
            this.WebController.runJavaScript("changeMessage()", (callback)=>{

            })
          })
          .margin({left: 200, top: 200})
      }
      .alignContent(Alignment.TopStart)
    }
    .hideTitleBar(true)
  }

  // 页面出现
  aboutToAppear(): void {
    // 配置Web开启调试模式
    webview.WebviewController.setWebDebuggingAccess(true);
    // 获取页面传递的参数
    this.webUrl  = this.stack!.getParamByName('WebviewPage')[0] as string
  }
}