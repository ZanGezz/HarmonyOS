import { Constants } from '../../wxTools/Constants'

@ComponentV2
export struct ListCommonCell {

  @Param @Once title: string = ''
  @Param @Once showBottomLine: boolean = true
  @Local backGroundColor: string = 'app.color.wxWhiteColor'
  // cell点击事件
  @Event selectRow: ()=>void = () => {}

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .margin({left: 15})
        Blank()
        Image($r('app.media.youjiantou'))
          .width(24)
          .height(24)
          .margin({right: 12})
      }
      .width('100%')
      .height(55)
      if (this.showBottomLine) {
        Row()
          .margin({ left: 15 })
          .height(0.6)
          .backgroundColor($r('app.color.Color_237'))
          .width(Constants.SCREEN_WIDTH-15)
      }
    }
    .backgroundColor($r(this.backGroundColor))
    .onTouch((event) => {
      if (event.type == TouchType.Down) {
        this.backGroundColor = 'app.color.Color_220'
      } else {
        this.backGroundColor = 'app.color.wxWhiteColor'
      }
    })
  }
}

@ComponentV2
export struct ListSwitchCell {

  @Param @Once title: string = ''
  @Param @Once showBottomLine: boolean = true
  @Local switchOn: boolean = false

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .margin({left: 15})
        Blank()
        Toggle({ type: ToggleType.Switch, isOn: this.switchOn })
          .margin({right: 15})
          .width(52)
          .height(32)
          .selectedColor($r('app.color.Color_Tab_select'))
      }
      .width('100%')
      .height(55)
      if (this.showBottomLine) {
        Row()
          .margin({ left: 15 })
          .height(0.6)
          .backgroundColor($r('app.color.Color_237'))
          .width(Constants.SCREEN_WIDTH-15)
      }
    }
    .backgroundColor($r('app.color.wxWhiteColor'))
  }
}

@ComponentV2
export struct ListImageCell {

  @Param @Once images: string[] = []
  @Param @Once showBottomLine: boolean = true
  @Param @Once backGroundColor: string = 'app.color.wxWhiteColor'

  build() {
    Column() {
      Row() {
        Text('朋友圈')
          .fontSize(16)
          .fontColor($r('app.color.Color_31'))
          .margin({left: 15})
        Row() {
          ForEach(this.images, (image_name: string, index: number) => {
            Image($r(`app.media.${image_name}`))
              .width(48)
              .height(48)
              .margin({left: 5})
          })
        }
        Image($r('app.media.youjiantou'))
          .width(24)
          .height(24)
          .margin({right: 12})
      }
      .width('100%')
      .height(80)
      .justifyContent(FlexAlign.SpaceBetween)
      if (this.showBottomLine) {
        Row()
          .margin({ left: 15 })
          .height(0.6)
          .backgroundColor($r('app.color.Color_237'))
          .width(Constants.SCREEN_WIDTH-15)
      }
    }
    .backgroundColor($r(this.backGroundColor))
    .onTouch((event) => {
      if (event.type == TouchType.Down) {
        this.backGroundColor = 'app.color.Color_220'
      } else {
        this.backGroundColor = 'app.color.wxWhiteColor'
      }
    })
  }
}

@ComponentV2
export struct ListChatCell {

  @Param @Once title: string = ''
  @Param @Once image_name: string = ''
  @Param @Once showBottomLine: boolean = true

  build() {
    Column() {
      Row() {
        Image($r(`app.media.${this.image_name}`))
          .width(20)
          .height(20)
          .objectFit(ImageFit.Contain)
        Text(this.title)
          .fontSize(16)
          .fontWeight(600)
          .fontColor($r('app.color.Color_89_96_134'))
          .margin({left: 4})
      }
      .height(55)
      .alignItems(VerticalAlign.Center)

      if (this.showBottomLine) {
        Row()
          .height(0.6)
          .backgroundColor($r('app.color.Color_237'))
          .width('100%')
      }
    }
    .backgroundColor($r('app.color.wxWhiteColor'))
  }
}

@ComponentV2
export struct ListDeleteCell {

  @Param @Once title: string = ''
  @Param @Once showBottomLine: boolean = true
  @Event RowSelect: () => void = () => {}

  build() {
    Column() {
      Column() {
        Text(this.title)
          .fontSize(16)
          .fontWeight(600)
          .fontColor($r('app.color.Color_200_109_103'))
          .height(55)
      }
      .width('100%')
      .onClick(()=>{
        this.RowSelect()
      })

      if (this.showBottomLine) {
        Row()
          .height(0.6)
          .backgroundColor($r('app.color.Color_237'))
          .width('100%')
      }
    }
    .backgroundColor($r('app.color.wxWhiteColor'))
  }
}