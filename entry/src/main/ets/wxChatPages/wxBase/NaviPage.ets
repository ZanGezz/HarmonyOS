
import { Constants } from '../wxTools/Constants'

enum naviHeader {
  commen,    // 通用导航
  chatList,  // chat列表页导航

}

@ComponentV2
export struct NaviPage {

  // 标题
  @Param @Once title: string = ''
  @Param @Require currentNavi: NavPathStack
  // 是否避让键盘，默认不避让
  safeAreaForKeyboard: boolean = false

  @Param @Once backGroundColor: string = 'app.color.Color_237'
  // 返回按钮
  @Param @Once backButtonImage: string = 'app.media.fanhui_b'
  // 是否显示返回按钮 默认显示
  @Param @Once showBackButton: Visibility = Visibility.Visible
  // 显示底线
  @Param showBottomLine: boolean = false
  // 返回按钮事件传递方法 默认pop返回
  @Event backAction: () => void = () => {
    if (this.currentNavi !== undefined) {
      this.currentNavi.pop()
    }
  }

  // 右边栏按钮 插槽
  @Builder rightButtonSlot(){}
  @BuilderParam rightButton: ()=>void = this.rightButtonSlot

  build() {
    Column() {
      Row().height(Constants.STATUS_BAR_HEIGHT)
      Stack() {
        Row() {
          // 标题
          Text(this.title)
            .fontSize(17)
            .fontColor($r('app.color.Color_31'))
            .textAlign(TextAlign.Center)
            .fontWeight(600)
            .width('100%')
        }
        .height(Constants.NAVI_HEIGHT-Constants.STATUS_BAR_HEIGHT)

        Row() {
          // 返回按钮
          Image($r(this.backButtonImage))
            .width(20)
            .height(20)
            .margin({left: 12})
            .visibility(this.showBackButton)
            .onClick(()=>{
              this.backAction()
            })
          // 空白填充
          Blank()
          // 右边按钮 插槽
          this.rightButton()
        }
        .width('100%')
        .height(Constants.NAVI_HEIGHT-Constants.STATUS_BAR_HEIGHT)
      }
      if (this.showBottomLine) {
        Row().height(0.5).width('100%').backgroundColor($r('app.color.Color_246'))
      }
    }
    // 导航头不避让键盘
    .expandSafeArea(this.safeAreaForKeyboard ? [SafeAreaType.SYSTEM] : [SafeAreaType.KEYBOARD])
    .width('100%')
    .height(Constants.NAVI_HEIGHT+1)
    .backgroundColor($r(this.backGroundColor))
  }
}