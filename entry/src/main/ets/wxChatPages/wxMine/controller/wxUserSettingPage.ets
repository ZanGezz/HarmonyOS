import { ListDeleteCell } from '../../wxAddressBook/views/wxAddressCommonCell'
import { NaviPage } from '../../wxBase/NaviPage'
import { Constants } from '../../wxTools/Constants'
import { UserInfoPageCell, UserInfoPageHeadImageCell } from '../views/UserInfoPageCell'

@ComponentV2
export struct UserSettingPage {

  @Param @Require stack: NavPathStack = new NavPathStack()

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
          title: '设置',
          currentNavi: this.stack
        })
        // 列表
        List() {
          ListItemGroup({footer: this.Gropfooter()}) {
            ListItem() {
              UserInfoPageCell({title: '账号与安全'})
            }
          }
          ListItemGroup({footer: this.Gropfooter()}) {
            ListItem() {
              UserInfoPageCell({title: '青少年模式', addBottomLine: true})
            }
            ListItem() {
              UserInfoPageCell({title: '关怀模式'})
            }
          }
          ListItemGroup({footer: this.Gropfooter()}) {
            ListItem() {
              UserInfoPageCell({title: '消息通知', addBottomLine: true})
            }
            ListItem() {
              UserInfoPageCell({title: '通用'})
            }
          }
          ListItemGroup({footer: this.Gropfooter()}) {
            ListItem() {
              UserInfoPageCell({title: '朋友权限', addBottomLine: true})
            }
            ListItem() {
              UserInfoPageCell({title: '个人信息与权限', addBottomLine: true})
            }
            ListItem() {
              UserInfoPageCell({title: '个人信息收集清单', addBottomLine: true})
            }
            ListItem() {
              UserInfoPageCell({title: '第三方信息共享清单'})
            }
          }
          ListItemGroup({footer: this.Gropfooter()}) {
            ListItem() {
              UserInfoPageCell({title: '帮助与反馈', addBottomLine: true})
            }
            ListItem() {
              UserInfoPageCell({title: '关于微信'})
            }
          }
          ListItemGroup({footer: this.Listfooter()}) {
            ListItem() {
              ListDeleteCell({title: '切换账号',RowSelect: ()=>{
                this.stack?.pushPathByName('UserSwitchPage',[])
              }})
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