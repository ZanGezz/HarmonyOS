
// Menu 数据模型
export interface ChatListMenu {
  image: string,
  title: string
}
// Menu 数据
export const ChatListMenuData: ChatListMenu[] = [
  {
    image: 'faqiqunliao',
    title: '发起群聊'
  },
  {
    image: 'tianjiapengyou',
    title: '添加朋友'
  },
  {
    image: 'saoyisao_w',
    title: '扫一扫'
  },
  {
    image: 'shoufukuan',
    title: '收付款'
  },
  {
    image: 'qiehuan_w',
    title: '切换用户'
  }
]

@ComponentV2
export struct ChatListMenuCell {

  @Param @Once image: string = ''
  @Param @Once title: string = ''

  build() {
    Row() {
      Image($r(`app.media.${this.image}`))
        .height(30)
        .width(30)
        .margin({left: 10})
      Column() {
        Text(this.title)
          .height(50)
          .fontSize(18)
          .fontWeight(500)
          .textAlign(TextAlign.Start)
          .fontColor($r('app.color.wxWhiteColor'))
          .width(80)
        Row()
          .width(90)
          .height(1)
          .backgroundColor($r('app.color.Color_100'))
      }
      .height(50)
      .margin({left: 10})
    }
  }
}