import { NaviPage } from '../../wxBase/NaviPage'
import { Constants, Strings } from '../../wxTools/Constants'
import { userInfoModel } from '../model/wxUserInfoModel'
import { UserSwitchPageCell } from '../views/UserSwitchPageCell'
import PreferenceHelper from '../../wxTools/PreferenceHelper'
import DataManager from '../../wxMine/UserDataManager/UserDataManager'
import CommonInstance, { PAGE_TYPE } from '../../wxTools/wxCommonInstance'
import HMEmitter from '../../wxTools/HMEmitter'

@ComponentV2
export struct UserSwitchPage {

  @Param @Require stack: NavPathStack
  @Param @Once users: userInfoModel[] = []

  // 页面出现，获取数据
  aboutToAppear(): void {
    DataManager.queryUsers((result) => {
      for (let i = 0; i < result.length; i ++) {
        let user: userInfoModel = result[i]
        if (user.nick_name != '文件传输助手' && user.nick_name != '微信团队') {
          this.users.push(user)
        }
      }
    })
  }
  switchUser(user: userInfoModel) {
    PreferenceHelper.save(Strings.USER_ID, user.user_id!)
    CommonInstance.crrentUserInfo = user
    HMEmitter.emit(1,JSON.stringify([PAGE_TYPE.chat, PAGE_TYPE.find, PAGE_TYPE.mine]))
    setTimeout(()=>{
      this.stack.popToIndex(-1)
    },350)
  }
  // UI
  build() {
    NavDestination() {
      Column() {
        NaviPage({
          title: '用户列表',
          currentNavi: this.stack
        })
        // 列表
        List() {
          ForEach(this.users, (user: userInfoModel, index: number) => {
            if (user.user_id != CommonInstance.crrentUserInfo.user_id) {
              ListItem() {
                UserSwitchPageCell({user: user})
                  .onClick((event) => {
                    this.switchUser(user)
                  })
              }
            }
          })
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