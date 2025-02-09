
import { FindListModel } from '../model/FindPageListModel'
import { Constants } from '../../wxTools/Constants'

@ComponentV2
export struct FindPageListCell {

  @Param @Require item: FindListModel
  @Local cellSelected: boolean = false

  build() {
    Column() {
      Row() {
        Image($r(this.item.image))
          .margin({ left: 16, bottom: 1})
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

      if (this.item.type == 1001) {
        Row()
          .height(10)
          .backgroundColor($r('app.color.Color_237'))
          .width(Constants.SCREEN_WIDTH)
      } else {
        Row()
          .height(0.5)
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