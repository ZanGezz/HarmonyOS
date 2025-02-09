import { LocationNames } from '../../wxBase/ImageDataModel'
import { Constants } from '../../wxTools/Constants'
import CommonHelper from '../../wxTools/CommonHelper'

@ComponentV2
export struct PostMomentCell {

  @Param @Once image: string = ''
  @Param @Once itemTitle: string = ''
  @Local titleColor: string = 'app.color.Color_31'
  @Param @Once rightValue: string = ''
  @Event didSelectRow: (location: string)=>void = (location: string)=>{}

  build() {
    Column() {
      Row() {
        Image($r(this.image))
          .width(20)
          .height(20)
          .margin({left: 15})
        Text(this.itemTitle)
          .fontSize(16)
          .fontColor($r(this.titleColor))
          .margin({left: 15})
        Blank()
        Text(this.rightValue)
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .margin({right: 15})
        Image($r('app.media.youjiantou'))
          .margin({right: 15})
          .width(24)
          .height(24)
      }
      .width(Constants.SCREEN_WIDTH - 30)
      .height(55)
      Row()
        .width(Constants.SCREEN_WIDTH - 30)
        .height(0.7)
        .margin({left: 15})
        .backgroundColor($r('app.color.Color_246'))
    }
    .width('100%')
    .onClick((event)=>{
      if (this.itemTitle === '所在位置') {
        this.image = 'app.media.location_g'
        this.titleColor = 'app.color.Color_115_116_122'
        this.itemTitle = LocationNames[CommonHelper.getRandomNumber(3)%LocationNames.length]
      }
      this.didSelectRow(this.itemTitle)
    })
  }
}