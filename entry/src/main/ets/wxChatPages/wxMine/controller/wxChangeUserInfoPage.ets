import { Constants } from '../../wxTools/Constants'
import Logger from '../../wxTools/Logger'
import CommonInstance from '../../wxTools/wxCommonInstance'
import UserDataManager from '../UserDataManager/UserDataManager'
import { NaviPage } from '../../wxBase/NaviPage'

export enum UserInfoType {
  userName,
  userSex,
  userArea,
  userAge,
  userSignature
}

@ComponentV2
export struct ChangeUserInfoPage {

  @Param @Require stack: NavPathStack = new NavPathStack()
  @Local inputController: TextInputController = new TextInputController()
  @Local newinputContent: string = ''
  @Local oldinputContent: string = ''
  @Local title: string = ''
  @Local translateY: number = Constants.SCREEN_HEIGHT
  @Local InputOnFocus: boolean = false
  @Param @Once type: UserInfoType = UserInfoType.userName

  @Event pageDismiss: ()=>void = () => {}


  // 页面消失
  aboutToDisappear(): void {
    animateTo({
      duration: 200,
      curve: Curve.Linear
    },()=>{
      this.translateY = Constants.SCREEN_HEIGHT
    })
  }
  // 页面出现
  aboutToAppear(): void {

    animateTo({
      duration: 200,
      curve: Curve.Linear
    },()=>{
      this.translateY = 0
    })

    if (this.type === UserInfoType.userName) {

      this.oldinputContent = CommonInstance.crrentUserInfo.nick_name!
      this.newinputContent = CommonInstance.crrentUserInfo.nick_name!
      this.title = '设置昵称'
    } else if (this.type === UserInfoType.userSex) {

      this.oldinputContent = CommonInstance.crrentUserInfo.user_sex! == 1 ? '男' : '女'
      this.newinputContent = CommonInstance.crrentUserInfo.user_sex! == 1 ? '男' : '女'
      this.title = '设置性别'
    } else if (this.type === UserInfoType.userArea) {

      this.oldinputContent = CommonInstance.crrentUserInfo.user_area!
      this.newinputContent = CommonInstance.crrentUserInfo.user_area!
      this.title = '设置地区'
    } else if (this.type === UserInfoType.userAge) {

      this.oldinputContent = CommonInstance.crrentUserInfo.user_age!.toString()
      this.newinputContent = CommonInstance.crrentUserInfo.user_age!.toString()
      this.title = '设置年龄'
    } else if (this.type === UserInfoType.userSignature) {

      this.oldinputContent = CommonInstance.crrentUserInfo.personal_signature!
      this.newinputContent = CommonInstance.crrentUserInfo.personal_signature!
      this.title = '设置个性签名'
    }
  }

  // 完成按钮
  @Builder complete() {
    Text('完成')
      .fontSize(14)
      .width(46)
      .height(30)
      .margin({right: 20})
      .borderRadius(6)
      .fontColor(Color.White)
      .textAlign(TextAlign.Center)
      .backgroundColor($r('app.color.Color_115_116_122'))
      .onClick(()=>{

        if (this.newinputContent === this.oldinputContent) {
          this.pageDismiss()
          this.translateY = Constants.SCREEN_HEIGHT
          return
        }

        if (this.type === UserInfoType.userName) {
          CommonInstance.crrentUserInfo.nick_name = this.newinputContent
        } else if (this.type === UserInfoType.userSex) {
          CommonInstance.crrentUserInfo.user_sex = this.newinputContent === '男' ? 1 : 0
        } else if (this.type === UserInfoType.userArea) {
          CommonInstance.crrentUserInfo.user_area = this.newinputContent
        } else if (this.type === UserInfoType.userSignature) {
          CommonInstance.crrentUserInfo.personal_signature = this.newinputContent
        } else if (this.type === UserInfoType.userAge) {
          CommonInstance.crrentUserInfo.user_age = Number(this.newinputContent)
        }

        UserDataManager.updateUserInfo((success)=>{

          if (!success) {
            if (this.type === UserInfoType.userName) {
              CommonInstance.crrentUserInfo.nick_name = this.oldinputContent
            } else if (this.type === UserInfoType.userSex) {
              CommonInstance.crrentUserInfo.user_sex = this.oldinputContent === '男' ? 1 : 0
            } else if (this.type === UserInfoType.userArea) {
              CommonInstance.crrentUserInfo.user_area = this.oldinputContent
            } else if (this.type === UserInfoType.userSignature) {
              CommonInstance.crrentUserInfo.personal_signature = this.oldinputContent
            } else if (this.type === UserInfoType.userAge) {
              CommonInstance.crrentUserInfo.user_age = Number(this.oldinputContent)
            }
          }

          this.translateY = Constants.SCREEN_HEIGHT
          this.pageDismiss()
        })
      })
  }

  // UI
  build() {
    Column() {
      NaviPage({
        title: this.title,
        currentNavi: new NavPathStack(),
        rightButton: this.complete.bind(this),
        backAction: () => {
          this.translateY = Constants.SCREEN_HEIGHT
          this.pageDismiss()
        }
      })
      TextInput({controller: this.inputController, text: this.newinputContent})
        .placeholderFont({size: 16})
        .placeholderColor($r('app.color.Color_179'))
        .width(Constants.SCREEN_WIDTH)
        .height(55)
        .borderRadius(0)
        .backgroundColor(Color.White)
        .fontSize(16)
        .fontColor($r('app.color.Color_31'))
        .caretColor($r('app.color.Color_Tab_select'))
        .id('ChangeUserInfo_a')
        .onChange((value: string)=>{
          Logger.info(value)
          this.newinputContent = value
        })
        .onAppear(()=>{
          setTimeout(()=>{
            focusControl.requestFocus('ChangeUserInfo_a')
          }, 250)
        })
    }
    .onClick(()=>{
      this.inputController.stopEditing()
    })
    .translate({y: this.translateY})
    .backgroundColor($r('app.color.Color_237'))
    .height('100%')
    .width('100%')
  }
}