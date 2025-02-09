
import { FriendCircleListTICell } from '../views/FriendCircleListTICell'
import { FriendCircleListHeader } from '../views/FriendCircleListHeader'
import { ImageToLarge } from '../views/ImageToLargeView'
import Logger from  '../../wxTools/Logger'
import { CircleImageModel, CircleListModel, CirclePingModel, CircleZanModel } from '../model/FriendCircleListModel'
import { CircleAlertType, CircleAlertSheet } from '../views/CircleAlertSheetPage'
import { Constants, Strings } from '../../wxTools/Constants'
import PreferenceHelper from '../../wxTools/PreferenceHelper'
import CommonInstance, { PAGE_TYPE } from '../../wxTools/wxCommonInstance'
import DataManager from '../CircleRequest/CircleDataManager'
import UserDataManager from '../../wxMine/UserDataManager/UserDataManager'
import CommonHelper from '../../wxTools/CommonHelper'
import HMEmitter from '../../wxTools/HMEmitter'
import { PostMomentsPage } from './PostMomentsPage'
import { alertItem, alerts, deletes } from '../model/FindPageListModel'
import { componentUtils } from '@kit.ArkUI'
import { BaseIDataSource } from '../../wxBase/BaseIDataSource'
import Alert from '../../wxComponents/wxAlert/Alert'
import { AlertType } from '../../wxComponents/wxAlert/AlertTypes'
import { userInfoModel } from '../../wxMine/model/wxUserInfoModel'
import { MomentController } from '../model/MomentController'

@ComponentV2
export struct FriendsCircle {

  // 导航控制器
  @Param @Once stack: NavPathStack = new NavPathStack()
  // 列表刷新控制器
  @Param @Once MomentManager: MomentController = new MomentController()
  // 返回事件
  @Event onBackClick: () => void = () => {}
  // 朋友圈列表数据
  @Local CircleDataList: BaseIDataSource<CircleListModel> = new BaseIDataSource<CircleListModel>()
  // 用户信息数据
  @Local userInfoModel: userInfoModel = new userInfoModel()
  // 刷新list
  @Local isRefresh: boolean = false
  // 绑定输入框
  @Local textInputController: TextInputController = new TextInputController()
  // 输入框内容
  @Local inputContent: string = ''
  // 输入框PlaceHolder
  @Local inputPlaceHolder: string = ''
  // 输入框显示
  @Local inputViewShow: boolean = false
  // 评论的朋友圈index
  @Local commenCircleIndex: number = 0
  // 评论回复的信息
  private selectCommen: CirclePingModel = {}
  // 评论回复的信息
  private lastZanViewShowIndex: number = -1
  // 点击图片放大
  @Local imageToLarge: boolean = false
  // 当前选中图片数组
  private selectImageArray: CircleImageModel[] = []
  // 当前点击的图片index
  private selectImageIndex: number = 0
  // 发布朋友圈弹框
  @Local alertSheetShow: boolean = false
  // 弹框数据
  @Local alertData: alertItem[] = []
  // 弹框类型
  @Local alertType: CircleAlertType = CircleAlertType.postMoment
  // 发布朋友圈样式
  private postMomentType: string = '纯文字'
  // List 绑定 Scroller
  scroller: Scroller = new Scroller()
  // 发布朋友圈
  @Local postMoment: boolean = false
  // 列表偏移量用来规避键盘
  @Local ListTranslateY: number = 0
  // loading偏移量
  @Local LoadingY: number = 0
  // loading偏移量
  @Local angle: number = 0
  // loading是否显示
  @Local LoadingShow: boolean = false

  // 导航头背景颜色透明度
  @Local headerBackGroundColorAlpha: number = 0
  @Local backImage: string = 'app.media.fanhui_w'
  @Local faBuImage: string = 'app.media.xiangji_w'
  private  title: string = '朋友圈'

  // 点击图片放大
  private imageSmallToLarge: (imageArray: CircleImageModel[], selectIndex: number)=>void = (imageArray: CircleImageModel[],selectIndex: number)=>{
    this.selectImageArray = imageArray
    this.selectImageIndex = selectIndex
    this.imageToLarge = true
  }
  // 点击图片缩小
  private imageLargeToSmall: ()=>void = ()=>{
    this.imageToLarge = false
  }

