@Entry
@ComponentV2
struct Index {

  // 本项目仅支持 DevEco Studio NEXT编译器, API版本 12, HarmonyOS 5.0.0及其以后版本
  @Local message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}