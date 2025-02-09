import { NaviPage } from '../../wxBase/NaviPage'
import { Constants } from '../../wxTools/Constants'
import CommonInstance from '../../wxTools/wxCommonInstance'
import { IUserInfoModel, userInfoModel } from '../model/wxUserInfoModel'
import { UserInfoPageCell } from '../views/UserInfoPageCell'
import { ChangeUserInfoPage, UserInfoType } from './wxChangeUserInfoPage'

@ComponentV2
export struct UserInfoMorePage {

  @Param @Require stack: NavPathStack = new NavPathStack()
  @Local userInfo: userInfoModel = new userInfoModel(this.stack.getParamByName('UserInfoMorePage')[0] as IUserInfoModel)
  @Local changeUserInfo: boolean = false
  @Local changeType: UserInfoType = UserInfoType.userName

  @Builder footer() {
    Row()
      .height(10)
      .width('100%')
  }

  @Builder changeUserInfoBuilder() {
    ChangeUserInfoPage({stack: this.stack, type: this.changeType, pageDismiss: () => {
      this.changeUserInfo = false

      if (this.changeType === UserInfoType.userSex) {
        this.userInfo.user_sex = CommonInstance.crrentUserInfo.user_sex
      } else if (this.changeType === UserInfoType.userArea) {
        this.userInfo.user_area = CommonInstance.crrentUserInfo.user_area
      } else if (this.changeType === UserInfoType.userSignature) {
        this.userInfo.personal_signature = CommonInstance.crrentUserInfo.personal_signature
      } else if (this.changeType === UserInfoType.userAge) {
        this.userInfo.user_age = CommonInstance.crrentUserInfo.user_age
      }

    }})
      .height('100%')
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          NaviPage({
            title: '',
            currentNavi: this.stack,
            backAction: () =>{
              this.stack.pop(this.userInfo)
            }
          })
          // 列表
          List() {
            ListItemGroup({footer: this.footer()}) {
              ListItem() {
                UserInfoPageCell({title: '性别', content: this.userInfo.user_sex == 0 ? '女' : '男'})
              }
              .onClick(()=>{
                this.changeType = UserInfoType.userSex
                this.changeUserInfo = true
              })

              ListItem() {
                UserInfoPageCell({title: '地区', content: this.userInfo.user_area})
              }
              .onClick(()=>{
                this.changeType = UserInfoType.userArea
                this.changeUserInfo = true
              })

              ListItem() {
                UserInfoPageCell({title: '年龄', content: String(this.userInfo.user_age)})
              }
              .onClick(()=>{
                this.changeType = UserInfoType.userAge
                this.changeUserInfo = true
              })

              ListItem() {
                UserInfoPageCell({title: '个性签名', content: this.userInfo.personal_signature})
              }
              .onClick(()=>{
                this.changeType = UserInfoType.userSignature
                this.changeUserInfo = true
              })
            }
          }
          .scrollBarWidth(2.0)
          .edgeEffect(EdgeEffect.Spring, {alwaysEnabled: true})
          .height(Constants.SCREEN_HEIGHT - Constants.NAVI_HEIGHT)
          .backgroundColor($r('app.color.Color_237'))
        }

        if (this.changeUserInfo) {
          this.changeUserInfoBuilder()
        }
      }
    }
    .hideTitleBar(true)
  }

  aboutToDisappear(): void {
    console.log('UserInfoPage UserInfoMorePage')
  }
}