
import { Constants } from '../../wxTools/Constants'
import CommonHelper from '../../wxTools/CommonHelper'
import DataManager from '../CircleRequest/CircleDataManager'
import CommonInstance from '../../wxTools/wxCommonInstance'
import { CircleImageModel,
  CircleLinkModel,
  CircleListModel,
  CirclePingModel,
  CircleZanModel } from '../model/FriendCircleListModel'
import Logger from '../../wxTools/Logger'
import { LengthMetrics } from '@kit.ArkUI'

@ComponentV2
export struct FriendCircleListTICell {
  // 朋友圈信息
  @Param @Require message: CircleListModel
  // textController
  private controller: TextController = new TextController()
  @Local textLines: number = 0
  // 是否显示全部内容
  @Local showAllContent: boolean = true
  // 点击链接
  @Local LinkSelect: boolean = false
  @Event LinkClick: (url: string)=>void = (url: string)=>{}
  // 点击图片放大
  @Event SmallToLarge: (selectIndex: number)=>void = (selectIndex: number)=>{}
  // 计算图片宽高
  @Local zanTranslateX: number = 180
  // 赞图片
  @Local zanImage: string = 'app.media.zan'
  @Local zanTitle: string = '赞'
  @Local zanUsers: string = ''
  @Local zanUsersViewShow: boolean = false
  // 发布评论
  @Event postPing: (ping: CirclePingModel)=>void = (ping: CirclePingModel)=>{}
  // 点赞点击事件
  @Event hiddenZanView: (type: string)=>void = (type: string)=>{}
  // 删除朋友圈
  @Event deleteMoment: ()=>void = ()=>{}
  // 点击了用户
  @Event userClick: (user_id: number)=>void = (user_id: number)=>{}

