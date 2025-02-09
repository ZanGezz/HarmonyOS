import Logger from  '../../wxTools/Logger'
import { IUserInfoModel, mineListModel, userInfoModel } from '../model/wxUserInfoModel'
import { mineDataList } from '../model/wxUserInfoModel'
import { Constants, Strings } from '../../wxTools/Constants'
import { minePageCell } from '../views/MinePageCell'
import { PushToPage } from '../../wxBase/PushToPage'
import CommonInstance, { PAGE_TYPE } from  '../../wxTools/wxCommonInstance'
import PreferenceHelper from  '../../wxTools/PreferenceHelper'
import DataManager from  '../UserDataManager/UserDataManager'
import HMEmitter from  '../../wxTools/HMEmitter'

@ComponentV2
export struct wxMinePage {

  @Local mineNaviStack: NavPathStack = new NavPathStack()

  @Local ListContentOffSet: number = 0
  // TabBar插槽
  @BuilderParam TabBarSlot: ()=>void
  // 用户信息 { head_image: '', nick_name: '' }
  @Local userInfo: userInfoModel = new userInfoModel({ head_image: '', nick_name: '' })

  // push 跳转页面
  @Builder PushToPageBuilder(name: string) {
    PushToPage({desNaviPageName: name, stack: this.mineNaviStack})
  }
  // 搭建UI
  build() {
    Navigation(this.mineNaviStack) {
      Stack() {
        List() {
          ForEach(mineDataList, (itemList: mineListModel[], index: number)=>{
            ListItemGroup({
              header: this.HeaderInfo(index),
            }) {
              ForEach(itemList, (item: mineListModel)=>{
                ListItem() {
                  minePageCell({item: item, addBottomLine: index == 1 ? true : false})
                }
                .onClick(()=>{
                  if (item.title === '设置') {
                    this.mineNaviStack.pushPathByName('UserSettingPage', this.userInfo)
                  }
                })
              })
            }
          })
        }
        .scrollBarWidth(2.0)
        .clip(true)
        .backgroundColor($r('app.color.Color_237'))
        // 设置List不满屏幕时边缘弹动
        .edgeEffect(EdgeEffect.Spring, {alwaysEnabled: true})
        .height('100%')

        // TabBar插槽
        this.TabBarSlot()
      }
      .alignContent(Alignment.Bottom)
    }
    .hideTitleBar(true)
    .navDestination(this.PushToPageBuilder)
  }

  @Builder HeaderInfo(index: number) {
    if (index == 0) {
      Column() {

        Row()
          .height(60+400)
          .width('100%')
          .backgroundColor($r('app.color.wxWhiteColor'))

        Row() {
          Image($r(`app.media.${this.userInfo.head_image}`))
            .width(60)
            .height(60)
            .borderRadius(8.0)
            .margin({left:30})

          Column() {
            Text(this.userInfo.nick_name)
              .fontSize(20)
              .fontWeight(600)
              .fontColor($r('app.color.Color_31'))
              .margin({top: 34})
            Row() {

              Text('微信号：')
                .fontSize(16)
                .fontColor($r('app.color.Color_139'))

              Text(this.userInfo.wechat_id)
                .fontSize(16)
                .fontColor($r('app.color.Color_139'))

              Blank()

              Image($r('app.media.t05'))
                .width(22)
                .height(22)
                .margin({right:12})

              Image($r('app.media.youjiantou'))
                .width(24)
                .height(24)
                .margin({right:13})
            }
            .margin({top: 6})
            .width(Constants.SCREEN_WIDTH - 110)

            Text('+ 状态')
              .fontSize(14)
              .fontColor($r('app.color.Color_139'))
              .width(62)
              .height(23)
              .borderRadius(12.5)
              .borderWidth(1)
              .borderColor($r('app.color.Color_237'))
              .margin({top:7})
              .textAlign(TextAlign.Center)
          }
          .alignItems(HorizontalAlign.Start)
          .margin({left: 15})
        }
        .height(165)
        .width('100%')
        .backgroundColor($r('app.color.wxWhiteColor'))
        .onClick((event) => {
          this.mineNaviStack.pushPathByName('UserInfoPage',this.userInfo, (userInfo)=>{
            Logger.info(JSON.stringify(userInfo.result))
            let userInfoCallBack: userInfoModel = userInfo.result as userInfoModel
            this.userInfo = userInfoCallBack
          })
        })

        Divider()
          .height(10)
          .width('100%')
          .color($r('app.color.Color_237'))
      }
      .margin({top: -400})
    } else {
      Divider()
        .height(10)
        .width('100%')
        .color($r('app.color.Color_237'))
    }
  }

  aboutToAppear(): void {
    // 获取首页列表数据
    this.getUserInfo()
    HMEmitter.on(1, (param: string)=>{
      Logger.info('HMEmitter')
      let types: PAGE_TYPE[] = JSON.parse(param)
      // 获取首页列表数据
      for (let i = 0; i < types.length; i ++) {
        let type = types[i]
        if (type == PAGE_TYPE.mine) {
          // 获取微信页面数据
          this.getUserInfo()
        }
      }
    })
  }

  // 获取我的页面数据
  getUserInfo() {
    let user_id = PreferenceHelper.quary(Strings.USER_ID) as number
    DataManager.queryUserWithID(user_id, (result)=>{
      if (result.length > 0) {
        this.userInfo = new userInfoModel(result[0] as IUserInfoModel)
        CommonInstance.crrentUserInfo = result[0]
        Logger.info(String(user_id))
        Logger.info('queryUserWithID')
      }
    })
  }
}