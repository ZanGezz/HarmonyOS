
import { NaviPage } from '../../wxBase/NaviPage'
import { wxChatListCell } from '../views/wxChatListCell'
import { ChatListMenu, ChatListMenuCell, ChatListMenuData } from '../views/wxChatListMenuCell'
import { room } from '../model/wxChatListModel'
import { Constants, Strings } from '../../wxTools/Constants'
import Logger from  '../../wxTools/Logger'
import { PAGE_TYPE } from  '../../wxTools/wxCommonInstance'
import PreferenceHelper from  '../../wxTools/PreferenceHelper'
import CommonHelper from  '../../wxTools/CommonHelper'
import DataManager from  '../request/ChatListDataManager'
import { PushToPage } from '../../wxBase/PushToPage'
import Alert from '../../wxComponents/wxAlert/Alert'
import { GIF, Loading, MomentDelete, Toast, Toast_unOpen } from '../../wxComponents/wxAlert/AlertOptions'
import { BaseIDataSource } from '../../wxBase/BaseIDataSource'
import HMEmitter from '../../wxTools/HMEmitter'
import { SearchPage } from './wxSearchPage'


@ComponentV2
export struct wxChatListPage {

  // 导航管理器
  @Local chatListStack: NavPathStack = new NavPathStack()
  // TabBar插槽
  @BuilderParam TabBarSlot: ()=>void
  // 聊天列表
  @Local ChatListData: BaseIDataSource<room> = new BaseIDataSource<room>()
  // 置顶列表
  @Local ChatListHeadData: BaseIDataSource<room> = new BaseIDataSource<room>()
  // 置顶是否显示
  @Local showHeadData: boolean = false
  @Local HeadDataCount: number = 0
  // 置顶Menu是否显示
  @Local HeadMenuShow: boolean = false
  // 导航头margin
  @Local headTop: number = 0
  // List contentOffSet
  @Local contentOffSet: number = 0
  // List 绑定 Scroller
  @Local scroller: ListScroller = new ListScroller()
  // 置顶折叠图标
  @Local headChatMore: string = 'app.media.xiajiantou'
  // 置顶是否折叠
  @Local headShow: boolean = false
  // 搜索是否显示
  @Local searchShow: boolean = false
  // 点击聊天room
  didSelectRoom(item: room) {
    Logger.info(JSON.stringify(item))
    // 跳转去聊天列表
    if (item.type === 1) {
      // 文件传入助手
      this.enterChatRoom(item)
    } else if (item.type === 2) {
      // 微信运动
      Alert.showDialog(this.getUIContext(), Toast_unOpen)
    } else if (item.type === 3) {
      // 订阅号
      Alert.showDialog(this.getUIContext(), Toast_unOpen)
    } else if (item.type === 4) {
      // 微信团队
      Alert.showDialog(this.getUIContext(), Toast_unOpen)
    } else if (item.type === 0) {
      // 好友聊天
      this.enterChatRoom(item)
    }
  }
  // 去聊天页面
  enterChatRoom(room: room) {

    DataManager.quaryChatRoomWithRoomId(room, (hasRoom: boolean, rooms: room[]) => {
      if (hasRoom) {
        DataManager.queryChatData(room, (chats)=>{
          // 标记为已读
          if (room.unread != 0) {
            room.unread = 0
            DataManager.updateChatRoom(room, (isSuccess)=>{
              // 跳转
              this.chatListStack!.pushPathByName('wxChatPage',[rooms, chats, false])
            })
          } else {
            // 跳转
            this.chatListStack!.pushPathByName('wxChatPage',[rooms, chats, false])
          }
        })
      }
    })
  }

  // 删除聊天房间
  deletChatRoom(room: room) {
    room.last_delete_time = CommonHelper.getCurrentTimeinterval()
    room.isDelete = 1
    DataManager.updateChatRoom(room, (success)=>{
      animateTo({duration: 150, curve: Curve.Linear},()=>{
        this.ChatListData.pop(room)
      })
    })
  }

  // push 跳转页面
  @Builder PushToPageBuilder(name: string) {
    PushToPage({desNaviPageName: name, stack: this.chatListStack})
  }

  // 右边按钮
  @Builder rightButton() {
    Image($r('app.media.icon_more'))
      .width(20)
      .height(20)
      .margin({ right: 20 })
      .bindPopup(this.HeadMenuShow, {
        builder: this.HeadMenu(),
        onWillDismiss: () => {
          this.HeadMenuShow = false
        },
        radius: 6,
        popupColor: $r('app.color.Color_77'),
        backgroundBlurStyle: BlurStyle.NONE
      })
      .onClick((event)=>{
        this.HeadMenuShow = true
        Logger.info('右边按钮点击事件首页');
      })
  }

