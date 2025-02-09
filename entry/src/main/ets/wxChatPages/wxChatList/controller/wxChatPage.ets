
import {NaviPage} from '../../wxBase/NaviPage'
import { Constants } from '../../wxTools/Constants'
import Logger from  '../../wxTools/Logger'
import HMEmitter from  '../../wxTools/HMEmitter'
import CommonInstance, { PAGE_TYPE } from  '../../wxTools/wxCommonInstance'
import CommonHelper from  '../../wxTools/CommonHelper'
import DataManager from  '../request/ChatListDataManager'
import DataRDBStore, { TABLE_TYPE } from  '../../wxTools/DataRDBStore'
import { chat, room } from '../model/wxChatListModel'
import { ChatFriendCell } from '../views/wxChatFriendCell'
import { ChatTimeCell } from '../views/wxChatTimeCell'
import { ChatUserCell } from '../views/wxChatUserCell'

@ComponentV2
export struct wxChatPage {

  // 把导航传递过来
  @Param @Require stack: NavPathStack
  // 绑定List的 scroller
  private scroller: Scroller = new Scroller()
  // 是否显示导航头底线
  @Local showNaviBottomLine: boolean = false
  // 列表偏移
  @Local listTranslate: number = 0
  // 屏幕内最后一行index
  @Local listEndIndex: number = 0
  // 是否避让键盘
  @Local safeAreaForKeyboard: boolean = true
  // 聊天内容
  @Local chats: chat[] = []
  // 房间信息
  @Local userRoom :room = new room()
  // 聊天对象用户信息
  @Local partnerRoom: room = new room()
  // 输入框内容
  @Local inputContent: string = ''
  // 绑定输入框
  textInputController: TextInputController = new TextInputController()
  // 是否需要更新room
  private needUpdateChat: boolean = false
  // 是否是新创建的房间
  private isNewChatRoom: boolean = true
  // 页面出现 获取传递的数据
  aboutToAppear(): void {

    let array = this.stack!.getParamByName('wxChatPage')[0] as [room[], chat[], boolean]
    Logger.info('aadddbbb'+JSON.stringify(CommonInstance.crrentUserInfo))
    if (array.length > 1) {
      let roomArray: room[] = array[0]
      if (roomArray.length == 2) {
        let room = roomArray[0]
        if (room.user_id === CommonInstance.crrentUserInfo.user_id) {
          this.userRoom = room
          this.partnerRoom = roomArray[1]
        } else {
          this.userRoom = roomArray[1]
          this.partnerRoom = room
        }
      } else {
        let room = roomArray[0]
        this.userRoom = room
        this.partnerRoom = room
      }
      this.chats = array[1] as chat[]
      this.isNewChatRoom = array[2] as boolean
    }
    Logger.info('aadddbbb'+JSON.stringify(this.userRoom))
    Logger.info('aadddbbb'+JSON.stringify(this.partnerRoom))
    Logger.info('aboutToAppear1');
  }

  aboutToDisappear(): void {
    Logger.info('aboutToDisappear1');
  }

  // 滚动到底部
  scrollToBottom() {
    if (!this.scroller.isAtEnd()) {
      if (this.chats.length > 0) {
        this.scroller.scrollToIndex(this.chats.length-1)
      }
    }
  }

