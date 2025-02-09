import { Constants } from '../../wxTools/Constants'
import Logger from '../../wxTools/Logger'
import CommonHelper from '../../wxTools/CommonHelper'
import CommonInstance from '../../wxTools/wxCommonInstance'
import DataRDBStore, { TABLE_TYPE } from '../../wxTools/DataRDBStore'
import { CircleImageArray, LinkModelList, LocationNames } from '../../wxBase/ImageDataModel'
import { CircleImageModel, CircleLinkModel, CircleListModel, CircleLocationModel } from '../model/FriendCircleListModel'
import { PostMomentCell } from '../views/PostMomentPageCell'
import { alertItem } from '../model/FindPageListModel'

@ComponentV2
export struct PostMomentsPage {

  private inputController: TextInputController = new TextInputController()
  private inputContent: string = ''
  private showLocation: boolean = false
  @Local locationTitle: string = ''
  // 拍摄，从手机相册选择，2: 转发链接 3: 纯文字
  @Param @Once type: string = '纯文字'
  @Local translateY: number = Constants.SCREEN_HEIGHT
  // type = 0 表示取消 1 表示发布
  @Event pageDismiss: (type: number, message?: CircleListModel)=>void = (type: number, message?: CircleListModel) => {}
  // 图片资源
  private images: CircleImageModel[] = []

  // 发表
  publish() {

    this.inputController.stopEditing()

    let message: CircleListModel = new CircleListModel()
    message.message_id = CommonHelper.getCurrentTimeinterval() - 1
    message.user_id = CommonInstance.crrentUserInfo.user_id
    message.text = this.inputContent
    message.nick_name = CommonInstance.crrentUserInfo.nick_name
    message.head_image = CommonInstance.crrentUserInfo.head_image
    message.time = CommonHelper.getCurrentTimeinterval()
    // 存储朋友圈基本信息
    DataRDBStore.insertData<CircleListModel>(message, TABLE_TYPE.CircleList, (isSuccess)=>{

      if (isSuccess) {
        if (this.type === '拍摄') {
          // 存储视频
          this.checkLocationSetting(message)
        } else if (this.type === '从手机相册选择') {
          // 存储图片
          for (let i = 0; i < this.images.length; i ++) {
            let image: CircleImageModel = this.images[i]
            image.message_id = message.message_id
            DataRDBStore.insertData<CircleImageModel>(image, TABLE_TYPE.CircleImage, (success)=>{})
          }
          message.imageData = this.images
          setTimeout(()=>{
            this.checkLocationSetting(message)
          },350)
        } else if (this.type === '转发链接') {
          // 转发链接
          let link: CircleLinkModel = LinkModelList[CommonHelper.getRandomNumber(1)%LinkModelList.length]
          link.message_id = message.message_id
          message.linkData = link
          DataRDBStore.insertData<CircleLinkModel>(link, TABLE_TYPE.CircleLink, (success)=>{
            if (success) {
              this.checkLocationSetting(message)
            }
          })
        } else if (this.type === '纯文字') {
          // 纯文字
          this.checkLocationSetting(message)
        }
      } else {
        Logger.info('发布失败')
      }
    })
  }
  // 检查是否设置地理位置
  checkLocationSetting(message: CircleListModel) {
    if (this.showLocation) {
      let location: CircleLocationModel = {
        location_name: this.locationTitle,
        message_id: message.message_id,
        location_latitude: 39.9,
        location_longitude: 116.4
      }
      message.locationData = location
      DataRDBStore.insertData<CircleLocationModel>(location, TABLE_TYPE.CircleLocation, (success)=>{
        if (success) {
          this.pageDisappear(1, message)
        }
      })
    } else {
      this.pageDisappear(1, message)
    }
  }
  // 页面消失
  pageDisappear(type: number, message?: CircleListModel) {
    // 回调
    this.pageDismiss(type, message)
    // 关闭页面
    animateTo({
      duration: 350,
      curve: Curve.EaseInOut
    },()=>{
      this.translateY = Constants.SCREEN_HEIGHT
    })
  }
  // 页面出现
  aboutToAppear(): void {
    animateTo({
      duration: 350,
      curve: Curve.EaseInOut
    },()=>{
      this.translateY = 0
    })
    // 自动获取图片资源
    if (this.type === '从手机相册选择') {
      let imageNum = CommonHelper.getRandomNumber(2) % 9 + 1
      let timeInterval = CommonHelper.getCurrentTimeinterval(true)
      for (let i = 0; i < imageNum; i ++) {
        let image: CircleImageModel = {
          component_id: String(timeInterval)+'_'+String(i),
          src: CircleImageArray[CommonHelper.getRandomNumber(3)%CircleImageArray.length]
        }
        this.images.push(image)
      }
    }
  }

  // UI
  build() {
    Stack() {
      Grid(){
        ForEach(this.images,(image: CircleImageModel, index) => {
          GridItem() {
            Image($r(`app.media.${image.src}`))
              .onComplete((result)=>{
                if (result != undefined) {
                  if (this.images.length > 1) {
                    image.imageSmallWidth = 80
                    image.imageSmallHeight = 80
                  } else {
                    if (result.width > result.height) {
                      image.imageSmallWidth = 160
                      image.imageSmallHeight = result.height/result.width*160
                    } else if (result.width < result.height) {
                      image.imageSmallHeight = 160
                      image.imageSmallWidth = result.width/result.height*160
                    } else {
                      image.imageSmallWidth = 160
                      image.imageSmallHeight = 160
                    }
                  }
                }
              })
          }
        })
      }
      .visibility(Visibility.Hidden)

      Column() {
        Row()
          .backgroundColor(Color.White)
          .width('100%')
          .height(Constants.NAVI_HEIGHT - 42)
        Row() {
          Text('取消')
            .fontSize(16)
            .fontColor($r('app.color.Color_31'))
            .margin({left: 15})
            .onClick((event)=>{
              this.pageDisappear(0)
            })
          Blank()
          Text('发表')
            .fontSize(14)
            .fontColor($r('app.color.wxWhiteColor'))
            .textAlign(TextAlign.Center)
            .width(52)
            .height(32)
            .borderRadius(6)
            .backgroundColor($r('app.color.Color_115_116_122'))
            .margin({right: 15})
            .onClick((event)=>{
              this.publish()
            })
        }
        .width('100%')
        .height(42)

        TextArea({placeholder: '这一刻的想法...', controller: this.inputController})
          .placeholderFont({size: 16})
          .placeholderColor($r('app.color.Color_179'))
          .width(Constants.SCREEN_WIDTH - 30)
          .height(120)
          .margin({top: 25})
          .borderRadius(0)
          .backgroundColor(Color.White)
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .caretColor($r('app.color.Color_Tab_select'))
          .onChange((value: string)=>{
            Logger.info(value)
            this.inputContent = value
          })

        Row()
          .width(Constants.SCREEN_WIDTH - 30)
          .height(0.7)
          .margin({left: 150, top: 20})
          .backgroundColor($r('app.color.Color_246'))

        PostMomentCell({image: 'app.media.location_b', itemTitle: '所在位置', didSelectRow: (location)=>{
          this.showLocation = true
          this.locationTitle = location
        }})
        PostMomentCell({image: 'app.media.tixingshuikan', itemTitle: '提醒谁看'})
        PostMomentCell({image: 'app.media.yonghu', itemTitle: '谁可以看', rightValue: '公开'})
      }
      .onClick((event)=>{
        this.inputController.stopEditing()
      })
      .backgroundColor($r('app.color.wxWhiteColor'))
      .height('100%')
      .width('100%')
      .translate({y: this.translateY})
    }
  }
}