  // 显示隐藏点赞弹框和键盘
  hiddenOtherZanView() {
    Logger.info('hiddenOtherZanView'+this.lastZanViewShowIndex.toString())
    // 隐藏已弹出的其他Zanview
    if (this.lastZanViewShowIndex != -1) {
      let param: CircleListModel = this.CircleDataList.getData(this.lastZanViewShowIndex)
      // 应先关闭已存在的
      param.showZanView = false
      this.lastZanViewShowIndex = -1
    }
    // 隐藏弹出的键盘
    if (this.inputViewShow) {
      this.textInputController.stopEditing()
      this.inputViewShow = false
      // List偏移量设置回0
      if (this.ListTranslateY !== 0) {
        this.setListTranslateY('')
      }
    }
  }

  // 设置List偏移量
  setListTranslateY(CellID: string) {
    // 计算contentOffSet规避键盘
    let translateY = 0
    if (CellID.length > 0) {
      let compInfo = componentUtils.getRectangleById(CellID)
      translateY = Constants.SCREEN_HEIGHT - px2vp(compInfo.windowOffset.y) - px2vp(compInfo.size.height) - Constants.KEYBOARD_HEIGHT - 60
    }
    animateTo({
      duration: 350
    },()=>{
      this.ListTranslateY = translateY
    })
  }

  // 跳转去用户详情
  skipToUserInfo(user_id: number) {
    Logger.info(String(user_id))
    UserDataManager.queryUserWithID(user_id,(user_info: userInfoModel[])=>{
      this.stack.pushPathByName('AddressUserInfoPage',user_info[0])
    })
  }

  // 删除朋友圈
  deleteMoment(item: CircleListModel) {
    Alert.showDialog(this.getUIContext(), {
      alertType: AlertType.Alert_Type_MomentDelete,
      maskColor: 'rgba(0, 0, 0, 0.5)',
      content: '删除该朋友圈？:'+item.text+'-'+item.message_id,
      cancelTitle: '取消',
      okTitle: '删除',
      callBack: (title: string) => {
        if (title === '删除') {
          // 删除朋友圈
          DataManager.deleteMoment(item, (isSuccess)=>{
            if (isSuccess) {
              animateTo({duration: 150, curve: Curve.Linear},()=>{
                this.CircleDataList.pop(item)
              })
            }
          })
        }
      }
    })
  }

  // 发布评论
  sendOrDeletePing(sendOrDel: boolean) {
    // 存储评论数据
    let message: CircleListModel = this.CircleDataList.getData(this.commenCircleIndex)
    let ping: CirclePingModel = {
      message_id: message.message_id,
      a_user_id: CommonInstance.crrentUserInfo.user_id,
      a_nick_name: CommonInstance.crrentUserInfo.nick_name,
      b_user_id: this.selectCommen.a_user_id,
      b_nick_name: this.selectCommen.a_nick_name,
      text: this.inputContent,
      time: CommonHelper.getCurrentTimeinterval()
    }
    if (!sendOrDel) {
      ping = this.selectCommen
    }

    DataManager.insertOrDeletePingData(sendOrDel, ping, (success)=>{
      if (success) {
        // 将评论加入数组
        if (!message.pingData) {
          message.pingData = []
        }
        if (sendOrDel) {
          message.pingData.push(ping)
        } else {
          let index = message.pingData?.indexOf(this.selectCommen)
          message.pingData.splice(index!, 1)
        }
      }
    })
  }

