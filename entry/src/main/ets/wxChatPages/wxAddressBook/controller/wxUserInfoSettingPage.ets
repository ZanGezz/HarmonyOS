import { NaviPage } from '../../wxBase/NaviPage'
import { Constants, Strings } from '../../wxTools/Constants'
import Logger from '../../wxTools/Logger'
import PreferenceHelper from '../../wxTools/PreferenceHelper'
import HMEmitter from '../../wxTools/HMEmitter'
import CommonInstance, { PAGE_TYPE } from '../../wxTools/wxCommonInstance'
import { userInfoModel } from '../../wxMine/model/wxUserInfoModel'
import { ListCommonCell, ListSwitchCell, ListDeleteCell } from '../views/wxAddressCommonCell'
import UserInfoManager from '../../wxMine/UserDataManager/UserDataManager'

@ComponentV2
export struct UserInfoSettingPage {

  @Param @Require stack: NavPathStack
  @Local userInfo: userInfoModel = new userInfoModel()

  // 页面即将出现
  aboutToAppear(): void {
    this.userInfo = this.stack!.getParamByName('UserInfoSettingPage')[0] as userInfoModel
  }
  // 切换为该用户
  switchUser() {
    PreferenceHelper.save(Strings.USER_ID, this.userInfo.user_id!)
    CommonInstance.crrentUserInfo = this.userInfo
    HMEmitter.emit(1,JSON.stringify([PAGE_TYPE.chat, PAGE_TYPE.find, PAGE_TYPE.mine]))
    setTimeout(()=>{
      this.stack.popToIndex(-1)
    },200)
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
          currentNavi: this.stack!,
          title: '资料设置'
        })
        // 列表
        List() {
          // 第一组
          ListItemGroup({footer: this.Footer()}) {
            ListItem() {
              ListCommonCell({title: '设置备注和标签'})
            }
            ListItem() {
              ListCommonCell({title: '朋友权限',showBottomLine: false})
            }
          }
          // 第二组
          ListItemGroup({footer: this.Footer()}) {
            ListItem() {
              ListCommonCell({title: '把他推荐给朋友',showBottomLine: false})
            }
          }
          // 第三组
          ListItemGroup({footer: this.Footer()}) {
            ListItem() {
              ListSwitchCell({title: '设为星标朋友'})
            }
          }
          // 第四组
          ListItemGroup({footer: this.Footer()}) {
            ListItem() {
              ListSwitchCell({title: '加入黑名单'})
            }
            ListItem() {
              ListCommonCell({title: '投诉',showBottomLine: false})
            }
          }
          // 第五组
          ListItemGroup({footer: this.Footer()}) {
            ListItem() {
              ListDeleteCell({title: '删除联系人', RowSelect: () => {
                // 删除联系人
                UserInfoManager.deleteUser(this.userInfo.user_id!, (success)=>{
                  HMEmitter.emit(1, JSON.stringify([PAGE_TYPE.chat, PAGE_TYPE.find, PAGE_TYPE.address]))
                  setTimeout(()=>{
                    this.stack.popToIndex(-1)
                  },200)
                })
              }})
            }
          }
          // 第六组
          ListItemGroup({footer: this.Footer()}) {
            ListItem() {
              ListDeleteCell({title: '切换为当前用户', RowSelect: () => {
                // 切换为当前用户
                this.switchUser()
              }})
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