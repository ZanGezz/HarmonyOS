
import { relationalStore } from '@kit.ArkData'
import DataRDBStore, { TABLE_TYPE } from '../../wxTools/DataRDBStore'
import Logger from '../../wxTools/Logger'
import { chat, room } from '../model/wxChatListModel'

class ChatListDataManager {
  // 查询首页列表数据
  queryChatListData(user_id: number, callBack: (result: room[])=>void, stick: number = 0, offset: number = 0, size: number = 20) {

    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.ChatRoom)
    predicate.equalTo('user_id', user_id)
    // stick = 1 表示置顶
    predicate.equalTo('stick', stick)
    // 按time倒序查询
    predicate.orderByDesc('id')
    // 查询条数
    predicate.limitAs(size)
    // 查询id为 (page-1)*size到page*size 之间的数据
    predicate.offsetAs(offset)

    DataRDBStore.quaryData<room>(TABLE_TYPE.ChatRoom, (result) => {
      if (callBack !== undefined) {
        let roomArray: room[] = result.sort((a, b)=>b.time!-a.time!)
        let newArray: room[] = []
        for (let i = 0; i < roomArray.length; i ++) {
          let param: room = roomArray[i]
          if (param.isDelete === 0) {
            newArray.push(param)
          }
        }
        callBack(newArray)
        Logger.info(JSON.stringify(newArray))
      }
    }, predicate)
  }

  // 聊天内容
  queryChatData(room: room, callBack: (result: chat[])=>void, offset: number = 0, size: number = 20) {
    // 根据room_id 查询聊天内容
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.Chat)
    predicate.equalTo('room_id', room.room_id!)
    // 按id倒序
    predicate.orderByDesc('id')
    // 大于删除时间的聊天记录
    predicate.greaterThan('time', room.last_delete_time)
    // 查询条数
    predicate.limitAs(size)
    // 查询id为 (page-1)*size到page*size 之间的数据
    predicate.offsetAs(offset)
    // 获取数据
    DataRDBStore.quaryData<chat>(TABLE_TYPE.Chat, (result) => {
      if (callBack !== undefined) {
        callBack(result.sort((a, b)=>a.time!-b.time!))
        Logger.info(JSON.stringify(result))
      }
    }, predicate)
  }

  // 删除该用户的聊天
  deleteChatRoom(room_id: string, callBack: (stutas: Boolean) => void = (stutas: Boolean)=>{}) {
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.ChatRoom)
    predicate.equalTo('room_id', room_id)
    DataRDBStore.deleteData(TABLE_TYPE.ChatRoom, (isSuccess) => {
      callBack(isSuccess)
    },predicate)
  }

  // 删除聊天内容
  deleteChat(room_id: string, callBack: (stutas: boolean) => void = (stutas: boolean)=>{}) {
    let predicate1: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.Chat)
    predicate1.equalTo('room_id', room_id)
    DataRDBStore.deleteData(TABLE_TYPE.Chat,(success)=>{
      callBack(success)
    },predicate1)
  }

  // 根据两个用户之间有没有ChatRoom
  quaryChatRoom(user_ids: number[],callBack: (hasRoom: boolean, result: room[])=>void) {
    let room_id1 = 'wx_'+String(user_ids[0])+'_'+String(user_ids[1])
    let room_id2 = 'wx_'+String(user_ids[1])+'_'+String(user_ids[0])
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.ChatRoom)
    predicate.equalTo('room_id', room_id1).or().equalTo('room_id', room_id2)
    DataRDBStore.quaryData<room>(TABLE_TYPE.ChatRoom,(result)=>{
      Logger.info(JSON.stringify(result))
      if (result.length > 0) {
        if (callBack != undefined) {
          callBack(true, result)
        }
      } else {
        if (callBack != undefined) {
          callBack(false, [])
        }
      }
    },predicate)
  }

  // 根据room_id 查询 room
  quaryChatRoomWithRoomId(room: room, callBack: (hasRoom: boolean, result: room[])=>void) {
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.ChatRoom)
    predicate.equalTo('room_id', room.room_id)
    DataRDBStore.quaryData<room>(TABLE_TYPE.ChatRoom,(result)=>{
      if (result.length > 0) {
        if (callBack != undefined) {
          callBack(true, result)
        }
        Logger.info(JSON.stringify(result))
      } else {
        if (callBack != undefined) {
          callBack(false, [])
        }
      }
    },predicate)
  }

  // 更新聊天room信息
  updateChatRoom(room: room, callBack: (isSuccess: boolean)=>void) {
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.ChatRoom)
    predicate.equalTo('room_id', room.room_id)
    predicate.equalTo('user_id', room.user_id)
    DataRDBStore.updateData<room>(room, TABLE_TYPE.ChatRoom, (isSuccess) => {
      if (callBack != undefined) {
        callBack(isSuccess)
      }
    },predicate)
  }

  // 创建聊天room
  createChatRoom(room: room, callBack: (success: boolean)=>void) {
    // 没有新聊天记录，创建room
    DataRDBStore.insertData<room>(room, TABLE_TYPE.ChatRoom, (isSuccess) =>{
      if (callBack != undefined) {
        callBack(isSuccess)
      }
    })
  }
}
export default new ChatListDataManager()