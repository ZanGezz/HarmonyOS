
import { wxChatListPage } from '../wxChatList/controller/wxChatListPage'
import { wxAddressBookPage } from '../wxAddressBook/controller/wxAddressBookPage'
import { wxFindPage } from '../wxFind/controller/wxFindPage'
import { wxMinePage } from '../wxMine/controller/wxMinePage'
import { Constants } from '../wxTools/Constants'
import { PushToPage } from '../wxBase/PushToPage'
import CommonInstance from '../wxTools/wxCommonInstance'
import Logger from '../wxTools/Logger'

@Entry
@ComponentV2
struct wxTabPage {

  @Local currentIndex: number = 0
  private controller: TabsController = new TabsController()
  @Local TabPageNavi: NavPathStack = new NavPathStack()


  /*
   * 搭建UI
   */
  build() {
    Stack() {
      Navigation(this.TabPageNavi) {
        Stack() {
          Tabs({barPosition: BarPosition.End, controller: this.controller}) {
            // 首页
            TabContent() {
              wxChatListPage()
            }
            .tabBar(this.customBar(0,'微信',$r('app.media.wechat'),$r('app.media.wechat_select')))
            // 通讯录
            TabContent() {
              wxAddressBookPage()
            }
            .tabBar(this.customBar(1,'通讯录',$r('app.media.contacts'),$r('app.media.contacts_select')))
            // 发现
            TabContent() {
              wxFindPage()
            }
            .tabBar(this.customBar(2,'发现',$r('app.media.discover_normal'),$r('app.media.discover_select')))
            // 我的
            TabContent() {
              wxMinePage()
            }
            .tabBar(this.customBar(3,'我的',$r('app.media.mine'),$r('app.media.mine_select')))
          }
          .animationDuration(0)
          .scrollable(false)
          .onChange(index => {
            this.currentIndex = index
          })
          .barHeight(Constants.TAB_BAR_HEIGHT)
          .barBackgroundColor($r('app.color.Color_246'))

          wxChatListPage().zIndex(100)
        }

      }
      .hideTitleBar(true)
      .navDestination(this.chatPageBuilder)
    }
  }

  /*
  * 自定义底部TabBar
  */
  @Builder customBar(index: number, title: string, norImage: Resource, selImage: Resource) {
    Column() {
      Image(this.currentIndex == index ? selImage : norImage)
        .width(25)
        .height(25)
        .objectFit(ImageFit.Contain)
      Text(title)
        .fontSize(10)
        .fontColor(this.currentIndex == index ? $r('app.color.Color_Tab_select') : $r('app.color.Color_31'))
        .margin({top:5})
    }.margin({bottom: 24})
  }

  // push 跳转页面
  @Builder
  chatPageBuilder(name: string) {
    //PushToPage({desNaviPageName: name})
  }
}