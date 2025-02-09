
import CommonHelper from '../../wxTools/CommonHelper'

/*
 * 首页列表room数据模型
 */

@ObservedV2
export class room {
  @Trace head_image: string = ''
  @Trace nick_name: string = ''
  // 最后一条聊天信息
  @Trace last_chat: string = ''
  user_id: number = 0
  room_id: string = ''
  // 0: 普通用户聊天房间 1: 微信传输助手 2: 微信运动 3: 订阅号 4: 微信团队
  type: number = 0
  // 总聊天条数
  total_chat: number = 0
  // 未读信息条数
  @Trace unread: number = 0
  // 1 表示置顶 0 表示普通
  @Trace stick: number = 0
  // 创建房间的时间
  time: number = 0
  // 最近删除房间的时间
  last_delete_time: number = 0
  // 房间删除状态 1：表示删除  0: 未删除
  isDelete: number = 0

  constructor(param?: room) {
    if (param) {
      this.head_image = param.head_image
      this.nick_name = param.nick_name
      this.last_chat = param.last_chat
      this.user_id = param.user_id
      this.room_id = param.room_id
      this.type = param.type
      this.total_chat = param.total_chat
      this.unread = param.unread
      this.stick = param.stick
      this.time = param.time
      this.last_delete_time = param.last_delete_time
      this.isDelete = param.isDelete
    }
  }
}

// 聊天内容
export interface chat {
  room_id?: string,
  nick_name?: string,
  head_image?: string,
  content?: string,
  time?: number,
  user_id?: number,
}

export const WXYunDong : ()=>room = ()=>{
  let newRoom = new room()
  newRoom.head_image = 'weixinyundong'
  newRoom.nick_name = '微信运动'
  newRoom.last_chat = '[应用消息]'
  newRoom.stick = 0
  newRoom.time = CommonHelper.getCurrentTimeinterval()
  newRoom.user_id = 100000006
  newRoom.type = 2
  return newRoom
}

export const WXTuanDui: ()=>room = ()=>{
  let newRoom = new room()
  newRoom.head_image = 'weixintuandui'
  newRoom.nick_name = '微信团队'
  newRoom.last_chat = '登录操作通知'
  newRoom.stick = 0
  newRoom.time = CommonHelper.getCurrentTimeinterval()
  newRoom.user_id = 100000002
  newRoom.type = 4
  return newRoom
}

export const WXDingYu: ()=>room = ()=>{
  let newRoom = new room()
  newRoom.head_image = 'dingyue'
  newRoom.nick_name = '订阅号'
  newRoom.last_chat = 'Hello HarmonyOS'
  newRoom.stick = 0
  newRoom.time = CommonHelper.getCurrentTimeinterval()
  newRoom.user_id = 100000005
  newRoom.type = 3
  return newRoom
}

export const WXChuanShu: ()=>room[] = ()=>{
  let room1 = new room()
  room1.head_image = 'wenjianchuanshuzhushou'
  room1.nick_name = '文件传输助手'
  room1.last_chat = '就算天再高那又怎样，踮起脚尖就更靠近阳光'
  room1.stick = 0
  room1.time = CommonHelper.getCurrentTimeinterval()
  room1.user_id = 100000001
  room1.room_id = 'wx_100000001_100000003'
  room1.type = 1
  let room2 = new room()
  room2.head_image = 'zange'
  room2.nick_name = '赞歌'
  room2.last_chat = '就算天再高那又怎样，踮起脚尖就更靠近阳光'
  room2.stick = 0
  room2.time = CommonHelper.getCurrentTimeinterval()
  room2.user_id = 100000003
  room2.room_id = 'wx_100000001_100000003'
  room2.type = 1
  return [room1,room2]
}

export const ZangeAndCangLang: ()=>room[] = ()=>{
  let room1 = new room()
  room1.head_image = 'IMG_4172'
  room1.nick_name = '沧浪'
  room1.last_chat = '你好啊，很高兴认识你！'
  room1.stick = 1
  room1.time = CommonHelper.getCurrentTimeinterval()
  room1.user_id = 100000001
  room1.room_id = 'wx_100000001_100000004'
  room1.type = 0
  let room2 = new room()
  room2.head_image = 'zange'
  room2.nick_name = '赞歌'
  room2.last_chat = '你好啊，很高兴认识你！'
  room2.stick = 1
  room2.time = CommonHelper.getCurrentTimeinterval()
  room2.user_id = 100000004
  room2.room_id = 'wx_100000001_100000004'
  room2.type = 0
  return [room1,room2]
}

export const WXChuanShuChat: chat[] = [
  {
    time: CommonHelper.getCurrentTimeinterval(),
    user_id: 101,
    room_id: 'wx_100000001_100000003'
  },
  {
    head_image: 'zange',
    nick_name: '赞歌',
    content: '就算天再高那又怎样，踮起脚尖就更靠近阳光',
    time: CommonHelper.getCurrentTimeinterval()+1,
    user_id: 100000001,
    room_id: 'wx_100000001_100000003'
  }
]

export const ZangeAndCangLangChat: chat[] = [
  {
    time: CommonHelper.getCurrentTimeinterval(),
    user_id: 101,
    room_id: 'wx_100000001_100000004'
  },
  {
    head_image: 'zange',
    nick_name: '赞歌',
    content: '你好啊，很高兴认识你！',
    time: CommonHelper.getCurrentTimeinterval()+1,
    user_id: 100000001,
    room_id: 'wx_100000001_100000004'
  }
]


