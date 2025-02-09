
import { NaviPage } from '../../wxBase/NaviPage'
import { userInfoModel } from '../../wxMine/model/wxUserInfoModel'
import CommonHelper from '../../wxTools/CommonHelper'
import { HeadImageArray, CoverImageArray } from '../../wxBase/ImageDataModel'
import DataManager from '../../wxMine/UserDataManager/UserDataManager';
import Logger from  '../../wxTools/Logger'
import HMEmitter from  '../../wxTools/HMEmitter'

import { PAGE_TYPE } from  '../../wxTools/wxCommonInstance'

@ComponentV2
export struct wxAddFriendsPage {

  @Param @Require stack: NavPathStack
  @Local textInputController: TextInputController = new TextInputController()
  // 标题
  @Local title: string = '添加朋友'
  // 头像图片
  @Local head_image: string = 'zange'
  // 输入的内容
  @Local inputContent: string = ''


  // 存储生成的用户
  private saveWithNewUser() {

    // 获取当前时间戳做user_id
    let user_id = CommonHelper.getCurrentTimeinterval()
    // 随机生成背景图片
    let cover_image = CoverImageArray[CommonHelper.getRandomNumber(3) % CoverImageArray.length]
    // 昵称首字母
    let letters = CommonHelper.exchangeChineseToChar(this.inputContent)
    // 随机生成性别
    let sex = CommonHelper.getRandomNumber(1) % 2
    // 随机生成年龄
    let age = CommonHelper.getRandomNumber(2)
    // area
    let area = '中国大陆'

    let new_user: userInfoModel = new userInfoModel({
      // 昵称首字母
      first_latter: letters[1],
      // 随机生成9位数的用户id
      user_id: user_id,
      // 昵称
      nick_name: this.inputContent,
      // 微信号 用户为id后九位
      wechat_id: 'wx_' + String(user_id).substring(4, 13),
      // 头像
      head_image: this.head_image,
      // 朋友圈背景图片 从图片库随机获取
      cover_image: cover_image,
      // 随机生成性别
      user_sex: sex,
      // area
      user_area: area,
      // 随机生成年龄
      user_age: age,
      // 个性签名
      personal_signature: '暂无签名, 赶紧去设置一个吧！'
    })

    DataManager.createNewUser(new_user, (isSuccess)=>{
      Logger.info(String(isSuccess))
      if (isSuccess) {
        // 更新指定页面
        HMEmitter.emit(1,JSON.stringify([PAGE_TYPE.address]))
      }
      // pop 有返回参数时，会触发上个页面的回掉函数
      this.stack.pop()
    })
  }

  // 右边按钮
  @Builder completeButton() {
    Text('完成')
      .fontSize(16)
      .fontColor($r('app.color.Color_31'))
      .margin({right: 15})
      .onClick((event)=>{
        // 点击按钮，存储好友
        this.saveWithNewUser()
      })
  }

  build() {
    NavDestination() {
      Column() {
        // 导航头
        NaviPage({
          title: this.title,
          currentNavi: this.stack,
          rightButton: this.completeButton.bind(this)
        })

        // 添加朋友view
        Column() {
          Text('切换头像')
            .fontSize(20)
            .fontWeight(600)
            .fontColor($r('app.color.Color_31'))
            .margin({top: 15})
            .onClick(event=>{
              // 点击更换头像
              this.head_image = HeadImageArray[CommonHelper.getRandomNumber(3) % HeadImageArray.length]
            })
          Image($r(`app.media.${this.head_image}`))
            .width(120)
            .height(120)
            .borderRadius(8)
            .margin({top: 15})
            .onClick(event=>{
              // 点击更换头像
              this.head_image = HeadImageArray[CommonHelper.getRandomNumber(3) % HeadImageArray.length]
            })
          Row() {
            Text('昵称：')
              .fontSize(16)
              .fontColor($r('app.color.Color_31'))
              .margin({left: 15})

            TextInput({controller: this.textInputController, placeholder: '请输入昵称'})
              .placeholderColor($r('app.color.Color_179'))
              .placeholderFont({size: 16})
              .fontColor($r('app.color.Color_31'))
              .backgroundColor(Color.Transparent)
              .maxLength(8)
              .width(195)
              .enableKeyboardOnFocus(true)
              .height(50)
              .caretColor($r('app.color.Color_Tab_select'))
              .margin({left: -15})
              .key('TextInputNickName')
              .onChange((value: string) => {
                this.inputContent = value
              })
              .cancelButton({
                style: CancelButtonStyle.CONSTANT,
                icon: {
                  size: 20,
                  src: $r('app.media.delete'),
                }
              })
          }
          .margin({top: 50})
          .backgroundColor($r('app.color.Color_210'))
          .height(50)
          .width(240)
          .borderRadius(25)
        }
        .width(300)
        .height(300)
        .borderRadius(40)
        .margin({top: 150})
        .backgroundColor($r('app.color.Color_237'))
      }
      .height('100')
      .alignItems(HorizontalAlign.Center)
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.Color_210'))
    .onClick((event)=>{
      this.textInputController.stopEditing()
    })
  }

  aboutToAppear(): void {
    setTimeout(()=>{
      focusControl.requestFocus('TextInputNickName')
    },250)
  }
}