import { Constants } from '../../wxTools/Constants'
import { chat } from '../model/wxChatListModel'

@ComponentV2
export struct ChatFriendCell {

  @Param @Require chat: chat

  build() {
    Row() {
      Row() {
        Image($r(`app.media.${this.chat.head_image}`))
          .width(40)
          .height(40)
          .borderRadius(4)
        Image($r('app.media.sanjiaozuo'))
          .width(16)
          .height(16)
      }

      Column() {
        Text(this.chat.content)
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .maxLines(30)
          .backgroundColor($r('app.color.wxWhiteColor'))
          .borderRadius(4)
          .padding({left: 10, right: 10, top: 12, bottom: 12})
          .margin({left: -6})
      }
      .alignItems(HorizontalAlign.Start)
      .width(Constants.SCREEN_WIDTH - 132)
    }
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .padding({top: 8, bottom: 8, right: 10, left: 10})
  }
}