  // 搭建UI
  build() {
    NavDestination() {
      Stack() {
        // 朋友圈列表
        Refresh({refreshing: $$this.isRefresh}) {
          List({scroller: this.scroller}){
            ListItemGroup({header: this.ListHeader()}) {
              if (this.CircleDataList.isEmpty) {
                this.noDataView()
              } else {
                LazyForEach((this.CircleDataList),(item: CircleListModel, index: number) => {
                  FriendCircleListTICell({
                    SmallToLarge: (selectImage: number)=>{
                      this.imageSmallToLarge(item.imageData!, selectImage)
                    },
                    message: item,
                    hiddenZanView: (type: string)=>{
                      // 先隐藏上次弹出框
                      this.hiddenOtherZanView()
                      // 再记录此次弹出框index
                      if (item.showZanView && type === '0') {
                        this.lastZanViewShowIndex = this.CircleDataList.indexOf(item)
                      }
                    },
                    deleteMoment: ()=>{
                      // 删除朋友圈
                      this.deleteMoment(item)
                    },
                    userClick: (user_id: number)=>{
                      // 跳转去用户详情
                      this.skipToUserInfo(user_id)
                    },
                    postPing: (ping: CirclePingModel)=>{
                      // 评论事件
                      this.commenCircleIndex = this.CircleDataList.indexOf(item)
                      this.selectCommen = ping
                      if (ping.a_user_id === CommonInstance.crrentUserInfo.user_id) {
                        // 删除评论
                        this.alertSheetShow = true
                        this.alertType = CircleAlertType.delete
                        this.alertData = deletes
                      } else {
                        // 发布评论
                        this.inputPlaceHolder = '发表评论:'
                        if (ping.a_nick_name) {
                          this.inputPlaceHolder = '回复'+ping.a_nick_name+':'
                        }
                        this.setListTranslateY(String(item.time))
                        // 弹出键盘
                        this.inputViewShow = true
                      }
                    },
                    LinkClick: (url: string)=>{
                      // 点击分享链接
                      this.stack!.pushPathByName('WebviewPage', url)
                    }
                  })
                    .id(String(item.time))
                },(item: CircleListModel, index: number) => {
                  return CommonHelper.getCurrentTimeinterval().toString()
                })
              }
            }
          }
          .cachedCount(2)
          .scrollBarWidth(2.0)
          .backgroundColor($r('app.color.wxWhiteColor'))
          .edgeEffect(EdgeEffect.Spring,{alwaysEnabled: true})
          .height(Constants.SCREEN_HEIGHT - Constants.NAVI_HEIGHT)
          .margin({top: Constants.NAVI_HEIGHT})
          .clip(false)
          .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
            // 设置导航头 随着滑动的透明度
            this.headerBackGroundColorAlpha = (this.scroller.currentOffset().yOffset - 240)/20
            this.headerBackGroundColorAlpha = this.headerBackGroundColorAlpha < 0 ? 0 : this.headerBackGroundColorAlpha
            this.headerBackGroundColorAlpha = this.headerBackGroundColorAlpha > 1 ? 1 : this.headerBackGroundColorAlpha
            if (this.scroller.currentOffset().yOffset > 240) {
              this.backImage = 'app.media.fanhui_b'
              this.faBuImage = 'app.media.xiangji_b'
            } else if (this.scroller.currentOffset().yOffset < 260) {
              this.backImage = 'app.media.fanhui_w'
              this.faBuImage = 'app.media.xiangji_w'
            }
          })
          .onAppear(()=>{
            // 刷新朋友圈
            this.MomentManager.reloadData = () => {
              Logger.info('刷新列表')
              this.CircleDataList.reloadData()
            }
          })
          .expandSafeArea([SafeAreaType.KEYBOARD], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          .translate({y: this.ListTranslateY})
        }
        .refreshOffset(50)
        .pullToRefresh(true)
        .onRefreshing(() => {
          // 开启loading动画
          this.loadingAnimationStart()
          // 请求接口
          this.getCircleList()
        })
        .onOffsetChange((offset)=>{
          if (offset > 30) {
            this.LoadingShow = true
          }
        })

        // 导航头
        this.CircleHeader()
        // 底部评论输入框
        if (this.inputViewShow) {
          this.pingInputView()
        }

        // 朋友圈图片点击放大
        if (this.imageToLarge) {
          ImageToLarge({
            LargeToSmall: this.imageLargeToSmall,
            ImageArray: this.selectImageArray,
            currentIndex: this.selectImageIndex
          }).zIndex(10)
        }

        // loading
        if (this.LoadingShow) {
          this.loadingBuilder()
        }
      }
      .backgroundColor($r('app.color.Color_31'))
      .alignContent(Alignment.TopStart)
    }
    .hideTitleBar(true)
  }

  // 刷新空白样式
  @Builder refreshBlankView() {Column()}

  // 列表header
  @Builder ListHeader() {
    FriendCircleListHeader({userInfo: this.userInfoModel,
      BlankClick: ()=>{
        this.hiddenOtherZanView()
      },
      UserClick: (user_id: number) => {
        this.hiddenOtherZanView()
        this.skipToUserInfo(user_id)
      }
    })
  }
  // loading 动画开始
  loadingAnimationStart() {
    animateTo({duration: 200, curve: Curve.Linear},()=>{
      this.LoadingY = 150
    })
    animateTo({duration: 200, curve: Curve.Linear, iterations: -1},()=>{
      this.angle = 60
    })
  }
  // loading 动画结束
  loadingAnimationEnd() {
    setTimeout(()=>{
      this.isRefresh = false
      this.LoadingShow = false
      this.angle = 0
      animateTo({duration: 200, curve: Curve.Linear},()=>{
        this.LoadingY = 0
        this.angle = 0
      })
    },2000)
  }
  // loading
  @Builder loadingBuilder() {
    Image($r('app.media.jiazai'))
      .width(32)
      .height(32)
      .margin({left: 50, top: -32})
      .translate({y: this.LoadingY})
      .rotate({angle: this.angle})
  }

  // 朋友圈导航头
  @Builder CircleHeader() {

    Column() {
      Row().height(Constants.STATUS_BAR_HEIGHT)
      Stack() {
        Row() {
          // 标题
          Text(this.title)
            .fontSize(17)
            .fontColor(`rgba(31, 31, 31, ${this.headerBackGroundColorAlpha})`)
            .textAlign(TextAlign.Center)
            .fontWeight(600)
            .width('100%')
        }
        .height(Constants.NAVI_HEIGHT-Constants.STATUS_BAR_HEIGHT)

        Row() {
          // 返回按钮
          Image($r(this.backImage))
            .width(20)
            .height(20)
            .margin({left: 15})
            .onClick(()=>{
              //this.stack!.pop()
              this.onBackClick()
            })
          // 空白填充
          Blank()
          // 发布朋友圈
          Image($r(this.faBuImage))
            .width(28)
            .height(28)
            .margin({right: 15})
            .bindContentCover(this.alertSheetShow, this.circleAlertSheet(),
              {
                modalTransition: ModalTransition.NONE,
                backgroundColor: Color.Transparent
              })
            .gesture(
              // 互斥组合手势
              GestureGroup(GestureMode.Exclusive,
                TapGesture().onAction((event)=>{
                  this.alertData = alerts
                  this.alertType = CircleAlertType.postMoment
                  this.alertSheetShow = true
                }),
                LongPressGesture({duration: 350}).onAction((event)=>{
                  this.postMomentType = '纯文字'
                  this.postMoment = true
                })
              )
            )
        }
        .bindContentCover(this.postMoment, this.postMomentPage())
        .width('100%')
        .height(Constants.NAVI_HEIGHT-Constants.STATUS_BAR_HEIGHT)
      }
    }
    .expandSafeArea([SafeAreaType.KEYBOARD], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .width('100%')
    .height(Constants.NAVI_HEIGHT)
    .backgroundColor(`rgba(237, 237, 237, ${this.headerBackGroundColorAlpha})`)
  }

  // 朋友圈暂无内容
  @Builder noDataView() {
    Column() {
      Text('一  朋友仅展示最近三天的朋友圈  一')
        .fontSize(16)
        .fontColor($r('app.color.Color_179'))
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .margin({top: 15})
  }
  // 评论输入框
  @Builder pingInputView() {
    Column() {
      Row() {
        TextInput({controller: this.textInputController, text: this.inputContent, placeholder: this.inputPlaceHolder})
          .placeholderColor($r('app.color.Color_179'))
          .placeholderFont({size: 16})
          .fontColor($r('app.color.Color_31'))
          .backgroundColor($r('app.color.wxWhiteColor'))
          .width(Constants.SCREEN_WIDTH - 60)
          .height(40)
          .borderRadius(4)
          .enterKeyType(EnterKeyType.Send)
          .onSubmit((enterKey: EnterKeyType, event: SubmitEvent) => {
            // 完成按钮事件
            this.sendOrDeletePing(true)
            // List偏移量设置回0
            this.setListTranslateY('')
            // 收回键盘
            this.inputViewShow = false
            // 保持键盘，不让收回
            //event.keepEditableState()
          })
          .onChange((value: string) => {
            // 输入内容发生变化
            this.inputContent = value
          })
          .onEditChange((isEditing)=>{
            if (!isEditing) {
              this.inputContent = ''
            }
          })
          .id('ping')
          .onAppear(()=>{
            focusControl.requestFocus('ping')
          })
        Image($r('app.media.biaoqing'))
          .height(28)
          .width(28)
          .margin({left: 10})
      }
      .width('100%')
      .height(54)
      .backgroundColor($r('app.color.Color_246'))
      .padding({top: 6, bottom: 6, left: 10, right: 10})

      Row().height(10).width('100%').backgroundColor($r('app.color.Color_246'))
    }
    .translate({y: Constants.SCREEN_HEIGHT - 65})
  }

  // 发布朋友圈编辑器
  @Builder circleAlertSheet() {
    // 发布朋友圈选择器
    CircleAlertSheet({
      alertType: this.alertType,
      alertItems: this.alertData,
      pageDismiss: (type: CircleAlertType, item: alertItem)=>{
        this.alertSheetShow = false
        if (type === CircleAlertType.postMoment) {
          if (item.title !== '取消') {
            this.postMoment = true
            this.postMomentType = item.title
          }
        } else if (type === CircleAlertType.delete) {
          if (item.title === '删除') {
            // 删除
            this.sendOrDeletePing(false)
          }
        }
      }
    })
      .height('100%')
  }

  // 发布朋友圈编辑器
  @Builder postMomentPage() {
    PostMomentsPage({
      pageDismiss: (type: number, message?: CircleListModel)=>{
        // 移除编辑页面
        this.postMoment = false
        // 刷新朋友圈
        if (type === 1) {
          // 滑动到顶部
          this.scroller.scrollTo({xOffset: 0, yOffset: 0})
          // 刷新显示新发布的朋友圈
          if (message) {
            this.CircleDataList.push(message, 0)
            for (let i = 0; i < this.CircleDataList.totalCount(); i ++) {
              let item = this.CircleDataList.getData(i)
            }
          }
        }
      },
      type: this.postMomentType
    })
      .height('100%')
  }

  // 获取朋友圈数据
  getCircleList(loadMore: boolean = false) {
    // 请求数据
    DataManager.queryCircleListData((result)=>{
      // 重新获取数据，先清空数组
      if (!loadMore) {
        this.CircleDataList.popAll()
      }
      let dataArray: CircleListModel[] = []
      for (let i = 0; i < result.length; i ++) {
        let param: CircleListModel = new CircleListModel(result[i])
        dataArray.push(param)
      }
      this.CircleDataList.pushItems(dataArray)
      // 停止刷新
      this.loadingAnimationEnd()
    })
  }

  // 获取用户信息数据
  getUserInfo() {
    let user_id = PreferenceHelper.quary(Strings.USER_ID) as number
    UserDataManager.queryUserWithID(user_id, (result)=>{
      if (result.length > 0) {
        this.userInfoModel = result[0]
        CommonInstance.crrentUserInfo = result[0]
      }
    })
  }

  // 页面出现
  aboutToAppear(): void {

    // 获取朋友圈数据
    this.getCircleList()
    this.getUserInfo()
    // 获取朋友圈数据
    HMEmitter.on(1,(param: string)=>{
      let types: PAGE_TYPE[] = JSON.parse(param)
      for (let i = 0; i < types.length; i ++) {
        let type: PAGE_TYPE = types[i]
        if (type == PAGE_TYPE.find) {
          // 获取朋友圈数据
          this.getCircleList()
        } else if (type == PAGE_TYPE.mine) {
          this.getUserInfo()
        }
      }
    })
  }
}
