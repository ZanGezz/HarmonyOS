import { Constants } from '../../wxTools/Constants'
import { chat } from '../model/wxChatListModel'

@ComponentV2
export struct ChatUserCell {

  @Param @Require chat: chat

  build() {
    Row() {
      Row()
        .width(57)
      Column() {
        Text(this.chat.content)
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .maxLines(30)
          .backgroundColor($r('app.color.Color_169_231_122'))
          .borderRadius(4)
          .padding({left: 10, right: 10, top: 12, bottom: 12})
          .margin({right: -6})
      }
      .alignItems(HorizontalAlign.End)
      .width(Constants.SCREEN_WIDTH - 132)

      Row() {
        Image($r('app.media.sanjiaoyou'))
          .width(16)
          .height(16)
        Image($r(`app.media.${this.chat.head_image}`))
          .width(40)
          .height(40)
          .borderRadius(4)
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .padding({top: 8, bottom: 8, right: 10, left: 10})
  }
}