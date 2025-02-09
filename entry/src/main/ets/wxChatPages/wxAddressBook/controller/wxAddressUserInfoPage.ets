import { NaviPage } from '../../wxBase/NaviPage'
import { Constants } from '../../wxTools/Constants'
import CommonInstance from '../../wxTools/wxCommonInstance'
import DataManager from '../../wxChatList/request/ChatListDataManager'
import Logger from '../../wxTools/Logger'
import { userInfoModel } from '../../wxMine/model/wxUserInfoModel'
import { ListChatCell, ListCommonCell, ListImageCell } from '../views/wxAddressCommonCell'
import { room } from '../../wxChatList/model/wxChatListModel'

@ComponentV2
export struct AddressUserInfoPage {

  @Param @Require stack: NavPathStack
  @Local userInfo: userInfoModel = new userInfoModel()

  // 页面即将出现
  aboutToAppear(): void {
    this.userInfo = this.stack!.getParamByName('AddressUserInfoPage')[0] as userInfoModel
  }
  // 创建房间发消息
  createChatRoom() {
    // 创建房间号
    DataManager.quaryChatRoom([CommonInstance.crrentUserInfo.user_id!,this.userInfo.user_id!],(hasRoom,rooms)=>{
      Logger.info(JSON.stringify(hasRoom))
      if (hasRoom) {
        // 查询聊天记录，并跳转
        let room = rooms[0]
        DataManager.queryChatData(room, (chats)=>{
          this.stack!.pushPathByName('wxChatPage',[rooms, chats, !hasRoom])
        })
      } else {
        let room_id = 'wx_'+String(CommonInstance.crrentUserInfo.user_id)+'_'+String(this.userInfo.user_id)
        // 不存在，创建新房间，并跳转
        let userRoom: room = new room()
        userRoom.user_id = CommonInstance.crrentUserInfo.user_id!
        userRoom.room_id = room_id
        userRoom.type = 0
        userRoom.nick_name = this.userInfo.nick_name!
        userRoom.head_image = this.userInfo.head_image!
        userRoom.stick = 0

        let partnerRoom: room = new room()
        partnerRoom.user_id = this.userInfo.user_id!
        partnerRoom.room_id = room_id
        partnerRoom.type = 0
        partnerRoom.nick_name = CommonInstance.crrentUserInfo.nick_name!
        partnerRoom.head_image = CommonInstance.crrentUserInfo.head_image!
        partnerRoom.stick = 0

        Logger.info(JSON.stringify(hasRoom))
        this.stack!.pushPathByName('wxChatPage',[[userRoom, partnerRoom],[],!hasRoom])
      }
    })
  }
  // 右边按钮
  @Builder rightButton() {
    if (this.userInfo.user_id != CommonInstance.crrentUserInfo.user_id) {
      Image($r(`app.media.gengduo`))
        .width(24)
        .height(24)
        .margin(15)
        .onClick((event)=>{
          this.stack!.pushPath({name: 'UserInfoSettingPage', param: this.userInfo, onPop: (popInfo: PopInfo)=>{
          }});
        })
    }
  }
  // ListRow HeadCell
  @Builder ListHeadCell(user_info: userInfoModel) {
    Column() {
      Row()
        .height(400)
        .width('100%')
        .backgroundColor($r('app.color.wxWhiteColor'))
      Row() {
        Image($r(`app.media.${user_info.head_image}`))
          .width(64)
          .height(64)
          .borderRadius(6)
          .margin({left: 25})
        Column() {
          Row() {
            Text(user_info.nick_name)
              .fontSize(16)
              .fontWeight(600)
              .fontColor($r('app.color.Color_31'))
            Image(user_info.user_sex === 0 ? '' : '')
              .width(12)
              .height(12)
          }
          Text('微信号: '+user_info.wechat_id)
            .fontSize(15)
            .fontColor($r('app.color.Color_114'))
            .margin({top: 7})
          Text('地区: '+user_info.user_area)
            .fontSize(15)
            .fontColor($r('app.color.Color_114'))
            .margin({top: 6})
        }
        .margin({left: 18})
        .alignItems(HorizontalAlign.Start)
      }
      .height(130)
      .width('100%')

      Row()
        .height(0.6)
        .margin({left: 15})
        .backgroundColor($r('app.color.Color_237'))
        .width(Constants.SCREEN_WIDTH-15)
    }
    .margin({top: -400})
    .backgroundColor($r('app.color.wxWhiteColor'))
  }

  @Builder Footer() {
    Row()
      .height(10)
      .width('100%')
  }
  // 创建UI
  build() {
    NavDestination() {
      Column() {
        // 导航
        NaviPage({
          currentNavi: this.stack,
          rightButton: this.rightButton.bind(this),
          backGroundColor: 'app.color.wxWhiteColor'
        })
        // 列表
        List() {
          // 第一组
          ListItemGroup({footer: this.Footer()}) {
            ListItem() {
              this.ListHeadCell(this.userInfo)
            }
            ListItem() {
              ListCommonCell({title: '备注和标签'})
            }
            ListItem() {
              ListCommonCell({title: '朋友权限',showBottomLine: false})
            }
          }
          // 第二组
          ListItemGroup({footer: this.Footer()}) {
            ListItem() {
              ListImageCell({images: ['zange','zange','zange','zange']})
            }
            ListItem() {
              ListCommonCell({title: '更多信息',showBottomLine: false})
            }
          }
          // 第三组
          ListItemGroup({footer: this.Footer()}) {
            ListItem() {
              ListChatCell({title: '发消息',image_name: 'faxiaoxi'})
                .onClick((event)=>{
                  // 创建房间聊天
                  this.createChatRoom()
                })
            }
            ListItem() {
              ListChatCell({title: '音视频通话',image_name: 'shipin'})
            }
          }
        }
        .width('100%')
        .height(Constants.SCREEN_HEIGHT-Constants.NAVI_HEIGHT)
        .edgeEffect(EdgeEffect.Spring,{alwaysEnabled: true})
        .backgroundColor($r('app.color.Color_237'))
      }
    }
    .hideTitleBar(true)
  }
}