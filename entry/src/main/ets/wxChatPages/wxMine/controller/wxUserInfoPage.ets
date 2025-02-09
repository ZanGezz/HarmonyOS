import { NaviPage } from '../../wxBase/NaviPage'
import { Constants } from '../../wxTools/Constants'
import CommonInstance from '../../wxTools/wxCommonInstance'
import { IUserInfoModel, userInfoModel } from '../model/wxUserInfoModel'
import { UserInfoPageCell, UserInfoPageHeadImageCell } from '../views/UserInfoPageCell'
import { ChangeUserInfoPage, UserInfoType } from './wxChangeUserInfoPage'
import UserDataManager from '../UserDataManager/UserDataManager'

@ComponentV2
export struct UserInfoPage {

  @Param @Require stack: NavPathStack = new NavPathStack()
  @Local userInfo: userInfoModel = new userInfoModel(this.stack.getParamByName('UserInfoPage')[0] as IUserInfoModel)
  @Local changeUserInfo: boolean = false

  @Builder footer() {
    Row()
      .height(10)
      .width('100%')
  }

  @Builder changeUserInfoBuilder() {
    ChangeUserInfoPage({stack: this.stack, type: UserInfoType.userName, pageDismiss: () => {
      this.changeUserInfo = false
      this.userInfo.nick_name = CommonInstance.crrentUserInfo.nick_name
    }})
      .height('100%')
  }

  build() {
    NavDestination() {
      Column() {
        NaviPage({
          title: '个人信息',
          currentNavi: this.stack,
          backAction: ()=>{
            this.stack.pop(this.userInfo)
          }
        })
        // 列表
        List() {
          ListItemGroup({footer: this.footer()}) {
            ListItem() {
              UserInfoPageHeadImageCell({title: '头像', head_image: this.userInfo.head_image, ChangeHeadImage: (headImage: string) => {
                CommonInstance.crrentUserInfo.head_image = headImage
                UserDataManager.updateUserInfo((success)=>{
                  if (success) {
                    this.userInfo.head_image = headImage
                  } else {
                    CommonInstance.crrentUserInfo.head_image = this.userInfo.head_image
                  }
                })
              }})
            }

            ListItem() {
              UserInfoPageCell({title: '名字', content: this.userInfo.nick_name})
            }
            .bindContentCover(this.changeUserInfo, this.changeUserInfoBuilder())
            .onClick(()=>{
              this.changeUserInfo = true
            })

            ListItem() {
              UserInfoPageCell({title: '拍一拍', content: '么么哒'})
            }
            ListItem() {
              UserInfoPageCell({title: '微信号', content: String(this.userInfo.wechat_id)})
            }
            ListItem() {
              UserInfoPageCell({title: '我的二维码'})
            }
            ListItem() {
              UserInfoPageCell({title: '更多'})
            }
            .onClick(()=>{
              this.stack.pushPathByName('UserInfoMorePage', this.userInfo, (userInfo)=>{
                let userInfoCallBack: userInfoModel = userInfo.result as userInfoModel
                this.userInfo = userInfoCallBack
              })
            })
          }
          ListItemGroup({footer: this.footer()}) {
            ListItem() {
              UserInfoPageCell({title: '来电铃声'})
            }
          }
          ListItemGroup({footer: this.footer()}) {
            ListItem() {
              UserInfoPageCell({title: '微信豆'})
            }
          }
          ListItemGroup({footer: this.footer()}) {
            ListItem() {
              UserInfoPageCell({title: '我的地址'})
            }
          }
        }
        .scrollBarWidth(2.0)
        .edgeEffect(EdgeEffect.Spring, {alwaysEnabled: true})
        .height(Constants.SCREEN_HEIGHT - Constants.NAVI_HEIGHT)
        .backgroundColor($r('app.color.Color_237'))
      }
    }
    .hideTitleBar(true)
  }
}