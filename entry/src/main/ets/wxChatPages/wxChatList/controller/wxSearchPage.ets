import { Constants } from '../../wxTools/Constants'
import Logger from '../../wxTools/Logger'
import { NaviPage } from '../../wxBase/NaviPage'

@ComponentV2
export struct SearchPage {

  @Local searchAnimation: boolean = false
  @Local naviTranslateY: number = 0
  @Local searcTranslateY: number = 0
  @Local searchViewMLeft: number = (Constants.SCREEN_WIDTH - 16 - 61)/2
  @Local searchViewWidth: number = Constants.SCREEN_WIDTH - 16
  @Local searchShow: boolean = false
  @Local BackgroundColor: string = 'rgba(237, 237, 237, 0.1)'
  @Local yuyinShow: boolean = false
  @Local historyVisible: Visibility = Visibility.Hidden
  @Local textInputController: TextInputController = new TextInputController()
  @Event onDismiss: ()=>void = ()=>{}

  // 搜索框
  @Builder SearchHead() {
    Column(){
      Row() {
        Stack() {
          Row() {
            Image($r('app.media.sousuo'))
              .width(16)
              .height(16)
              .objectFit(ImageFit.Fill)
            TextInput({controller: this.textInputController, placeholder: '搜索'})
              .placeholderColor('rgb(130,130,130)')
              .placeholderFont({size: 16})
              .fontColor($r('app.color.Color_31'))
              .backgroundColor(Color.Transparent)
              .width(195)
              .enableKeyboardOnFocus(true)
              .height(37)
              .caretColor($r('app.color.Color_Tab_select'))
              .margin({left: -2.5})
              .key('Search')
          }
          .margin({left: this.searchViewMLeft})

          if (this.yuyinShow) {
            Image($r('app.media.yuyin_o'))
              .width(25)
              .height(25)
              .margin({left: this.searchViewWidth - 35})
          }
        }
        .align(Alignment.Start)
        .width(this.searchViewWidth)
        .backgroundColor($r('app.color.wxWhiteColor'))
        .borderRadius(6.0)
        .onClick((event) => {
          // 搜索点击事件
          Logger.info('搜索点击事件')
        })
        .margin({left: 8})

        Text('取消').margin({left: 16})
          .fontColor($r('app.color.Color_92_107_141'))
          .onClick(()=> {
            this.textInputController.stopEditing()
            this.yuyinShow = false
            this.historyVisible = Visibility.Hidden
            setTimeout(()=>{
              this.animatEnd()
            },100)
          })
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height(55)
    .translate({y: this.searcTranslateY})
    .backgroundColor($r('app.color.Color_237'))
  }

  // 右边按钮
  @Builder rightButton() {
    Image($r('app.media.icon_more'))
      .width(20)
      .height(20)
      .margin({ right: 20 })
  }

  build() {

    Column() {
      Column() {
        // 导航头
        NaviPage({
          currentNavi: new NavPathStack(),
          title: '微信',
          showBackButton: Visibility.Hidden,
          rightButton: this.rightButton.bind(this),
        })
          .translate({y: this.naviTranslateY})

        this.SearchHead()
      }
      .backgroundColor($r('app.color.Color_237'))

      Column() {
        Row() {
          Text('最近在搜')
            .fontColor($r('app.color.Color_179'))
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
          Blank()
          Text('展开')
            .fontColor($r('app.color.Color_179'))
            .fontSize(14)
            .fontWeight(FontWeight.Regular)
          Row()
            .backgroundColor($r('app.color.Color_241'))
            .width(0.6)
            .height(12)
            .margin({left: 10})
          Image($r('app.media.shanchu_g'))
            .width(16)
            .height(16)
            .margin({left: 10})
        }
        .width(Constants.SCREEN_WIDTH - 50)
        Row()
          .height(0.7)
          .backgroundColor($r('app.color.Color_241'))
          .width(Constants.SCREEN_WIDTH - 50)
          .margin({top: 10})

        Row() {
          Image($r('app.media.sousuojilu'))
            .width(14)
            .height(14)
          Text('转转 ｜ 买卖回收二手手机')
            .fontColor($r('app.color.Color_139'))
            .fontSize(16)
            .fontWeight(FontWeight.Regular)
            .margin({left: 8})
        }
        .margin({top: 15})
        .width(Constants.SCREEN_WIDTH - 50)
      }
      .margin({top: -15})
      .visibility(this.historyVisible)
    }
    .height('100%')
    .width('100%')
    .backgroundColor(this.BackgroundColor)
  }

  aboutToAppear(): void {
    this.yuyinShow = true
    setTimeout(()=>{
      this.animatStart()
    },100)
  }

  animatEnd() {

    animateTo({duration: 100, curve: Curve.Linear, onFinish: ()=>{
      setTimeout(()=>{
        this.onDismiss()
      }, 100)
    }},()=>{
      this.searchAnimation = false
      this.naviTranslateY = 0
      this.searcTranslateY = 0
      this.searchViewMLeft = (Constants.SCREEN_WIDTH - 16 - 61)/2
      this.searchViewWidth = Constants.SCREEN_WIDTH - 16
      this.BackgroundColor = 'rgba(237, 237, 237, 0.1)'
    })
  }

  animatStart() {

    animateTo({duration: 100, curve: Curve.Linear, onFinish: ()=>{
      this.historyVisible = Visibility.Visible
      focusControl.requestFocus('Search')
    }},()=>{
      this.searchAnimation = true
      this.naviTranslateY = - Constants.NAVI_HEIGHT
      this.searcTranslateY = - 38
      this.searchViewMLeft = 15
      this.searchViewWidth = Constants.SCREEN_WIDTH - 66
      this.BackgroundColor = 'rgba(237, 237, 237, 1)'
    })
  }
}