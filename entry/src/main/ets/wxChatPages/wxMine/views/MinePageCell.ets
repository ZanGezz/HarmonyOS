
import { mineListModel } from '../model/wxUserInfoModel'
import { Constants } from '../../wxTools/Constants'

@ComponentV2
export struct minePageCell {

  @Param @Require item: mineListModel
  @Param @Once addBottomLine: boolean = false
  @Param @Once cellSelected: boolean = false

  build() {
    Column() {
      Row() {
        Image($r(this.item.image))
          .margin({ left: 16, bottom: 2 })
          .width(20)
          .height(20)

        Text(this.item.title)
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .margin({ left: 10 })

        Blank()

        Image($r('app.media.youjiantou'))
          .margin({right: 12})
          .width(24)
          .height(24)
      }
      .height(55)
      .width('100%')

      if (this.addBottomLine) {
        Row()
          .height(0.8)
          .margin({ left: 50 })
          .backgroundColor($r('app.color.Color_241'))
          .width(Constants.SCREEN_WIDTH-50)
      }
    }
    .backgroundColor(this.cellSelected ? $r('app.color.Color_210') : $r('app.color.wxWhiteColor'))
    .onTouch((event)=>{
      this.cellSelected = event.type == TouchType.Down ? true : false
    })
  }
}

@ComponentV2
export struct UserInfoToggleCell {

  @Param @Once title: string = ''
  @Param addBottomLine: boolean = true
  @Param @Once isOn: boolean = false
  @Event ToggleAction: (on: boolean) => void = (on: boolean) => {}

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .margin({left: 16})

        Blank()

        Toggle({type: ToggleType.Switch, isOn: this.isOn})
          .onChange((isOn: boolean)=>{
            setTimeout(()=>{
              this.ToggleAction(isOn)
            }, 200)
          })
          .selectedColor($r('app.color.Color_115_116_122'))
          .margin({right: 15})
          .height(30)
          .width(50)
      }
      .height(55)
      .width('100%')

      if (this.addBottomLine) {
        Row()
          .height(0.5)
          .margin({ left: 16 })
          .backgroundColor($r('app.color.Color_241'))
          .width(Constants.SCREEN_WIDTH-16)
      }
    }
    .backgroundColor(Color.White)
  }
}