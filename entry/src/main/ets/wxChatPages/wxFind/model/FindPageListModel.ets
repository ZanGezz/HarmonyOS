import { userInfoModel } from '../../wxMine/model/wxUserInfoModel'
import { CircleListModel } from './FriendCircleListModel'

export const FindDataList: FindListModel[] = [
  {
    image: 'app.media.t01',
    title: '朋友圈',
    description: '',
    type: 1001
  },
  {
    image: 'app.media.t03',
    title: '视频号',
    description: '',
    type: 1002
  },
  {
    image: 'app.media.t11',
    title: '直播',
    description: '英雄联盟职业联赛直播中',
    type: 1001
  },
  {
    image: 'app.media.saoyisaoicon',
    title: '扫一扫',
    description: '',
    type: 1002
  },
  {
    image: 'app.media.tingyiting',
    title: '听一听',
    description: '',
    type: 1001
  },
  {
    image: 'app.media.fujin',
    title: '附近',
    description: '',
    type: 1001
  },
  {
    image: 'app.media.t18',
    title: '小程序',
    description: '',
    type: 1002
  }
]

export const alerts: alertItem[] = [
  {
    fontColor: 'app.color.Color_31',
    title: '拍摄',
    subTitle: '',
  },
  {
    fontColor: 'app.color.Color_31',
    title: '从手机相册选择',
    subTitle: '',
  },
  {
    fontColor: 'app.color.Color_31',
    title: '转发链接',
    subTitle: '',
  },
  {
    fontColor: 'app.color.Color_31',
    title: '取消',
    subTitle: '',
  }
]

export const deletes: alertItem[] = [
  {
    fontColor: 'app.color.Color_200_109_103',
    title: '删除',
    subTitle: '',
  },
  {
    fontColor: 'app.color.Color_31',
    title: '取消',
    subTitle: '',
  }
]

export interface FindListModel {
  image: string,
  title: string,
  description: string,
  type: number
}

export interface CircleParam {
  circleList: CircleListModel[],
  userInfo: userInfoModel
}

export interface alertItem {
  title: string,
  subTitle: string,
  fontColor: string
}