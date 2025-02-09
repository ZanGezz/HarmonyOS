
import Logger from  '../../wxTools/Logger'
import { NaviPage } from '../../wxBase/NaviPage'
import { FindPageListCell } from '../views/FindPageListCell'
import { FindDataList, FindListModel } from '../model/FindPageListModel'
import { Constants } from '../../wxTools/Constants'
import { PushToPage } from '../../wxBase/PushToPage'
import { CircleListModel } from '../model/FriendCircleListModel'
import { FriendsCircle } from  './wxFriendsCirclePage'
import { MomentController } from '../model/MomentController'

@ComponentV2
export struct wxFindPage {

  @Local FindNaviStack: NavPathStack = new NavPathStack()
  @Local controller: MomentController = new MomentController()
  // TabBar插槽
  @BuilderParam TabBarSlot: ()=>void
  @Local CircleListData: CircleListModel[] = []
  @Local MomentPageTranlateX: number = Constants.SCREEN_WIDTH

  // 跳转朋友圈
  DidSelectRow(item: FindListModel) {
    if (item.title == '朋友圈') {
      this.controller.reloadData()
      this.MomentPageTranlateX = 0
    }
  }

  @Builder MomentPage() {
    Column() {
      FriendsCircle({
        stack: this.FindNaviStack,
        MomentManager: this.controller,
        onBackClick: ()=>{
          Logger.info('FriendsCircle 返回')
          this.MomentPageTranlateX = Constants.SCREEN_WIDTH
        }
      })
    }
    .width('100%')
    .height('100%')
    .translate({x: this.MomentPageTranlateX})
    .animation({
      duration: 200,
      curve: Curve.Linear
    })
  }

  // push 跳转页面
  @Builder PushToPageBuilder(name: string) {
    PushToPage({desNaviPageName: name, stack: this.FindNaviStack})
  }

  // UI
  build() {
    Navigation(this.FindNaviStack) {
      Stack() {
        Column() {
          // 导航头
          NaviPage({
            currentNavi: this.FindNaviStack,
            title: '发现',
            showBackButton: Visibility.Hidden
          })
          // 列表
          List() {
            ForEach((FindDataList), (item: FindListModel, index: number) => {
              ListItem() {
                FindPageListCell({item: item})
              }
              .onClick((event)=>{
                this.DidSelectRow(item)
              })
            })
          }
          .scrollBarWidth(2.0)
          .edgeEffect(EdgeEffect.Spring, {alwaysEnabled: true})
          .height(Constants.SCREEN_HEIGHT - Constants.NAVI_HEIGHT)
          .backgroundColor($r('app.color.Color_237'))
        }
        .height('100%')
        // TabBar插槽
        this.TabBarSlot()
        // 朋友圈页面
        this.MomentPage()
      }
      .alignContent(Alignment.Bottom)
    }
    .hideTitleBar(true)
    .navDestination(this.PushToPageBuilder)
  }
}

