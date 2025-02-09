
import { NaviPage } from '../../wxBase/NaviPage'
import { PushToPage } from '../../wxBase/PushToPage'
import { Constants } from '../../wxTools/Constants'
import Alert from '../../wxComponents/wxAlert/Alert'
import Logger from  '../../wxTools/Logger'
import { userInfoModel } from '../../wxMine/model/wxUserInfoModel'
import { AddressBookListModel, AddressBookCommonData, chars } from '../model/wxAddressBookModel'
import { wxAddressBookListCell } from '../views/wxAddressBookListCell'
import { Toast_unOpen } from '../../wxComponents/wxAlert/AlertOptions'
import CommonInstance, { PAGE_TYPE } from  '../../wxTools/wxCommonInstance'
import HMEmitter from  '../../wxTools/HMEmitter'
import DataManager from  '../request/AddressDataManager'
import { AlphabetIndexView } from '../../wxComponents/AlphabetIndex/AlphabetIndexView'

@ComponentV2
export struct wxAddressBookPage {

  @Local title: string = '通讯录'
  // 导航管理器
  @Local addressBookStack: NavPathStack = new NavPathStack()
  // 用户列表数据
  @Local addressBookData: AddressBookListModel[] = []
  // scroller
  @Local scroller: ListScroller = new ListScroller()
  // TabBar插槽
  @BuilderParam TabBarSlot: ()=>void

  // Alphabet '☆'
  @Local AlphabetValue: string[] = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T','#']
  @Local AlphabetSelectIndex: number = -1
  @Local AlphabetSelectMargeBottom: number = 0

  // push 跳转页面
  @Builder PushToPageBuilder(name: string) {
    PushToPage({desNaviPageName: name, stack: this.addressBookStack})
  }

  // 右边按钮
  @Builder rightButton() {
    Image($r(`app.media.tianjiahaoyou`))
      .width(24)
      .height(24)
      .margin(15)
      .onClick((event)=>{
        this.addressBookStack.pushPath({name: 'wxAddFriendsPage', param: [], onPop: (popInfo: PopInfo)=>{
          Logger.info('右边按钮点击事件通讯录popInfo');
          // 更新数据 滚动到最顶端
          this.scroller.scrollTo({xOffset: 0, yOffset: 0})
        }});
        Logger.info('右边按钮点击事件通讯录');
      })
  }

  // 搜索框
  @Builder SearchHeader() {
    Column(){
      Row()
        .width('100%')
        .height(400)
        .backgroundColor($r('app.color.Color_237'))
      Column() {
        Row() {
          Image($r('app.media.sousuo'))
            .width(16)
            .height(16)
            .objectFit(ImageFit.Fill)
            .margin({right:7})
          Text('搜索')
            .fontSize(16)
            .fontColor("rgb(130,130,130)")
            .margin({left:7})
        }
        .height(38)
      }
      .width(Constants.SCREEN_WIDTH - 16)
      .backgroundColor($r('app.color.wxWhiteColor'))
      .borderRadius(6.0)
      .onClick((event) => {
        // 搜索点击事件
        Logger.info('搜索点击事件')
      })
    }
    .width('100%')
    .height(454)
    .backgroundColor($r('app.color.Color_237'))
    .margin({top: -400})
  }

  // 组头
  @Builder groupHeader(content: string) {
    Row(){
      Text(content)
        .fontSize(14)
        .fontWeight(400)
        .fontColor($r('app.color.Color_31'))
        .margin({left: 17})
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height(20)
  }

  // 组脚
  @Builder groupFooter() {
    Row()
      .height(20)
      .width('100%')
      .backgroundColor($r('app.color.wxWhiteColor'))
  }

  // List swipe end
  @Builder ListItemEnd() {
    Row() {
      Text('备注')
        .fontColor($r('app.color.wxWhiteColor'))
        .backgroundColor($r('app.color.Color_77'))
        .width(80)
        .height(55)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .onClick(()=>{
          this.scroller.closeAllSwipeActions()
          Alert.showDialog(this.getUIContext(),Toast_unOpen)
        })
    }
  }

  // UI
  build() {
    Navigation(this.addressBookStack) {
      Stack() {
        Column() {
          // 导航头
          NaviPage({
            currentNavi: this.addressBookStack,
            title: this.title,
            showBackButton: Visibility.Hidden,
            rightButton: ()=>{this.rightButton()},
          })

          // 用户列表
          List({scroller: this.scroller}) {
            ListItemGroup({header: this.SearchHeader(), footer: this.groupFooter()}) {
              ForEach(AddressBookCommonData,(user_info: userInfoModel, index: number)=>{
                ListItem() {
                  wxAddressBookListCell({item: user_info, selectRow: ()=>{
                    // 点击了cell
                    Logger.info('点击了cell')
                    Alert.showDialog(this.getUIContext(),Toast_unOpen)
                  }})
                }
              })
            }
            ForEach(this.addressBookData, (item: AddressBookListModel, group: number) => {
              ListItemGroup({header: this.groupHeader(item.first_latter), footer: this.groupFooter()}) {
                ForEach(item.user_list, (user_info: userInfoModel, row: number) => {
                  ListItem() {
                    wxAddressBookListCell({item: user_info, selectRow: ()=>{
                      // 点击了cell
                      if (user_info.nick_name === '微信团队') {
                        Alert.showDialog(this.getUIContext(),Toast_unOpen)
                      } else {
                        this.addressBookStack.pushPath({name: 'AddressUserInfoPage', param: user_info})
                      }
                    }})
                  }
                  .swipeAction({
                    edgeEffect: SwipeEdgeEffect.None,
                    end: {
                      actionAreaDistance: 0,
                      builder: this.ListItemEnd()
                    }
                  })
                })
              }
            })
          }
          .onScrollIndex((start: number, end: number, center: number) =>{
            this.AlphabetSelectIndex = start - 1
          })
          .height(Constants.CONTENT_HEIGHT)
          .edgeEffect(EdgeEffect.Spring,{alwaysEnabled: true})
          .sticky(StickyStyle.Header)
        }
        .height('100%')

        AlphabetIndexView({alphaData: this.AlphabetValue, selectIndex: this.AlphabetSelectIndex , selectItem: (index: number)=>{
          this.AlphabetSelectIndex = index
          this.scroller.scrollToItemInGroup(index+1, 0)
        }}).margin({bottom: this.AlphabetSelectMargeBottom, right: 10})

        // TabBar插槽
        this.TabBarSlot()
      }
      .alignContent(Alignment.BottomEnd)
    }
    .navDestination(this.PushToPageBuilder)
    .hideTitleBar(true)
  }


  // 获取addressBook页面数据
  getAddressBookData() {
    DataManager.queryAddressData((result)=>{
      this.addressBookData = result[0]
      this.AlphabetValue = result[1]
      this.AlphabetSelectMargeBottom = (Constants.SCREEN_HEIGHT - (this.AlphabetValue.length *16 + 40))/2
      Logger.info('addressBookData')
    })
  }

  aboutToAppear(): void {
    Logger.info('aboutToAppear_tabpage')
    // 获取通讯录数据
    this.getAddressBookData()
    // 注册刷新通讯录数据方法
    HMEmitter.on(1,(param: string)=>{
      let types: PAGE_TYPE[] = JSON.parse(param)
      for (let i = 0; i < types.length; i ++) {
        let type = types[i]
        if (type == PAGE_TYPE.address) {
          // 获取微信页面数据
          this.getAddressBookData()
        }
      }
    })
  }
}