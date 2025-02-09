
import { room } from '../model/wxChatListModel'
import { Constants } from '../../wxTools/Constants'
import CommonHelper from '../../wxTools/CommonHelper'

@ComponentV2
export struct wxChatListCell {

  // @Link
  @Param @Require item: room;
  // cell 背景颜色
  @Param @Once itemBackGroundColor: string = 'app.color.wxWhiteColor'
  // cell 点击选中颜色
  @Param @Once listItemBackGroundColor: string = 'app.color.wxWhiteColor'
  // cell 点击事件
  @Event seleted: (item: room) => void = (item: room) => {}

  aboutToAppear(): void {
    this.listItemBackGroundColor = this.itemBackGroundColor
  }
  build() {
    Column() {
      Row() {
        Stack() {
          Image($r(`app.media.${this.item!.head_image}`))
            .width($r('app.float.wxChatListCellHeadImageW'))
            .height($r('app.float.wxChatListCellHeadImageH'))
            .borderRadius($r('app.float.wxChatListCellHeadImageRadius'))
            .margin({left: 15})
          if (this.item!.unread! > 0) {
            Text(String(this.item!.unread! > 99 ? 99 : this.item!.unread))
              .fontSize(10)
              .padding({left: 7, right: 7, top: 4, bottom: 4})
              .borderRadius(9)
              .margin({right: -5, top: -5})
              .fontColor($r('app.color.wxWhiteColor'))
              .backgroundColor($r('app.color.Color_200_109_103'))
          }
        }.alignContent(Alignment.TopEnd)

        Column() {
          Row() {
            Text(this.item.nick_name)
              .fontColor($r('app.color.Color_31'))
              .fontSize(16)

            Text(CommonHelper.wxChatListTime(this.item!.time))
              .fontColor($r('app.color.Color_210'))
              .fontSize(12)
              .textAlign(TextAlign.End)
              .margin({right: 15})
          }
          .margin({top:16})
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.SpaceBetween)
          .width(Constants.SCREEN_WIDTH - 78)

          Text(this.item!.last_chat)
            .margin({top:7})
            .fontColor($r('app.color.Color_179'))
            .fontSize(14)
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis })
            .ellipsisMode(EllipsisMode.END)
            .width(Constants.SCREEN_WIDTH - 128)
            .textAlign(TextAlign.Start)
        }
        .height('100%')
        .margin({left:15})
        .alignItems(HorizontalAlign.Start)
      }
      .height($r('app.float.wxChatListCellHeight'))
      .alignItems(VerticalAlign.Center)
      .onTouch((event: TouchEvent) => {
        if (event.type == TouchType.Down) {
          this.listItemBackGroundColor = 'app.color.Color_210'
        } else  {
          this.listItemBackGroundColor = this.itemBackGroundColor
        }
      })
      .onClick((event)=>{
        this.seleted(this.item!)
      })
      .width('100%')

      // 底部分割线
      Row().backgroundColor($r('app.color.Color_241')).height(0.8).margin({left:80}).width(Constants.SCREEN_WIDTH-80)
    }
    .backgroundColor($r(this.listItemBackGroundColor))
  }
}