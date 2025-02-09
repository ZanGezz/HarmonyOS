
@ObservedV2
export class CircleListModel {

  id?: number
  // 用户id
  user_id?: number
  // 用户名称
  nick_name?: string
  // 用户头像
  head_image?: string
  // 唯一标识该条朋友圈的id
  message_id?: number
  // 发文文案
  text?: string
  // 是否显示赞view
  @Trace showZanView?: boolean
  // 发文链接
  linkData?: CircleLinkModel
  // 发文图片
  imageData?: CircleImageModel[]
  // 发文地址
  locationData?: CircleLocationModel
  // 点赞
  @Trace zanData?: CircleZanModel[]
  // 评论
  @Trace pingData?: CirclePingModel[]
  // 时间戳
  time?: number

  constructor(param?: CircleListModel) {
    if (param) {
      this.user_id = param.user_id
      this.nick_name = param.nick_name
      this.head_image = param.head_image
      this.message_id = param.message_id
      this.text = param.text
      this.showZanView = param.showZanView
      this.linkData = param.linkData
      this.imageData = param.imageData
      this.locationData = param.locationData
      this.zanData = param.zanData
      this.pingData = param.pingData
      this.time = param.time
    }
  }
}

// 点赞模型
export interface CircleZanModel {
  id?: number
  // 唯一标识该条朋友圈的id
  message_id?: number
  // 用户id
  user_id?: number
  // 用户名称
  nick_name?: string
  // 时间戳
  time?: number
}

// 评论模型
export interface CirclePingModel {
  id?: number
  // 唯一标识该条朋友圈的id
  message_id?: number
  // 回复评论用户id
  a_user_id?: number
  // 回复评论用户名称
  a_nick_name?: string
  // 被回复评论用户id
  b_user_id?: number
  // 被回复评论用户名称
  b_nick_name?: string
  // 评论内容
  text?: string
  // 时间
  time?: number
}

// 地理位置模型
export interface CircleLocationModel {
  id?: number
  // 唯一标识该条朋友圈的id
  message_id?: number
  // 位置名
  location_name?: string
  // 纬度
  location_latitude?: number
  // 经度
  location_longitude?: number
}

// 网络链接模型
export interface CircleLinkModel {
  id?: number
  // 唯一标识该条朋友圈的id
  message_id?: number
  // 链接url
  link_url?: string
  // 链接头像
  link_image?: string
  // 链接内容
  link_text?: string
}

// 朋友圈图片模型
export interface CircleImageModel {
  id?: number
  // 唯一标识该条朋友圈的id
  message_id?: number
  // 图片url
  src?: string
  // 图片ID
  component_id?: string

  // 小图像时的位置尺寸
  imageSmallWidth?: number
  imageSmallHeight?: number
  imageSmallMLeft?: number
  imageSmallMTop?: number
  // 点击放大时的位置尺寸
  imageLargeWidth?: number
  imageLargeHeight?: number
  imageLargeMLeft?: number
  imageLargeMTop?: number
}