
import { wxChatPage } from '../wxChatList/controller/wxChatPage'
import { FriendsCircle } from '../wxFind/controller/wxFriendsCirclePage'
import { wxAddFriendsPage } from '../wxAddressBook/controller/wxAddFriendsPage'
import { AddressUserInfoPage } from '../wxAddressBook/controller/wxAddressUserInfoPage'
import { UserInfoSettingPage } from '../wxAddressBook/controller/wxUserInfoSettingPage'
import { UserInfoPage } from '../wxMine/controller/wxUserInfoPage'
import { UserSwitchPage } from '../wxMine/controller/wxUserSwitchPage'
import { WebviewPage } from '../wxFind/controller/wxWebviewPage'
import { UserInfoMorePage } from '../wxMine/controller/wxUserInfoMorePage'
import { ChangeUserInfoPage } from '../wxMine/controller/wxChangeUserInfoPage'
import { UserSettingPage } from '../wxMine/controller/wxUserSettingPage'
import { wxChatInfoPage } from '../wxChatList/controller/wxChatInfoPage'

@ComponentV2
export struct PushToPage {

  @Param @Require stack: NavPathStack
  @Param @Require desNaviPageName: string = ''

  build() {
    if (this.desNaviPageName == 'wxChatPage') {
      // 跳转到聊天窗口
      wxChatPage({stack: this.stack})
    } else if (this.desNaviPageName == 'FriendsCircle') {
      // 朋友圈
      FriendsCircle({stack: this.stack})
    } else if (this.desNaviPageName == 'wxAddFriendsPage') {
      // 添加好友
      wxAddFriendsPage({stack: this.stack})
    } else if (this.desNaviPageName == 'AddressUserInfoPage') {
      // 好友信息页面
      AddressUserInfoPage({stack: this.stack})
    } else if (this.desNaviPageName == 'UserInfoSettingPage') {
      // 好友设置
      UserInfoSettingPage({stack: this.stack})
    } else if (this.desNaviPageName == 'UserInfoPage') {
      // 用户详情页
      UserInfoPage({stack: this.stack})
    } else if (this.desNaviPageName == 'UserSwitchPage') {
      // 切换用户
      UserSwitchPage({stack: this.stack})
    } else if (this.desNaviPageName == 'WebviewPage') {
      // webview
      WebviewPage({stack: this.stack})
    } else if (this.desNaviPageName == 'UserSettingPage') {
      // 个人设置
      UserSettingPage({stack: this.stack})
    } else if (this.desNaviPageName == 'UserInfoMorePage') {
      // 用户信息更多
      UserInfoMorePage({stack: this.stack})
    } else if (this.desNaviPageName == 'ChangeUserInfoPage') {
      // 用户信息修改
      ChangeUserInfoPage({stack: this.stack})
    } else if (this.desNaviPageName == 'wxChatInfoPage') {
      // 聊天详情
      wxChatInfoPage({stack: this.stack})
    }
  }
}