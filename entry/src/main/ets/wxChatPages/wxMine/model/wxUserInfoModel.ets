
export interface IUserInfoModel {
  first_latter?: string
  head_image?: string
  nick_name?: string
  user_sex?: number
  user_area?: string
  user_age?: number
  wechat_id?: string
  user_id?: number
  cover_image?: string
  personal_signature?: string
}

@ObservedV2
export class userInfoModel {
  @Trace first_latter?: string
  @Trace head_image?: string
  @Trace nick_name?: string
  @Trace user_sex?: number
  @Trace user_area?: string
  @Trace user_age?: number
  wechat_id?: string
  user_id?: number
  @Trace cover_image?: string
  @Trace personal_signature?: string
  constructor(param?: IUserInfoModel) {
    if (param) {
      this.head_image = param.head_image
      this.nick_name = param.nick_name
      this.first_latter = param.first_latter
      this.user_id = param.user_id
      this.wechat_id = param.wechat_id
      this.user_sex = param.user_sex
      this.user_area = param.user_area
      this.user_age = param.user_age
      this.cover_image = param.cover_image
      this.personal_signature = param.personal_signature
    }
  }
}

// 创建用户微信团队
export const UserWXTuanDui: userInfoModel = new userInfoModel({
  nick_name: '微信团队',
  head_image: 'weixintuandui',
  cover_image: 'IMG_3951',
  user_age: 18,
  user_sex: 1,
  user_area: '中国大陆',
  user_id: 100000002,
  wechat_id: 'wx_100000002',
  first_latter: 'W',
  personal_signature: '暂无'
})

// 创建用户微信传输助手
export const UserWXChuanShu: userInfoModel = new userInfoModel({
  nick_name: '文件传输助手',
  head_image: 'wenjianchuanshuzhushou',
  cover_image: 'IMG_3952',
  user_age: 18,
  user_sex: 1,
  user_area: '中国大陆',
  user_id: 100000003,
  wechat_id: 'wx_100000003',
  first_latter: 'W',
  personal_signature: '暂无'
})

// 默认创建用户
export const defaultUser: userInfoModel = new userInfoModel({
  nick_name: '赞歌',
  head_image: 'zange',
  cover_image: 'IMG_3953',
  user_age: 18,
  user_sex: 1,
  user_area: '中国大陆',
  user_id: 100000001,
  wechat_id: 'wx_100000001',
  first_latter: 'Z',
  personal_signature: '就是天再高那有怎样，踮起脚尖就更靠近阳光！'
})

// 创建用户仓浪
export const UserCangLang: userInfoModel = new userInfoModel({
  nick_name: '沧浪',
  head_image: 'IMG_4172',
  cover_image: 'IMG_36',
  user_age: 18,
  user_sex: 0,
  user_area: '中国大陆',
  user_id: 100000004,
  wechat_id: 'wx_100000004',
  first_latter: 'C',
  personal_signature: '没有个性，不敢签名！'
})

export const mineDataList: mineListModel[][] = [
  [
    {
      "image": "app.media.t06",
      "title": "服务"
    }
  ],
  [
    {
      "image": "app.media.t07",
      "title": "收藏"
    },
    {
      "image": "app.media.wodepengyouquan",
      "title": "朋友圈"
    },
    {
      "image": "app.media.t10",
      "title": "卡包"
    },
    {
      "image": "app.media.t09",
      "title": "表情"
    }
  ],
  [
    {
      "image": "app.media.t04",
      "title": "设置"
    }
  ]
]

export interface mineListModel {
  image?: string,
  title?: string
}