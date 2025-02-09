
import { wxAddressBookPage } from '../wxAddressBook/controller/wxAddressBookPage'
import { wxFindPage } from '../wxFind/controller/wxFindPage'
import { wxMinePage } from '../wxMine/controller/wxMinePage'
import { Constants } from '../wxTools/Constants'
import { TabBarData, TabPageModel } from './TabPageModel'
import  CommonInstance from '../wxTools/wxCommonInstance'
import { wxChatListPage } from '../wxChatList/controller/wxChatListPage'

@Entry
@ComponentV2
struct TabPage {
  // 记录当前tabIndex
  @Local currentIndex: number = 0

  // TabBar
  @Builder TabBar() {
    Row() {
      ForEach(TabBarData, (item: TabPageModel, index: number)=>{
        Column() {
          Image(this.currentIndex == item.index ? $r(item.selectImage) : $r(item.norImage))
            .width(25)
            .height(25)
            .objectFit(ImageFit.Contain)
          Text(item.title)
            .fontSize(10)
            .fontColor(this.currentIndex == item.index ? $r('app.color.Color_Tab_select') : $r('app.color.Color_31'))
            .margin({top:5})
        }
        .width(Constants.SCREEN_WIDTH/TabBarData.length)
        .margin({bottom: 24})
        .onClick((event)=>{
          this.currentIndex = index
        })
      })
    }
    .height(Constants.TAB_BAR_HEIGHT)
    .justifyContent(FlexAlign.SpaceAround)
    .width('100%')
    .backgroundColor($r('app.color.Color_246'))
  }
  /*
   * 搭建UI
   */
  build() {
    Stack() {
      ForEach(TabBarData,(item: TabPageModel)=>{
        if (item.index === 0) {
          Column() {
            wxChatListPage({TabBarSlot: this.TabBar.bind(this)})
          }
          .visibility(this.currentIndex === item.index ? Visibility.Visible : Visibility.Hidden)
        } else if (item.index === 1) {
          Column() {
            wxAddressBookPage({TabBarSlot: this.TabBar.bind(this)})
          }
          .visibility(this.currentIndex === item.index ? Visibility.Visible : Visibility.Hidden)
        } else if (item.index === 2) {
          Column() {
            wxFindPage({TabBarSlot: this.TabBar.bind(this)})
          }
          .visibility(this.currentIndex === item.index ? Visibility.Visible : Visibility.Hidden)
        } else if (item.index === 3) {
          Column() {
            wxMinePage({TabBarSlot: this.TabBar.bind(this)})
          }
          .visibility(this.currentIndex === item.index ? Visibility.Visible : Visibility.Hidden)
        }
      })
    }
    .onAppear(()=>{
      CommonInstance.TabbarComplete = true
    })
  }
}