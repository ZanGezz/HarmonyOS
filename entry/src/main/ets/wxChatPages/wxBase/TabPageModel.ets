
export const TabBarData: TabPageModel[] = [
  {
    title: '微信',
    norImage: 'app.media.wechat',
    selectImage: 'app.media.wechat_select',
    index: 0
  },
  {
    title: '通讯录',
    norImage: 'app.media.contacts',
    selectImage: 'app.media.contacts_select',
    index: 1
  },
  {
    title: '发现',
    norImage: 'app.media.discover_normal',
    selectImage: 'app.media.discover_select',
    index: 2
  },
  {
    title: '我的',
    norImage: 'app.media.mine',
    selectImage: 'app.media.mine_select',
    index: 3
  }
]

export interface TabPageModel {
  title: string,
  norImage: string,
  selectImage: string,
  index: number
}