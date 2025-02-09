import { NaviPage } from '../../wxBase/NaviPage'
import { Constants } from '../../wxTools/Constants'
import { UserInfoPageCell } from '../../wxMine/views/UserInfoPageCell'
import { UserInfoToggleCell } from '../../wxMine/views/MinePageCell'
import HMEmitter from '../../wxTools/HMEmitter'
import { room } from '../model/wxChatListModel'
import DataManager from '../request/ChatListDataManager'
import { PAGE_TYPE } from '../../wxTools/wxCommonInstance'

@ComponentV2
export struct wxChatInfoPage {

  @Param @Require stack: NavPathStack = new NavPathStack()
  // 房间信息
  @Local userRoom :room = this.stack.getParamByName('wxChatInfoPage')[0] as room
  @Local isOn: boolean = this.userRoom.stick == 1 ? true : false

  @Builder Gropfooter() {
    Row()
      .height(10)
      .width('100%')
  }

  @Builder Listfooter() {
    Row()
      .height(80)
      .width('100%')
  }

  build() {
    NavDestination() {
      Column() {
        NaviPage({
          title: '聊天详情',
          currentNavi: this.stack
        })
        // 列表
        List() {
          ListItemGroup({footer: this.Gropfooter()}) {
            ListItem() {
              UserInfoPageCell({title: '查找聊天内容'})
            }
          }
          ListItemGroup({footer: this.Gropfooter()}) {
            ListItem() {
              UserInfoToggleCell({title: '消息免打扰', addBottomLine: true, ToggleAction: (isOn: boolean) => {

              }})
            }
            ListItem() {
              UserInfoToggleCell({title: '置顶聊天',isOn: this.isOn, addBottomLine: true, ToggleAction: (isOn: boolean) => {
                this.userRoom.stick = isOn ? 1 : 0
                DataManager.updateChatRoom(this.userRoom, (success)=>{
                  HMEmitter.emit(1,JSON.stringify([PAGE_TYPE.chat]))
                })
              }})
            }
            ListItem() {
              UserInfoToggleCell({title: '提醒', ToggleAction: (isOn: boolean) => {

              }})
            }
          }
          ListItemGroup({footer: this.Gropfooter()}) {
            ListItem() {
              UserInfoPageCell({title: '设置当前聊天背景'})
            }
          }
          ListItemGroup({footer: this.Gropfooter()}) {
            ListItem() {
              UserInfoPageCell({title: '清空聊天记录'})
            }
          }
          ListItemGroup({footer: this.Gropfooter()}) {
            ListItem() {
              UserInfoPageCell({title: '投诉'})
            }
          }
        }
        .scrollBarWidth(2.0)
        .edgeEffect(EdgeEffect.Spring, {alwaysEnabled: true})
        .height(Constants.SCREEN_HEIGHT - Constants.NAVI_HEIGHT)
        .backgroundColor($r('app.color.Color_237'))
      }
    }
    .hideTitleBar(true)
  }
}