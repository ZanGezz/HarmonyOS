import CommonHelper from '../../wxTools/CommonHelper'

@ComponentV2
export struct ChatTimeCell {

  @Param @Once time: number = 0

  // UI
  build() {
    Column() {
      Text(CommonHelper.wxChatListTime(this.time))
        .fontSize(14)
        .fontColor($r('app.color.Color_179'))
    }
    .width('100%')
    .padding({top: 16, bottom: 8, right: 10, left: 10})
  }
}