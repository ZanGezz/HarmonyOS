
import { Constants } from '../../wxTools/Constants'
import { userInfoModel } from '../model/wxUserInfoModel';

@ComponentV2
export struct UserSwitchPageCell {

  // 用户信息
  @Param @Once user: userInfoModel = new userInfoModel();
  // cell 背景颜色
  @Param @Once itemBackGroundColor: string = 'app.color.wxWhiteColor'
  // cell 点击选中颜色
  @Local listItemBackGroundColor: string = 'app.color.wxWhiteColor'

  aboutToAppear(): void {
    this.listItemBackGroundColor = this.itemBackGroundColor
  }
  build() {
    Column() {
      Row() {
        Image($r(`app.media.${this.user.head_image}`))
          .width($r('app.float.wxChatListCellHeadImageW'))
          .height($r('app.float.wxChatListCellHeadImageH'))
          .borderRadius($r('app.float.wxChatListCellHeadImageRadius'))
          .margin({left: 15})

        Column() {
          Text(this.user.nick_name)
            .fontColor($r('app.color.Color_31'))
            .fontSize(16)
            .margin({top: 2})

          Text(this.user.personal_signature)
            .margin({top:7})
            .fontColor($r('app.color.Color_179'))
            .fontSize(14)
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis })
            .ellipsisMode(EllipsisMode.END)
            .width(Constants.SCREEN_WIDTH - 150)
        }
        .height(48)
        .margin({left:15})
        .alignItems(HorizontalAlign.Start)

        Blank()

        Image($r('app.media.qiehuan'))
          .margin({right: 20})
          .width(24)
          .height(24)
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
      .width('100%')

      // 底部分割线
      Row().backgroundColor($r('app.color.Color_241')).height(0.8).margin({left:80}).width(Constants.SCREEN_WIDTH-80)
    }
    .backgroundColor($r(this.listItemBackGroundColor))
  }
}