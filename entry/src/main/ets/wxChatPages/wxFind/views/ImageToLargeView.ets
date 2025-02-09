
import { componentUtils } from '@kit.ArkUI'
import Logger from '../../wxTools/Logger'
import { CircleImageModel } from '../model/FriendCircleListModel'
import { Constants } from '../../wxTools/Constants'

@ComponentV2
export struct ImageToLarge {

  private swiperController: SwiperController = new SwiperController()
  // 动画相关参数
  @Local smallToLarge: boolean = false
  @Local swiperShow: boolean = false
  @Local backGroundColor: string = 'rgba(0, 0, 0, 0.00)'
  @Local blankGroundColor: string = 'rgba(255, 255, 255, 1.00)'
  @Local swiperVisible: Visibility = Visibility.Hidden
  @Local imageVisible: Visibility = Visibility.Visible
  @Local blankVisible: Visibility = Visibility.Hidden
  // 外部传入图片数据
  @Param @Once ImageArray: CircleImageModel[] = []
  @Param @Once currentIndex: number = 0
  @Local currentModel: CircleImageModel = {}
  // 点击图片变小事件
  @Event LargeToSmall: ()=>void = ()=>{}

  // 设置UI
  build() {
    Stack() {
      // 计算大图片尺寸
      this.getLargeImageSize(this.ImageArray)
      // 滚动器
      Swiper(this.swiperController) {
        ForEach(this.ImageArray, (item: CircleImageModel) => {
          Image($r(`app.media.${item.src}`))
            .objectFit(ImageFit.ScaleDown)
        })
      }
      .height('100%')
      .cachedCount(2)
      .visibility(this.swiperVisible)
      .index(this.currentIndex)
      .duration(350)
      .indicator( // 设置圆点导航点样式
        new DotIndicator()
          .itemWidth(8)
          .bottom(20)
          .itemHeight(8)
          .selectedItemWidth(8)
          .selectedItemHeight(8)
          .color($r('app.color.Color_114'))
          .selectedColor($r('app.color.wxWhiteColor')))
      .curve(Curve.Linear)
      .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
        this.currentModel = this.ImageArray[index]
        console.info("index: " + index)
        console.info("current offset: " + extraInfo.currentOffset)
      })

      Row()
        .backgroundColor(this.blankGroundColor)
        .width(this.currentModel?.imageSmallWidth)
        .height(this.currentModel?.imageSmallHeight)
        .margin({left: this.currentModel?.imageSmallMLeft, top: this.currentModel?.imageSmallMTop})
        .visibility(this.blankVisible)

      Image($r(`app.media.${this.currentModel?.src}`))
        .objectFit(ImageFit.Fill)
        .width(this.smallToLarge ? this.currentModel?.imageLargeWidth : this.currentModel?.imageSmallWidth)
        .height(this.smallToLarge ? this.currentModel?.imageLargeHeight : this.currentModel?.imageSmallHeight)
        .margin(this.smallToLarge ? {left: this.currentModel?.imageLargeMLeft, top: this.currentModel?.imageLargeMTop} : {left: this.currentModel?.imageSmallMLeft, top: this.currentModel?.imageSmallMTop})
        .visibility(this.imageVisible)
        .zIndex(10)

    }
    .width('100%')
    .height('100%')
    .align(Alignment.TopStart)
    .backgroundColor(this.backGroundColor)
    .onClick((event)=>{
      this.swiperVisible = Visibility.Hidden
      this.imageVisible = Visibility.Visible
      this.blankVisible = Visibility.Visible
      setTimeout(()=>{
        this.ToSmall()
      },100)
    })
  }
  // 点击图片变小
  ToSmall() {
    animateTo({
      duration: 250,
      onFinish:(()=>{
        this.LargeToSmall()
      })
    },()=>{
      this.blankGroundColor = 'rgba(255, 255, 255, 1.00)'
      this.backGroundColor = 'rgba(0, 0, 0, 0.00)'
      this.smallToLarge = false
    })
  }
  // 点击图片变大
  toLarge() {
    setTimeout(()=>{
      this.blankVisible = Visibility.Visible
    },10)
    animateTo({
      duration: 250,
      onFinish:(()=>{
        this.swiperVisible = Visibility.Visible
        this.imageVisible = Visibility.Hidden
        this.blankVisible = Visibility.Hidden
      })
    },()=>{
      this.blankGroundColor = 'rgba(0, 0, 0, 1.00)'
      this.backGroundColor = 'rgba(0, 0, 0, 1.00)'
      this.smallToLarge = true
    })
  }

  // 获取放大图片的尺寸
  @Builder getLargeImageSize(imageArray: CircleImageModel[]) {
    Column() {
      ForEach(this.ImageArray, (item: CircleImageModel) => {
        Image($r(`app.media.${item.src}`))
          .onComplete((callBack)=>{
            item.imageLargeWidth = px2vp(callBack?.width) > Constants.SCREEN_WIDTH ? Constants.SCREEN_WIDTH : px2vp(callBack?.width)
            item.imageLargeHeight = px2vp(callBack?.height)/px2vp(callBack?.width)*item.imageLargeWidth
            item.imageLargeMLeft = (Constants.SCREEN_WIDTH-item.imageLargeWidth)/2.0
            item.imageLargeMTop = (Constants.SCREEN_HEIGHT-item.imageLargeHeight)/2.0
            Logger.info(String(item.imageLargeWidth))
            Logger.info(String(item.imageLargeHeight))
          })
      })
    }.visibility(Visibility.Hidden)
  }
  // 计算各组图片的相对坐标 并获取当前model
  getImageModePosition(imageArray: CircleImageModel[]) {
    for (let i = 0; i < imageArray.length; i ++) {
      let model: CircleImageModel = imageArray[i]
      model.imageSmallMLeft = px2vp(componentUtils.getRectangleById(model.component_id).windowOffset.x)
      model.imageSmallMTop = px2vp(componentUtils.getRectangleById(model.component_id).windowOffset.y)
      model.imageSmallWidth = px2vp(componentUtils.getRectangleById(model.component_id).size.width)
      model.imageSmallHeight = px2vp(componentUtils.getRectangleById(model.component_id).size.height)
    }
    this.currentModel = imageArray[this.currentIndex]
  }
  // 页面出现
  aboutToAppear() {
    Logger.info('ImageToLarge:aboutToAppear')
    this.getImageModePosition(this.ImageArray)
    this.toLarge()
  }
  aboutToDisappear(): void {
    Logger.info('ImageToLarge:aboutToDisappear')
  }
}