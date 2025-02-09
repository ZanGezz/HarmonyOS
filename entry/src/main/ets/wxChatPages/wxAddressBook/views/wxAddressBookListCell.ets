
import { Constants } from '../../wxTools/Constants'
import { userInfoModel } from '../../wxMine/model/wxUserInfoModel';

@ComponentV2
export struct wxAddressBookListCell {

  // @Prop 修饰可以不初始化默认值
  @Param @Require item: userInfoModel;
  // cell 背景颜色
  @Local itemBackGroundColor: string = 'app.color.wxWhiteColor'
  // cell 点击选中颜色
  @Local listItemBackGroundColor: string = 'app.color.wxWhiteColor'
  // 点击cell
  @Event selectRow: ()=>void = () => {}
  // 页面出现
  aboutToAppear(): void {
    this.listItemBackGroundColor = this.itemBackGroundColor
  }

  // 创建UI
  build() {
    Column() {
      Row() {
        Image($r(`app.media.${this.item.head_image}`))
          .width(40)
          .height(40)
          .borderRadius($r('app.float.wxChatListCellHeadImageRadius'))
          .margin({ left: 16 })

        Text(this.item.nick_name)
          .fontColor($r('app.color.Color_31'))
          .fontSize(16)
          .margin({left: 14})
      }
      .height(55)
      .width('100%')
      // 底部分割线
      Row().backgroundColor($r('app.color.Color_241')).height(0.8).margin({left:60}).width(Constants.SCREEN_WIDTH-60)
    }
    .onTouch((event: TouchEvent) => {
      if (event.type == TouchType.Down) {
        this.listItemBackGroundColor = 'app.color.Color_210'
      } else  {
        this.listItemBackGroundColor = this.itemBackGroundColor
      }
    })
    .onClick((event)=>{
      // 点击事件传递
      this.selectRow()
    })
    .backgroundColor($r(this.listItemBackGroundColor))
  }
}