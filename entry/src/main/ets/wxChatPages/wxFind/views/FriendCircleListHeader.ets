import { Constants } from '../../wxTools/Constants'
import { userInfoModel } from '../../wxMine/model/wxUserInfoModel'
import CommonInstance from '../../wxTools/wxCommonInstance'

@ComponentV2
export struct FriendCircleListHeader {

  @Param @Require userInfo: userInfoModel = new userInfoModel()
  @Event BlankClick: () => void = () => {}
  @Event UserClick: (user_id: number) => void = (user_id: number) => {}

  build() {
    Stack() {
      Column() {
        Image($r(`app.media.${this.userInfo.cover_image}`))
          .height(400)
          .width('100%')
          .margin({top:-55-Constants.NAVI_HEIGHT})
          .objectFit(ImageFit.Cover)
        Row()
          .height(60)
          .width('100%')
          .backgroundColor($r('app.color.wxWhiteColor'))
      }
      Row(){
        Text(this.userInfo.nick_name)
          .fontSize(18)
          .fontColor($r('app.color.wxWhiteColor'))
          .fontWeight(600)
          .margin({bottom: 14, right:10})

        Image($r(`app.media.${this.userInfo.head_image}`))
          .width(70)
          .height(70)
          .borderRadius(8.0)
          .onClick(()=>{
            this.UserClick(this.userInfo.user_id!)
          })
      }
      .height(60)
      .margin({bottom: 45,right:12})
    }
    .onClick(()=>{
      this.BlankClick()
    })
    .alignContent(Alignment.BottomEnd)
    .width('100%')
  }
}