

@ComponentV2
export struct AlphabetIndexView {

  @Param @Require alphaData: string[] = []
  @Local popHidden: Visibility = Visibility.None
  @Local popMarginTop: number = - 3
  @Local popTitle: string = ''
  @Param selectIndex: number = -1
  @Event selectItem: (index: number) => void = (index: number) => {}

  build() {
    Row() {
      Stack() {
        Image($r('app.media.qipao'))
          .width(64)
          .height(50)

        Text(this.popTitle)
          .width(56)
          .height(50)
          .fontWeight(600)
          .fontSize(26)
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.wxWhiteColor'))
      }
      .visibility(this.popHidden)
      .alignContent(Alignment.Start)
      .margin({right: 10, top: this.popMarginTop})

      Column() {
        Image($r('app.media.sousuo_b'))
          .width(12)
          .height(12)
          .margin({top: 2})
        ForEach(this.alphaData, (title: string, index: number) => {
          Text(title)
            .width(16)
            .height(16)
            .borderRadius(8)
            .textAlign(TextAlign.Center)
            .fontSize(10)
            .fontColor($r('app.color.Color_31'))
            .margin({top: 2})
            .backgroundColor(this.selectIndex === index ? $r('app.color.Color_115_116_122') : Color.Transparent)
        })
        Row()
          .height(25)

      }
      .onTouch((event)=>{
        console.log(event.touches[0].y.toString())

        if (Math.floor((event.touches[0].y)/18) <= 0) {
          // 去搜索
          this.selectItem(-1)
          this.popHidden = Visibility.None
          return
        }

        if (event.type === TouchType.Down) {

          let index = Math.floor((event.touches[0].y)/18) - 1
          if (index > this.alphaData.length - 1) {
            index = this.alphaData.length - 1
          }
          this.popMarginTop = index*18 - 3
          this.popHidden = Visibility.Visible
          this.popTitle = this.alphaData[index]
          this.selectItem(index)
        } else if (event.type === TouchType.Move) {
          let index = Math.floor((event.touches[0].y)/18) - 1
          if (index > this.alphaData.length - 1) {
            index = this.alphaData.length - 1
          }
          this.popMarginTop = index*18 - 3
          this.popHidden = Visibility.Visible
          this.popTitle = this.alphaData[index]
          this.selectItem(index)
        } else if (event.type === TouchType.Up) {
          animateTo({duration: 150, curve: Curve.Linear}, ()=>{
            this.popHidden = Visibility.Hidden
          })
          setTimeout(()=>{
            this.popHidden = Visibility.None
          },300)
        }
      })
      .width(20)
      .borderRadius(10)

    }
    .alignItems(VerticalAlign.Top)
  }
}