  // 返回事件
  backAction: ()=>void = () => {
    Logger.info(String(this.needUpdateChat))
    if (this.needUpdateChat) {
      this.needUpdateChat = false
      this.partnerRoom.isDelete = 0
      this.userRoom.isDelete = 0
      if (this.isNewChatRoom) {
        // 没有新聊天记录，创建room
        if (this.partnerRoom.user_id != this.userRoom.user_id) {
          DataManager.createChatRoom(this.partnerRoom, (isSuccess)=>{})
        }
        DataManager.createChatRoom(this.userRoom, (isSuccess) =>{
          if (isSuccess) {
            HMEmitter.emit(1,JSON.stringify([PAGE_TYPE.chat]))
          }
        })
        setTimeout(()=>{
          this.stack!.pop()
        },350)
      } else {
        // 有新聊天记录，更新
        if (this.partnerRoom.user_id != this.userRoom.user_id) {
          DataManager.updateChatRoom(this.partnerRoom, (isSuccess)=>{})
        }
        DataManager.updateChatRoom(this.userRoom, (isSuccess) =>{
          if (isSuccess) {
            HMEmitter.emit(1,JSON.stringify([PAGE_TYPE.chat]))
          }
        })
        setTimeout(()=>{
          this.stack!.pop()
        },350)
      }
    } else {
      setTimeout(()=>{
        this.stack!.pop()
      },350)
    }
  }

  // 设置List，偏移来躲避键盘
  setListTranslateY() {
    if (this.listTranslate < Constants.KEYBOARD_HEIGHT + 70) {
      let result = this.scroller.getItemRect(this.listEndIndex)
      let translateY = result.y+result.height + Constants.NAVI_HEIGHT + Constants.KEYBOARD_HEIGHT + 55 - Constants.SCREEN_HEIGHT
      if (translateY > 0) {
        this.listTranslate -= translateY
        if (-this.listTranslate > Constants.KEYBOARD_HEIGHT + 70 - Constants.NAVI_HEIGHT) {
          this.listTranslate = -Constants.KEYBOARD_HEIGHT - 70 + Constants.NAVI_HEIGHT
        }
      }
    }
  }
  // 发送消息
  sendChat() {
    let now = CommonHelper.getCurrentTimeinterval()
    if (this.chats.length == 0) {
      let timeChat: chat = {
        user_id: 101,
        room_id: this.userRoom.room_id,
        time: now
      }
      this.chats.push(timeChat)
      this.userRoom.total_chat = 0
      this.userRoom.unread = 0
      this.partnerRoom.total_chat = 0
      this.partnerRoom.unread = 0
      this.userRoom.total_chat! += 1
      this.partnerRoom.total_chat! += 1
      // 把chat存入数据库
      DataRDBStore.insertData<chat>(timeChat,TABLE_TYPE.Chat)
    } else if (this.chats.length > 0) {
      let lastChat = this.chats[this.chats.length - 1]
      let timeOffSet = (now - lastChat.time!) / 1000
      if (timeOffSet > 60) {
        let timeChat: chat = {
          user_id: 101,
          room_id: this.userRoom.room_id,
          time: now
        }
        this.chats.push(timeChat)
        this.userRoom.total_chat! += 1
        this.partnerRoom.total_chat! += 1
        // 把chat存入数据库
        DataRDBStore.insertData<chat>(timeChat,TABLE_TYPE.Chat)
      }
    }
    let chat: chat = {
      content: this.inputContent,
      room_id: this.userRoom.room_id,
      user_id: CommonInstance.crrentUserInfo.user_id,
      nick_name: CommonInstance.crrentUserInfo.nick_name,
      head_image: CommonInstance.crrentUserInfo.head_image,
      time: now+1
    }
    this.chats.push(chat)
    this.userRoom.total_chat! += 1
    this.partnerRoom.total_chat! += 1
    this.partnerRoom.unread! += 1
    this.userRoom.time = now+1
    this.partnerRoom.time = now+1
    this.userRoom.last_chat = this.inputContent
    this.partnerRoom.last_chat = this.inputContent
    this.needUpdateChat = true
    // 把chat存入数据库
    DataRDBStore.insertData<chat>(chat,TABLE_TYPE.Chat)
    // 设置List偏移，躲避键盘
    this.setListTranslateY()
    // 滚动到底部
    setTimeout(()=>{
      this.scrollToBottom()
    },200)
    // 清空输入框
    this.inputContent = ''
  }

