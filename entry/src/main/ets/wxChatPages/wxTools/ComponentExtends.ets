

export class MyRowModifier implements AttributeModifier<RowAttribute> {
  // 可以实现一个Modifier，定义私有的成员变量，外部可动态修改
  isDark: boolean = false

  // 通过构造函数，创建时传参
  constructor(dark?: boolean) {
    this.isDark = dark ? dark : false
  }

  applyNormalAttribute(instance: RowAttribute): void {
    // instance为Button的属性对象，可以通过instance对象对属性进行修改
    if (this.isDark) { // 支持业务逻辑的编写
      // 属性变化触发apply函数时，变化前已设置并且变化后未设置的属性会恢复为默认值
      instance.backgroundColor('#707070')
    } else {
      // 支持属性的链式调用
      instance.backgroundColor('#17A98D')
        .borderColor('#707070')
        .borderWidth(2)
    }
    instance.onClick(()=>{

    })
  }
}