  build() {
    Column() {
      Row() {
        Image($r(`app.media.${this.message.head_image}`))
          .margin({left: 20, top: 15})
          .borderRadius(4)
          .width(40)
          .height(40)
          .onClick(()=>{
            this.userClick(this.message.user_id!)
          })

        Column() {
          // 昵称
          Text(this.message.nick_name)
            .fontSize(16)
            .fontColor($r('app.color.Color_89_96_134'))
            .fontWeight(600)
            .margin({top:1})
            .onClick(()=>{
              this.userClick(this.message.user_id!)
            })
          // 文案
          if (this.message.text && this.message.text.length > 0) {
            this.TextShow(this.message.text)
          }
          // 链接
          if (this.message.linkData !== undefined) {
            this.LinkShow(this.message.linkData)
          }
          // 图片
          if (this.message.imageData && this.message.imageData.length > 0) {
            this.ImageShow(this.message.imageData)
          }
          // 地理位置
          if (this.message.locationData !== undefined) {
            Text(this.message.locationData.location_name)
              .fontSize(12)
              .fontColor($r('app.color.Color_89_96_134'))
              .margin({top: 8})
          }
          // 时间戳
          Row() {
            Text(CommonHelper.wxCircleTimeinterval(this.message.time))
              .fontSize(12)
              .fontColor($r('app.color.Color_179'))
              .letterSpacing(1)

            if (this.message.user_id === CommonInstance.crrentUserInfo.user_id) {
              Text('删除')
                .fontSize(12)
                .fontColor($r('app.color.Color_89_96_134'))
                .letterSpacing(1)
                .margin({left: 8})
                .onClick(()=>{
                  this.deleteMoment()
                })
            }

            Blank()
            // 点赞弹框
            this.zanAndPingView()
          }
          .width(Constants.SCREEN_WIDTH - 90)
          // 点赞和评论
          if ((this.message.zanData && this.message.zanData.length > 0) || (this.message.pingData && this.message.pingData.length > 0)) {
            this.zanAndPingInfoView()
          }
        }
        .width(Constants.SCREEN_WIDTH - 60)
        .margin({top: 15, left: 10})
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(VerticalAlign.Top)

      // 分割线
      Row()
        .backgroundColor($r('app.color.Color_237'))
        .height(0.7)
        .width('100%')
        .margin({top: 1})
    }
    .backgroundColor($r('app.color.wxWhiteColor'))
    .onClick((event)=>{
      // 隐藏点赞view
      this.hiddenZanView('1')
      this.message.showZanView = false
    })
  }

  // 链接显示view
  @Builder LinkShow(link: CircleLinkModel = {}) {
    Row() {
      Image($r(`app.media.${link.link_image}`))
        .margin({left: 5})
        .width(40)
        .height(40)
      Text(link.link_text)
        .fontSize(14)
        .fontColor($r('app.color.Color_31'))
        .margin({left: 6})
        .maxLines(2)
        .width(Constants.SCREEN_WIDTH - 140)
    }
    .height(50)
    .width(Constants.SCREEN_WIDTH - 90)
    .backgroundColor(this.LinkSelect ? $r('app.color.Color_210') : $r('app.color.Color_246'))
    .onTouch((event)=>{
      if (event.type == TouchType.Down) {
        this.LinkSelect = true
      } else if (event.type == TouchType.Up) {
        this.LinkSelect = false
      }
    })
    .margin({top: 10})
    .onClick((event)=>{
      this.LinkClick(link.link_url!)
    })
  }

  // 文案显示view
  @Builder TextShow(content: string = '') {
    Column() {
      Text(content, {controller: this.controller})
        .fontSize(16)
        .fontColor($r('app.color.Color_31'))
        .margin({top:5})
        .width(Constants.SCREEN_WIDTH - 90)
        .textOverflow({overflow:TextOverflow.Ellipsis})
        .maxLines(this.showAllContent ? undefined : 5)
        .onAreaChange(() => {
            let layoutManager: LayoutManager = this.controller.getLayoutManager()
            this.textLines = layoutManager.getLineCount()
          }
        )
      if (this.textLines > 5) {
        Text(this.showAllContent ? '收起' : '全文')
          .fontSize(16)
          .fontColor($r('app.color.Color_89_96_134'))
          .margin({top:5})
          .onClick((event)=>{
            this.showAllContent = !this.showAllContent
          })
      }
    }
    .alignItems(HorizontalAlign.Start)
  }

  // 图片显示view
  @Builder ImageShow(imageArray: CircleImageModel[]) {
    Grid(){
      ForEach(imageArray,(image: CircleImageModel, index) => {
        GridItem() {
          Image($r(`app.media.${image.src}`))
            .width(image.imageSmallWidth)
            .height(image.imageSmallHeight)
            .objectFit(ImageFit.Fill)
            .key(image.component_id)
        }
        .onClick((event)=>{
          this.SmallToLarge(index)
        })
      })
    }
    .maxCount(this.getImageRowMaxCount(imageArray))
    .columnsGap(5)
    .rowsGap(5)
    .margin({top: 10})
  }

  // 获取图片最大列数
  private getImageRowMaxCount(imageArray: CircleImageModel[] = []): number{
    if (imageArray.length < 4) {
      return imageArray.length
    } else if (imageArray.length == 4) {
      return 2
    } else {
      return 3
    }
  }

  // 点赞view
  @Builder zanAndPingView() {
    Row() {
      Blank()
      Row() {
        Row() {
          Row() {
            Image($r(this.zanImage))
              .width(16)
              .height(16)
            Text(this.zanTitle)
              .fontSize(14)
              .fontColor($r('app.color.wxWhiteColor'))
              .textAlign(TextAlign.Center)
              .margin({left: 3})
          }
          .width(85)
          .height(40)
          .justifyContent(FlexAlign.Center)
          .onClick((event)=>{
            // 先隐藏赞view
            this.hiddenZanView('1')
            this.message.showZanView = false
            // 点赞事件
            this.ZanAction()
          })

          Row()
            .height(20)
            .width(1)
            .backgroundColor('rgb(67,67,67)')

          Row() {
            Image($r('app.media.pinglun'))
              .width(14)
              .height(14)
            Text('评论')
              .fontSize(14)
              .fontColor($r('app.color.wxWhiteColor'))
              .textAlign(TextAlign.Center)
              .margin({left: 3})
          }
          .justifyContent(FlexAlign.Center)
          .onClick((event)=>{
            // 先隐藏赞view
            this.hiddenZanView('1')
            this.message.showZanView = false
            // 回复评论
            this.postPing({})
          })
          .width(85)
          .height(40)
        }
        .backgroundColor($r('app.color.Color_77'))
        .borderRadius(5)
        .translate({x: this.message.showZanView ? 0 : 171})
        .animation({
          duration: 300
        })
        .justifyContent(FlexAlign.SpaceBetween)
        .height(40)
        .width(170)
      }
      .clip(true)

      Blank()

      Text('●  ●')
        .fontSize(6)
        .fontColor($r('app.color.Color_89_96_134'))
        .width(30)
        .height(20)
        .borderRadius(4)
        .textAlign(TextAlign.Center)
        .backgroundColor($r('app.color.Color_246'))
        .onClick((event)=>{
          // 在显示新的
          this.message.showZanView = !this.message.showZanView
          Logger.info(String(this.message.showZanView))
          // 先隐藏别的
          this.hiddenZanView('0')
          Logger.info(String(this.message.showZanView))
        })
    }
    .width(210)
    .height(40)
  }
  // 显示赞用户
  @Builder zanAndPingInfoView() {
    Column() {
      if (this.message.zanData && this.message.zanData.length > 0) {
        Stack(){
          Row() {
            Text() {
              Span('     ')
                .fontSize(14)
                .fontColor($r('app.color.Color_89_96_134'))
                .fontWeight(600)
              ForEach(this.message.zanData, (item: CircleZanModel, index: number)=>{
                Span(item.nick_name)
                  .fontSize(14)
                  .fontColor($r('app.color.Color_89_96_134'))
                  .fontWeight(600)
                  .onClick(()=>{
                    this.userClick(item.user_id!)
                  })
                if (index < this.message.zanData!.length - 1) {
                  Span(', ')
                    .fontSize(14)
                    .fontColor($r('app.color.Color_31'))
                    .fontWeight(600)
                }
              })
            }
            .width(Constants.SCREEN_WIDTH - 100)
            .align(Alignment.TopStart)
            .lineSpacing(new LengthMetrics(4))
          }
          Image($r('app.media.xin'))
            .width(15)
            .height(15)
            .margin({top: 1})
        }
        .width(Constants.SCREEN_WIDTH - 102)
        .alignContent(Alignment.TopStart)
      }

      if (this.message.zanData && this.message.zanData.length > 0 && this.message.pingData && this.message.pingData.length > 0) {
        Row()
          .width(Constants.SCREEN_WIDTH - 90)
          .height(0.7)
          .backgroundColor($r('app.color.Color_241'))
          .margin({top: 5})
        Row()
          .width(Constants.SCREEN_WIDTH - 90)
          .height(5)
      }

      if (this.message.pingData && this.message.pingData.length > 0) {
        Column() {
          ForEach(this.message.pingData, (ping: CirclePingModel, index: number)=>{
            Text() {
              Span(ping.a_nick_name)
                .fontSize(14)
                .fontColor($r('app.color.Color_89_96_134'))
                .fontWeight(600)
                .onClick(()=>{
                  this.userClick(ping.a_user_id!)
                })
              if (ping.b_nick_name) {
                Span('回复')
                  .fontSize(14)
                  .fontColor($r('app.color.Color_31'))
                Span(ping.b_nick_name)
                  .fontSize(14)
                  .fontColor($r('app.color.Color_89_96_134'))
                  .fontWeight(600)
                  .onClick(()=>{
                    this.userClick(ping.b_user_id!)
                  })
              }
              Span(': ')
                .fontSize(14)
                .fontColor($r('app.color.Color_89_96_134'))
                .fontWeight(600)
              Span(ping.text)
                .fontSize(14)
                .fontColor($r('app.color.Color_31'))
            }
            .width(Constants.SCREEN_WIDTH - 100)
            .align(Alignment.TopStart)
            .onClick((event)=>{
              // 隐藏弹出框
              this.message.showZanView = false
              // 回复评论
              this.postPing(this.message.pingData![index])
            })
            if (index !== this.message.pingData!.length - 1) {
              Row().height(5).width(Constants.SCREEN_WIDTH - 100)
            }
          })
        }
        .alignItems(HorizontalAlign.Start)
      }
    }
    .borderRadius(4)
    .backgroundColor($r('app.color.Color_246'))
    .padding({top: 6, bottom: 6, left: 5, right: 5})

    Row()
      .height(15)
      .width('100%')
  }


  // 点赞事件
  ZanAction() {

    let zan: CircleZanModel = {
      message_id: this.message.message_id,
      user_id: CommonInstance.crrentUserInfo.user_id,
      nick_name: CommonInstance.crrentUserInfo.nick_name,
      time: CommonHelper.getCurrentTimeinterval()
    }
    // 处理数据
    let zanStatus = this.currentUserHasZan()
    DataManager.insertOrDeleteZanData(!zanStatus[0], zan, (isSuccess)=>{

      if (!this.message.zanData) {
        this.message.zanData = []
      }

      if (!zanStatus[0]) {
        this.message.zanData.push(zan)
      } else {
        this.message.zanData.splice(zanStatus[1], 1)
      }
      // 重新拼接点赞用户
      this.setZanUsers()
    })
  }

  // 拼接赞用户
  setZanUsers() : string {
    // 设置赞的图标
    this.setZanStatus()
    // 拼接赞用户
    let zanUsers: string = ''
    if (this.message.zanData) {
      let zanNum: number = this.message.zanData.length
      for (let i = 0; i < zanNum; i ++) {
        let zan: CircleZanModel = this.message.zanData[i]
        if (i == zanNum - 1) {
          zanUsers = zanUsers+zan.nick_name
        } else {
          zanUsers = zanUsers+zan.nick_name+', '
        }
      }
    }
    return zanUsers
  }

  // 设置赞图片名称
  setZanStatus() {

    let hasZan: boolean = this.currentUserHasZan()[0]
    if (hasZan) {
      this.zanImage = 'app.media.zaned'
      this.zanTitle = '取消'
    } else {
      this.zanImage = 'app.media.zan'
      this.zanTitle = '赞'
    }
  }

  // 当前用户是否已经点赞
  currentUserHasZan() :[boolean, number] {
    let hasZan: boolean = false
    let index: number = 0
    if (this.message.zanData && this.message.zanData.length > 0) {
      for (let i = 0; i < this.message.zanData.length; i ++){
        let item = this.message.zanData[i]
        if (item.user_id === CommonInstance.crrentUserInfo.user_id) {
          hasZan = true
          index = i
          break
        }
      }
    }
    return [hasZan, index]
  }

  // 页面出现
  aboutToAppear(): void {
    this.setZanUsers()
  }
}