  @Builder chatInputView() {
    Column() {
      Row() {
        Image($r('app.media.yuyin'))
          .height(28)
          .width(28)
        TextInput({controller: this.textInputController, text: this.inputContent})
          .placeholderColor($r('app.color.Color_179'))
          .placeholderFont({size: 16})
          .fontColor($r('app.color.Color_31'))
          .backgroundColor($r('app.color.wxWhiteColor'))
          .width(Constants.SCREEN_WIDTH - 135)
          .height(40)
          .borderRadius(4)
          .margin({left: 10})
          .enterKeyType(EnterKeyType.Send)
          .onSubmit((enterKey: EnterKeyType, event: SubmitEvent) => {
            // 完成按钮事件
            this.sendChat()
            // 保持键盘，不让收回
            event.keepEditableState()
          })
          .onEditChange((isEditing: boolean) => {
            // 滚动到底部
            if (isEditing) {
              this.scrollToBottom()
            }
            // 编辑状态改变, 设置List偏移，躲避键盘
            animateTo({duration: 450},()=>{
              if (isEditing) {
                this.setListTranslateY()
              } else {
                this.listTranslate = 0
              }
            })
          })
          .onChange((value: string) => {
            // 输入内容发生变化
            this.inputContent = value
          })
        Image($r('app.media.biaoqing'))
          .height(28)
          .width(28)
          .margin({left: 10})
        Blank()
        Image($r('app.media.icon_more'))
          .height(26)
          .width(26)
      }
      .width('100%')
      .height(54)
      .backgroundColor($r('app.color.Color_246'))
      .padding({top: 6, bottom: 6, left: 10, right: 10})

      Row().height(30).width('100%').backgroundColor($r('app.color.Color_246'))
    }
  }

  // 右边按钮
  @Builder rightButton() {
    Image($r('app.media.gengduo'))
      .width(20)
      .height(20)
      .margin({ right: 15 })
      .onClick((event)=>{
        this.stack.pushPathByName('wxChatInfoPage', this.userRoom)
      })
  }

  // UI
  build() {
    NavDestination() {
      Stack() {
        Column(){
          List({scroller: this.scroller}) {
            ForEach(this.chats, (chat: chat, index: number) => {
              ListItem() {
                if (chat.user_id === this.userRoom.user_id) {
                  ChatUserCell({chat: chat})
                } else if (chat.user_id === this.partnerRoom.user_id) {
                  ChatFriendCell({chat: chat})
                } else {
                  ChatTimeCell({time: chat.time})
                }
              }
            })
          }
          .scrollBarWidth(2.0)
          .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
            if (this.scroller.currentOffset().yOffset > 0.2) {
              this.showNaviBottomLine = true
            } else {
              this.showNaviBottomLine = false
            }
          })
          .onScrollIndex((start: number, end: number, center: number) => {
            this.listEndIndex = end
            Logger.info('start+'+String(start)+'+end+'+String(end))
          })
          .onAppear(()=>{
            // 滚动到底部
            this.scrollToBottom()
          })
          .expandSafeArea([SafeAreaType.KEYBOARD], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          .edgeEffect(EdgeEffect.Spring, {alwaysEnabled: true})
          .backgroundColor($r('app.color.Color_237'))
          .height(Constants.CONTENT_HEIGHT)
          .translate({y: this.listTranslate})
          // 输入框
          this.chatInputView()
        }
        .margin({top: Constants.NAVI_HEIGHT})
        .backgroundColor($r('app.color.Color_237'))
        .onClick((event) => {
          this.textInputController.stopEditing()
        })
        // 导航头
        NaviPage({
          title: this.userRoom.nick_name,
          showBackButton: Visibility.Visible,
          currentNavi: this.stack,
          showBottomLine: this.showNaviBottomLine,
          backAction: this.backAction,
          rightButton: this.rightButton.bind(this)
        })
      }
      .alignContent(Alignment.Top)
    }
    .hideTitleBar(true)
  }
}