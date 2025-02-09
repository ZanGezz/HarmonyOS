import relationalStore from '@ohos.data.relationalStore'
import DataRDBStore, { TABLE_TYPE } from '../../wxTools/DataRDBStore'
import HMEmitter from '../../wxTools/HMEmitter'
import PreferenceHelper from '../../wxTools/PreferenceHelper'
import Logger from '../../wxTools/Logger'
import CommonInstance, { PAGE_TYPE } from '../../wxTools/wxCommonInstance'
import { chat, room,
  WXChuanShu,
  WXChuanShuChat,
  WXDingYu, WXTuanDui, WXYunDong,
  ZangeAndCangLang,
  ZangeAndCangLangChat} from '../../wxChatList/model/wxChatListModel'
import { userInfoModel, defaultUser, UserCangLang, UserWXChuanShu, UserWXTuanDui } from '../model/wxUserInfoModel'
import { Strings } from '../../wxTools/Constants'
import ChatListDataManager from '../../wxChatList/request/ChatListDataManager'
import CircleDataManager from '../../wxFind/CircleRequest/CircleDataManager'

class UserDataManager {

  // 更新用户
  updateUserInfo(callBack: (isSuccess: boolean)=>void = (isSuccess: boolean)=>{}) {
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.UserInfo)
    predicate.equalTo('user_id', CommonInstance.crrentUserInfo.user_id)
    DataRDBStore.updateData<userInfoModel>(CommonInstance.crrentUserInfo, TABLE_TYPE.UserInfo, (success)=>{
       callBack(success)
    }, predicate)
  }
  // 删除用户
  deleteUser(user_id: number, callBack: (isSuccess: boolean)=>void = (isSuccess: boolean)=>{}) {
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.UserInfo)
    predicate.equalTo('user_id', user_id)
    DataRDBStore.deleteData(TABLE_TYPE.UserInfo, (result)=>{

      ChatListDataManager.quaryChatRoom([user_id, CommonInstance.crrentUserInfo.user_id!], (hasRoom: boolean, result: room[])=>{
        if (hasRoom) {
          // 删除room
          for (let i = 0; i < result.length; i ++) {
            let room: room = result[i]
            ChatListDataManager.deleteChatRoom(room.room_id,(deleteChatRoom)=>{
              // 取删除聊天记录
              ChatListDataManager.deleteChat(room.room_id, (deleteChat)=>{
              })
            })
          }
        }
      })

      // 删除朋友圈
      CircleDataManager.DeleteUserMoment(user_id, (deleteUserMoment) => {
      })

      setTimeout(()=>{
        callBack(result)
      }, 100)

    }, predicate)
  }


  // 创建用户
  createNewUser(userInfo: userInfoModel, callBack: (success: boolean)=>void, needCreateRoom: boolean = true) {
    Logger.info('aaaaaaa:'+JSON.stringify(userInfo))
    DataRDBStore.insertData<userInfoModel>(userInfo, TABLE_TYPE.UserInfo,(isSuccess)=>{
      if (isSuccess) {
        if (needCreateRoom) {
          Logger.info('aaaaaaabbbbbb:'+JSON.stringify(userInfo))
          let YunDong: room = new room(WXYunDong())
          YunDong.room_id = 'wx_' + String(userInfo.user_id)+'_'+String(100000006)
          YunDong.user_id = userInfo.user_id!
          let DingYu: room = new room(WXDingYu())
          DingYu.room_id = 'wx_' + String(userInfo.user_id)+'_'+String(100000005)
          DingYu.user_id = userInfo.user_id!
          let TuanDui: room = new room(WXTuanDui())
          TuanDui.room_id = 'wx_' + String(userInfo.user_id)+'_'+String(100000002)
          TuanDui.user_id = userInfo.user_id!
          ChatListDataManager.createChatRoom(YunDong,(YunDongSuccess)=>{
            if (YunDongSuccess) {
              ChatListDataManager.createChatRoom(DingYu,(DingYuSuccess)=>{
                if (DingYuSuccess) {
                  ChatListDataManager.createChatRoom(TuanDui,(YunDongSuccess)=>{
                    if (callBack) {
                      callBack(YunDongSuccess)
                    }
                  })
                } else {
                  if (callBack) {
                    callBack(DingYuSuccess)
                  }
                }
              })
            } else {
              if (callBack) {
                callBack(YunDongSuccess)
              }
            }
          })
        } else {
          if (callBack) {
            callBack(isSuccess)
          }
        }
      } else {
        if (callBack) {
          callBack(isSuccess)
        }
      }
    })
  }


  // 查询单个用户
  queryUserWithID(user_id: number, callBack: (result: userInfoModel[])=>void) {
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.UserInfo)
    predicate.equalTo('user_id', user_id)
    DataRDBStore.quaryData<userInfoModel>(TABLE_TYPE.UserInfo,(result) => {
      if (callBack !== undefined) {
        callBack(result)
      }
    },predicate)
  }

  // 获取所有用户
  queryUsers(callBack: (result: userInfoModel[])=>void) {
    DataRDBStore.quaryData<userInfoModel>(TABLE_TYPE.UserInfo,(result) => {
      if (callBack !== undefined) {
        callBack(result)
      }
    })
  }

  // 首次安装app，创建默认数据
  createDefaultData() {
    // 默认用户
    PreferenceHelper.save(Strings.USER_ID, defaultUser.user_id!)
    // 新增4个用户
    this.createNewUser(UserWXChuanShu,(isSuccess)=>{},false)
    this.createNewUser(UserWXTuanDui,(isSuccess)=>{},false)
    this.createNewUser(UserCangLang,(isSuccess)=>{
      if (isSuccess) {
        this.createNewUser(defaultUser, (defaultUserSuccess)=>{
          if (isSuccess) {
            ChatListDataManager.createChatRoom(WXChuanShu()[0],(WXChuanShuSuccess)=>{})
            ChatListDataManager.createChatRoom(WXChuanShu()[1],(WXChuanShuSuccess)=>{
              if (WXChuanShuSuccess) {
                DataRDBStore.insertData<chat>(WXChuanShuChat[0],TABLE_TYPE.Chat,(ChuanShuChat)=>{
                  DataRDBStore.insertData<chat>(WXChuanShuChat[1],TABLE_TYPE.Chat,(ChuanShuChat)=>{
                    ChatListDataManager.createChatRoom(ZangeAndCangLang()[0],(ZangeAndCangLangRoom)=>{
                      ChatListDataManager.createChatRoom(ZangeAndCangLang()[1],(ZangeAndCangLangRoom1)=>{
                        DataRDBStore.insertData<chat>(ZangeAndCangLangChat[0],TABLE_TYPE.Chat,(ChuanShuChat)=>{
                          DataRDBStore.insertData<chat>(ZangeAndCangLangChat[1],TABLE_TYPE.Chat,(ChuanShuChat)=>{
                            // 更新userInfo
                            CommonInstance.RDBStoreComplete = true
                            if (CommonInstance.RDBStoreComplete && CommonInstance.TabbarComplete) {
                              Logger.info('CommonInstance.RDBStoreComplete2')
                              HMEmitter.emit(1,JSON.stringify([PAGE_TYPE.chat,PAGE_TYPE.address,PAGE_TYPE.find,PAGE_TYPE.mine]))
                            }
                          })
                        })
                      })
                    })
                  })
                })
              }
            })
          }
        })
      }
    })
  }
}
export default new UserDataManager()