  // 头部Menu
  @Builder HeadMenu() {
    Column() {
      Menu() {
        ForEach(ChatListMenuData, (item: ChatListMenu, index: number) => {
          MenuItem() {
            ChatListMenuCell({image: item.image, title: item.title})
          }
          .onClick(()=>{
            this.HeadMenuShow = false
            if (item.title === '切换用户') {
              this.chatListStack.pushPathByName('UserSwitchPage', [])
            } else if (item.title === '添加朋友') {
              this.chatListStack.pushPathByName('wxAddFriendsPage', [])
            }  else {
              Alert.showDialog(this.getUIContext(),{content: `暂未开启${item.title}功能`})
            }
          })
        })
      }
      .radius(6)
      .width(150)
      .backgroundColor($r('app.color.Color_77'))
    }
    .alignItems(HorizontalAlign.End)
  }

  // List swipe end
  @Builder ListItemEnd(room: room) {
    Row() {
      Text('标记已读')
        .fontColor($r('app.color.wxWhiteColor'))
        .backgroundColor($r('app.color.Color_57_133_230'))
        .width(95)
        .height(74)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .onClick(()=>{
          this.scroller.closeAllSwipeActions()
          Alert.showDialog(this.getUIContext(),Toast_unOpen)
        })
      Text('不显示')
        .fontColor($r('app.color.wxWhiteColor'))
        .backgroundColor($r('app.color.Color_237_159_80'))
        .width(80)
        .height(74)
        .fontSize(15)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
        .onClick(()=>{
          this.scroller.closeAllSwipeActions()
          Alert.showDialog(this.getUIContext(),Toast_unOpen)
        })
      Text('删除')
        .width(80)
        .fontSize(15)
        .height(74)
        .textAlign(TextAlign.Center)
        .fontWeight(FontWeight.Bold)
        .backgroundColor($r('app.color.Color_230_94_87'))
        .fontColor($r('app.color.wxWhiteColor'))
        .onClick(()=>{
          this.scroller.closeAllSwipeActions()
          this.deletChatRoom(room)
        })
    }
  }
  // List 组头
  @Builder ListGroupHeader() {
    Column(){
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
        this.searchShow = true
        Logger.info('搜索点击事件')
      })
    }
    .width('100%')
    .height(55)
    .backgroundColor($r('app.color.Color_237'))
  }
  // ListGroupFooter
  @Builder ListGroupFooter() {
    Column() {
      if (this.showHeadData) {
        Row(){
          Image($r('app.media.liebiao'))
            .width(20)
            .height(14)
            .objectFit(ImageFit.Fill)
            .margin({left: 16})

          Text(String(this.HeadDataCount)+'个置顶聊天')
            .fontSize(14)
            .fontColor($r('app.color.Color_139'))
            .textAlign(TextAlign.Start)
            .margin({left:15})

          Blank()

          Image($r(this.headChatMore))
            .width(20)
            .height(20)
            .margin({right:15})
        }
        .height(40)
        .backgroundColor($r('app.color.Color_237'))
        .width('100%')
        .onClick((event)=>{
          // 是否滚动到搜索框上
          if (this.contentOffSet >=55) {
            this.scroller.scrollTo({xOffset: 0, yOffset: 55})
          } else {
            this.scroller.scrollTo({xOffset: 0, yOffset: 0})
          }
          // 动画收起置顶组
          animateTo({
            duration: 150,
            curve: Curve.Linear,
          }, () => {
            if (this.headShow) {
              this.headChatMore = 'app.media.xiajiantou'
            } else {
              this.headChatMore = 'app.media.shangjiantou'
            }
            this.headShow = !this.headShow
          })
        })
        Divider().width('100%').height(0.5).backgroundColor('rgb(230,230,230)')
      }
    }
  }
  /*
   * UI搭建
   */
  build() {
    Navigation(this.chatListStack) {
      Column() {
        Stack() {
          // 导航头
          NaviPage({
            currentNavi: this.chatListStack,
            title: '微信',
            showBackButton: Visibility.Hidden,
            rightButton: this.rightButton.bind(this),
          }).margin({ top: this.headTop }).zIndex(100)
          // 遮盖层
          Row()
            .height(this.headTop + Constants.NAVI_HEIGHT)
            .width('100%')
            .backgroundColor($r('app.color.Color_237'))
            .zIndex(50)

          // 聊天列表
          List({ scroller: this.scroller }) {
            // 搜索列表
            ListItemGroup({ header: this.ListGroupHeader()})
            // 置顶列表
            ListItemGroup({footer:this.ListGroupFooter()}) {
              if (this.headShow) {
                LazyForEach(this.ChatListHeadData, (item: room, index: number) => {
                  ListItem() {
                    wxChatListCell({item: item, itemBackGroundColor: 'app.color.Color_237', seleted: (result) =>{
                      // 跳转去聊天列表
                      this.didSelectRoom(item)
                    }})
                  }
                  .swipeAction({
                    edgeEffect: SwipeEdgeEffect.None,
                    end: {
                      actionAreaDistance: 0,
                      builder: this.ListItemEnd(item),
                    }
                  })
                }, (item: room, index: number) => {return JSON.stringify(item)+index.toString()})
              }
            }

            // 普通列表
            ListItemGroup() {
              LazyForEach(this.ChatListData, (item: room, index: number) => {
                ListItem() {
                  wxChatListCell({ item: item, seleted: (result)=>{
                    // 跳转去聊天列表
                    this.didSelectRoom(item)
                  }})
                }
                .swipeAction({
                  edgeEffect: SwipeEdgeEffect.None,
                  end: {
                    actionAreaDistance: 0,
                    builder: this.ListItemEnd(item),
                  }
                })
              },(item: room, index: number) => {return JSON.stringify(item)+index.toString()})
            }
          }
          .scrollBarWidth(2.0)
          .cachedCount(3)
          .backgroundColor($r('app.color.Color_237'))
          .height(Constants.CONTENT_HEIGHT)
          .margin({ top: Constants.NAVI_HEIGHT })
          .sticky(StickyStyle.Footer) // 设置header和footer悬停
          .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
            this.contentOffSet += scrollOffset
            this.headTop = -this.contentOffSet
            if (this.contentOffSet > 0) {
              this.headTop = 0
            }
          })

          if (this.searchShow) {
            SearchPage({onDismiss: ()=>{
              this.searchShow = false
            }})
              .zIndex(1000)
              .height('100%')
          }

        }.alignContent(Alignment.Top)
        // TabBar 插槽
        this.TabBarSlot()
      }
      .height('100%')
      .backgroundColor($r('app.color.wxWhiteColor'))
    }
    .hideTitleBar(true)
    .navDestination(this.PushToPageBuilder)
  }


  // 获取微信页面数据
  getChatData(loadMore: boolean = false) {

    if (!loadMore) {
      this.ChatListData.popAll()
      this.ChatListHeadData.popAll()
    }

    let user_id = PreferenceHelper.quary(Strings.USER_ID) as number
    DataManager.queryChatListData(user_id, (result)=>{
      for (let i = 0; i < result.length; i ++) {
        let param: room = new room(result[i])
        Logger.info('queryChatListData: '+JSON.stringify(param))
        this.ChatListData.push(param)
      }
    })
    DataManager.queryChatListData(user_id,(result)=>{

      for (let i = 0; i < result.length; i ++) {
        let param: room = new room(result[i])
        this.ChatListHeadData.push(param)
      }
      this.HeadDataCount = this.ChatListHeadData.totalCount()
      this.showHeadData = result.length > 0 ? true : false
    },1)
  }

  // 页面出现
  aboutToAppear(): void {
    // 获取首页列表数据
    this.getChatData()
    HMEmitter.on(1, (param: string)=>{
      Logger.info('11111111')
      let types: PAGE_TYPE[] = JSON.parse(param)
      // 获取首页列表数据
      for (let i = 0; i < types.length; i ++) {
        let type = types[i]
        if (type == PAGE_TYPE.chat) {
          // 获取微信页面数据
          this.getChatData()
        }
      }
    })
    Logger.info('updateUserInfo1')
  }
}



// 给组件扩展方法
// @Extend(Row)
// @Extend(Image)
// @Extend(Column)
// function onDbClick(event1: (event: ClickEvent)=>void) {
//   .onClick((event)=>{
//     Deb(()=>{
//       event1(event)
//     })
//   })
// }

// 监听事件
// aboutToAppear(): void {
//   let observer: UIObserver = this.getUIContext().getUIObserver();
//   let callback = (event: ClickEvent, frameNode?: FrameNode) => {
//     Logger.info('onclick')
//   };
//   observer.on('willClick',callback)
// }
