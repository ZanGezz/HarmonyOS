
import { room } from '../model/wxChatListModel'
import { Request } from '../../Request/Request'
import http from '@ohos.net.http'

// 聊天列表地址
export const chatListURL = 'wxChatListData'
// 聊天列表置顶
export const chatHeadListURL = 'wxChatListHeadData'

export enum DataManageType {
  create,  // 增
  delete,  // 删
  update,  // 改
  retrieve // 查
}
/*
 * 获取首页聊天列表数据 json-server查询数据用get 用post携带参数param可将param插入数据库
 * this.ChatListData = await getChatListData(chatListURL,DataManageType.retrieve,undefined)
 */
export const getChatListData = (url: string, type: DataManageType = DataManageType.retrieve, param?: room) => {

  let method: http.RequestMethod = http.RequestMethod.GET
  switch (type) {
    case DataManageType.create:
      method = http.RequestMethod.GET
      break;
    case DataManageType.delete:
      method = http.RequestMethod.DELETE
      break;
    case DataManageType.update:
      method = http.RequestMethod.PUT
      break;
    case DataManageType.retrieve:
      method = http.RequestMethod.GET
      break;
    default:
      method = http.RequestMethod.GET
      break;
  }
  return Request.requestData<room[]>(url, param, method)
}
