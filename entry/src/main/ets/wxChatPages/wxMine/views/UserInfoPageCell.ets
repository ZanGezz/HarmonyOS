import { HeadImageArray } from '../../wxBase/ImageDataModel'
import CommonHelper from '../../wxTools/CommonHelper'
import { Constants } from '../../wxTools/Constants'

@ComponentV2
export struct UserInfoPageCell {

  @Param @Once title: string = ''
  @Param content: string = ''
  @Param @Once addBottomLine: boolean = true
  @Param @Once cellSelected: boolean = false

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .margin({left: 16})

        Blank()

        Column() {
          Text(this.content)
            .fontSize(16)
            .fontColor($r('app.color.Color_114'))
            .margin({right: 4})
            .maxLines(2)
        }
        .alignItems(HorizontalAlign.End)
        .width('60%')

        Image($r('app.media.youjiantou'))
          .margin({right: 15})
          .width(24)
          .height(24)
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
    .backgroundColor(this.cellSelected ? $r('app.color.Color_210') : $r('app.color.wxWhiteColor'))
    .onTouch((event)=>{
      this.cellSelected = event.type == TouchType.Down ? true : false
    })
  }
}

@ComponentV2
export struct UserInfoPageHeadImageCell {

  @Param @Once title: string = ''
  @Param @Once head_image: string = ''
  @Param addBottomLine: boolean = true
  @Local cellSelected: boolean = false
  @Event ChangeHeadImage: (image: string) => void = (image: string) => {}

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .margin({left: 16})

        Blank()

        Image($r(`app.media.${this.head_image}`))
          .margin({right: 4})
          .width(64)
          .height(64)
          .borderRadius(6)
          .onClick((event)=>{
            this.head_image = HeadImageArray[CommonHelper.getRandomNumber(3) % HeadImageArray.length]
            this.ChangeHeadImage(this.head_image)
          })

        Image($r('app.media.youjiantou'))
          .margin({right: 15})
          .width(24)
          .height(24)
      }
      .height(84)
      .width('100%')

      if (this.addBottomLine) {
        Row()
          .height(0.5)
          .margin({ left: 16 })
          .backgroundColor($r('app.color.Color_241'))
          .width(Constants.SCREEN_WIDTH-16)
      }
    }
    .backgroundColor(this.cellSelected ? $r('app.color.Color_210') : $r('app.color.wxWhiteColor'))
    .onTouch((event)=>{
      this.cellSelected = event.type == TouchType.Down ? true : false
    })
  }
}