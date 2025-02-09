
import { Constants } from '../../wxTools/Constants'
import { alertItem } from '../model/FindPageListModel'

export enum CircleAlertType {
  postMoment,
  delete
}

@ComponentV2
export struct CircleAlertSheet {

  // 弹框类型
  @Param @Once alertType: CircleAlertType = CircleAlertType.postMoment
  // 弹框列表
  @Param @Once alertItems: alertItem[] = []
  @Local margin_top: number = Constants.SCREEN_HEIGHT
  @Local backGroundColor: string = 'rgba(0, 0, 0, 0)'
  // 选择后回调
  @Event pageDismiss: (type: CircleAlertType, item: alertItem)=>void = (type: CircleAlertType, item: alertItem)=>{}

  // 关闭页面
  DismissPage(item: alertItem) {
    animateTo({
      duration: 350,
      curve: Curve.EaseInOut,
      onFinish: ()=>{
        this.pageDismiss(this.alertType, item)
      }
    },()=>{
      this.margin_top = 280
      this.backGroundColor = 'rgba(0, 0, 0, 0)'
    })
  }
  // 页面出现
  aboutToAppear(): void {
    animateTo({
      duration: 350,
      curve: Curve.EaseInOut
    },()=>{
      this.backGroundColor = 'rgba(0, 0, 0, 0.3)'
      this.margin_top = 0
    })
  }

  @Builder sheetCell(item: alertItem, index: number) {
    Column() {

      if (index === this.alertItems.length - 1) {
        Column()
          .backgroundColor($r('app.color.Color_246'))
          .height(10)
          .width('100%')
      }

      Text(item.title)
        .fontSize(16)
        .fontColor($r(item.fontColor))
        .margin({top: 20})

      if (item.subTitle.length > 0) {
        Text(item.subTitle)
          .fontSize(14)
          .fontColor($r('app.color.Color_179'))
          .margin({top: 5})
      }

      if (index < this.alertItems.length - 1) {
        Row()
          .backgroundColor($r('app.color.Color_241'))
          .margin({top: 20})
          .height(0.5)
          .width('100%')
      }

      if (index === this.alertItems.length - 1) {
        Column()
          .backgroundColor($r('app.color.wxWhiteColor'))
          .height(40)
          .width('100%')
      }
    }
    .onClick((event)=>{
      this.DismissPage(item)
    })
    .width('100%')
    .backgroundColor($r('app.color.wxWhiteColor'))
  }
  build() {
    Stack() {
      List() {
        ForEach(this.alertItems,(item: alertItem, index: number)=>{
          ListItem() {
            this.sheetCell(item, index)
          }
        })
      }
      .translate({ y : this.margin_top })
      .borderRadius({topLeft: 12, topRight: 12})
    }
    .height('100%')
    .alignContent(Alignment.Bottom)
    .backgroundColor(this.backGroundColor)
    .onClick((event)=>{
      this.DismissPage(this.alertItems[this.alertItems.length-1])
    })
  }
}