import { Constants } from '../../wxTools/Constants'
import { AlertOption } from './AlertOptions'
import { AlertType } from './AlertTypes'
import alert from './Alert'

/**
 * AlertCustomDialog 弹出指定类型的自定义弹框
 * @param option
 */
@Builder
export function AlertCustomDialog(option: AlertOption) {
  if (option.alertType === AlertType.Alert_Type_MomentDelete) {
    // 删除类型的弹框
    Dialog_type_MomentDelete(option)
  } else if (option.alertType === AlertType.Dialog_type_LoadingAndText) {
    // 加载中
    Dialog_type_LoadingAndText({option: option})
  } else if (option.alertType === AlertType.Alert_Type_Toast) {
    // 吐司
    Dialog_type_Toast({option: option})
  } else if (option.alertType === AlertType.Alert_Type_GIF) {
    // 吐司
    Dialog_type_GIF({option: option})
  } else {
    Dialog_type_Toast({option: option})
  }
}


/**
 * Dialog_type_MomentDelete 弹框类型与删除朋友圈弹框一致 无标题 确认按钮为红色 粗体
 * @param option
 */
@Builder
export function Dialog_type_MomentDelete(option: AlertOption) {
  Column() {
    Column() {
      Text(option.content)
        .fontSize(16)
        .fontColor($r('app.color.Color_31'))
        .fontWeight(600)
    }
    .padding({ left: 20, right: 20, top: 40, bottom: 40 })
    Row()
      .backgroundColor($r('app.color.Color_241'))
      .width(Constants.SCREEN_WIDTH - 60)
      .height(0.5)
    Row() {
      Text(option.cancelTitle)
        .fontSize(16)
        .fontColor($r('app.color.Color_31'))
        .textAlign(TextAlign.Start)
        .padding(14)
        .fontWeight(600)
        .width((Constants.SCREEN_WIDTH - 60)/2)
        .height(55)
        .textAlign(TextAlign.Center)
        .onClick(()=>{
          if (option.callBack) {
            option.callBack(option.cancelTitle!)
          }
          alert.closeCustomDialog()
        })
      Row()
        .width(0.5)
        .height(55)
        .backgroundColor($r('app.color.Color_241'))
      Text(option.okTitle)
        .fontSize(16)
        .fontColor($r('app.color.Color_200_109_103'))
        .padding(14)
        .fontWeight(600)
        .textAlign(TextAlign.Center)
        .width((Constants.SCREEN_WIDTH - 60)/2-0.5)
        .height(55)
        .onClick(()=>{
          if (option.callBack) {
            option.callBack(option.okTitle!)
          }
          alert.closeCustomDialog()
        })
    }
    .justifyContent(FlexAlign.SpaceBetween)
  }
  .borderRadius(16)
  .backgroundColor(Color.White)
}

/**
 * 加载中 Loading 米花转圈类型 支持图片下文字
 */
@ComponentV2
export struct Dialog_type_LoadingAndText {

  @Param @Require option: AlertOption = {}
  @Local angle: number = 0

  build() {
    Column() {
      Image($r(this.option.logoImage))
        .width(50)
        .height(50)
        .rotate({angle: this.angle})
        .animation({
          duration: 200,
          curve: Curve.Linear,
          iterations: -1,       // 重复次数
        })
        .onAppear(()=>{
          this.angle = 60
        })
      if (this.option.content) {
        Text(this.option.content)
          .fontColor(Color.White)
          .fontSize(16)
          .margin({top: 5})
      }
    }
    .backgroundColor(Color.Black)
    .padding(15)
    .borderRadius(8)
  }
}

/**
 * GIF动图
 */
@ComponentV2
export struct Dialog_type_GIF {

   @Param @Require option: AlertOption = {}

  build() {
    Column() {
      Image($r(this.option.logoImage))
        .width(50)
        .height(50)
    }
    .backgroundColor(Color.Black)
    .padding(15)
    .borderRadius(8)
  }
}

/**
 * 加载中 Toast 吐司
 */
@ComponentV2
export struct Dialog_type_Toast {

  @Param @Require option: AlertOption = {}
  @Local angle: number = 0

  build() {
    Column() {
      Column() {
        Text(this.option.content)
          .fontColor(Color.White)
          .fontSize(16)
          .padding(20)
          .lineHeight(20)
          .letterSpacing(1)
      }
      .backgroundColor(Color.Black)
      .borderRadius(8)
    }
    .width(Constants.SCREEN_WIDTH - 60)
    .onAppear(()=>{
      if (!this.option.duration) {
        this.option.duration = 2000
      }
      setTimeout(()=>{
        alert.closeCustomDialog()
      }, this.option.duration)
    })
  }
}

