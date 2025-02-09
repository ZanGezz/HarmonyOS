
import { relationalStore } from '@kit.ArkData';
import { ValuesBucket } from '@kit.ArkData';
import { BusinessError } from "@kit.BasicServicesKit";
import Logger from './Logger';
import CommonInstance, { PAGE_TYPE } from './wxCommonInstance';
import UserDataManager from '../wxMine/UserDataManager/UserDataManager';
import HMEmitter from './HMEmitter'
import CommonHelper from './CommonHelper'

export enum TABLE_TYPE {
  Chat = 'Chat',
  ChatRoom = 'ChatRoom',
  UserInfo = 'UserInfo',
  CircleList = 'CircleList',
  CircleLocation = 'CircleLocation',
  CircleLink = 'CircleLink',
  CircleZan = 'CircleZan',
  CirclePing = 'CirclePing',
  CircleImage = 'CircleImage'
}
let currentContext: Context
let currentStore: relationalStore.RdbStore | undefined = undefined;
const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'weChat.db',
  securityLevel: relationalStore.SecurityLevel.S1
};

// 首页聊天列表结构
const ChatRoom_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS ChatRoom (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'user_id INT NOT NULL, ' +
  'nick_name TEXT, ' +
  'room_id TEXT, ' +
  'last_chat TEXT, ' +
  'head_image TEXT, ' +
  'unread INT, ' +
  'type INT, ' +
  'total_chat INT, ' +
  'stick INT, ' +
  'time INT, ' +
  'isDelete INT, ' +
  'last_delete_time INT' +
  ')';

// 首页聊天内容结构
const Chat_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS Chat (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'user_id INT NOT NULL, ' +
  'nick_name TEXT, ' +
  'room_id TEXT, ' +
  'content TEXT, ' +
  'head_image TEXT, ' +
  'time INT' +
  ')';

// 用户信息表结构
const UserInfo_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS UserInfo (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'user_id INT NOT NULL, ' +
  'nick_name TEXT, ' +
  'user_age INT, ' +
  'user_area TEXT, ' +
  'user_sex INT, ' +
  'first_latter TEXT, ' +
  'head_image TEXT, ' +
  'cover_image TEXT, ' +
  'wechat_id TEXT, ' +
  'personal_signature TEXT' +
  ')';
// 朋友圈列表表结构
const CircleList_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS CircleList (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'user_id INT NOT NULL, ' +
  'nick_name TEXT, ' +
  'head_image TEXT, ' +
  'message_id INT, ' +
  'text TEXT, ' +
  'time INT' +
  ')';

// 地理位置表结构
const CircleLocation_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS CircleLocation (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'message_id INT, ' +
  'location_name TEXT, ' +
  'location_latitude DECIMAL(9,6), ' +
  'location_longitude DECIMAL(9,6)' +
  ')';

// 网络链接表结构
const CircleLink_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS CircleLink (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'message_id INT, ' +
  'link_url TEXT, ' +
  'link_image TEXT, ' +
  'link_text TEXT' +
  ')';

// 点赞表结构
const CircleZan_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS CircleZan (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'user_id INT NOT NULL, ' +
  'nick_name TEXT, ' +
  'message_id INT, ' +
  'time INT' +
  ')';

// 发表图片结构
const CircleImage_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS CircleImage (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'component_id TEXT, ' +
  'src TEXT, ' +
  'imageSmallWidth INT, ' +
  'imageSmallHeight INT, ' +
  'message_id INT' +
  ')';

// 评论表结构
const CirclePing_CREATE_TABLE =
  'CREATE TABLE IF NOT EXISTS CirclePing (' +
  'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
  'a_user_id INT, ' +
  'a_nick_name TEXT, ' +
  'b_user_id INT, ' +
  'b_nick_name TEXT, ' +
  'message_id INT, ' +
  'text TEXT, ' +
  'time INT' +
  ')';

class DataRDBStore {

  /*
   * 创建数据库
   */
  createDBStore(context: Context){
    currentContext = context
    // 先获取数据库，确保获取到数据库，再创建表
    relationalStore.getRdbStore(context, STORE_CONFIG, (error, store)=>{
      currentStore = store
      if (error) {
        Logger.error(`Failed to get RdbStore. Code:${error.code}, message:${error.message}`);
        return;
      }
      Logger.info('create sql success');
      Logger.info(String(store.version));
      // 当数据库创建时，数据库默认版本为0
      if (store.version === 0) {
        // 创建数据表
        store.executeSql(UserInfo_CREATE_TABLE);
        store.executeSql(CircleLocation_CREATE_TABLE);
        store.executeSql(CircleLink_CREATE_TABLE);
        store.executeSql(CircleZan_CREATE_TABLE);
        store.executeSql(CirclePing_CREATE_TABLE);
        store.executeSql(CircleList_CREATE_TABLE);
        store.executeSql(ChatRoom_CREATE_TABLE);
        store.executeSql(Chat_CREATE_TABLE);
        store.executeSql(CircleImage_CREATE_TABLE);

        // 设置数据库的版本，入参为大于0的整数
        store.version = 1;

        // 新app插入默认数据
        UserDataManager.createDefaultData()
      } else {
        CommonInstance.RDBStoreComplete = true
        Logger.info('CommonInstance.RDBStoreComplete12')
        if (CommonInstance.RDBStoreComplete && CommonInstance.TabbarComplete) {
          Logger.info('CommonInstance.RDBStoreComplete1')
          HMEmitter.emit(1,JSON.stringify([PAGE_TYPE.chat,PAGE_TYPE.address,PAGE_TYPE.find,PAGE_TYPE.mine]))
          //CommonInstance.updateUserInfo([PAGE_TYPE.chat,PAGE_TYPE.address,PAGE_TYPE.find,PAGE_TYPE.mine])
        }
      }
    })
  }

  /*
   * 向数据库插入数据
   */
  insertData<T>(item: T, type: TABLE_TYPE, callBack: (isSuccess: boolean)=>void = (success)=>{}) {
    // 处理room key里的 __ob_
    let newItem = CommonHelper.remove__ob_func(item)
    if (currentStore !== undefined) {
      Logger.info('type:' +type+'  insertData: '+JSON.stringify(newItem));
      currentStore.insert(type, newItem as ValuesBucket, (error: BusinessError, row: number) => {
        if (callBack != undefined) {
          if (error === undefined) {
            Logger.info(`Succeeded in inserting data. rowId:${row}`);
            Logger.info(`Succeeded in inserting data. type:${type}`);
            callBack(true)
          } else {
            Logger.info(`error in inserting data. type:${error.message}`);
            callBack(false)
          }
        }
      })
    }
  }
  /*
   * 修改数据
   * predicates 默认取全部值
   */
  updateData<T>(param: T, type: TABLE_TYPE, callBack:(isSuccess: boolean)=>void, predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(type)) {
    // 处理room key里的 __ob_
    let newParam = CommonHelper.remove__ob_func(param)
    Logger.info('type: '+String(type)+'  param: '+JSON.stringify(newParam))
    if (currentStore !== undefined) {
      currentStore.update(newParam as relationalStore.ValuesBucket, predicate, (err: BusinessError, rows: number) => {
        if (err == undefined) {
          Logger.info(`Succeeded in updating data. row count: ${rows}`);
          callBack(err == undefined ? true : false)
          return
        }
        Logger.info(`Failed to update data. Code:${err.code}, message:${err.message}`);
      })
    }
  }
  /*
   * 删除数据
   * predicates 默认取全部值
   */
  deleteData(type: TABLE_TYPE, callBack:(isSuccess: boolean)=>void, predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(type)) {
    if (currentStore !== undefined) {
      currentStore.delete(predicate, (err: BusinessError, rows: number) => {
        if (err) {
          Logger.info(`Failed to delete data. Code:${err.code}, message:${err.message}`);
          return
        }
        callBack(err == undefined ? true : false)
        Logger.info(`Succeeded in delete data type: ${type}. row count: ${rows}`);
      })
    }
  }
  /*
   * 查询数据
   * predicates 默认取全部值
   */
  quaryData<T>(type: TABLE_TYPE, callBack:(result: T[])=>void, predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(type)) {
    // 开始查询
    const dataArray: T[] = []
    if (currentStore !== undefined) {
      currentStore.query(predicate, (err: BusinessError, resultSet) => {
        if (err) {
          Logger.info(`Failed to quaryData. Code:${err.code}, message:${err.message}`);
          callBack(dataArray)
          return
        }
        while (resultSet.goToNextRow()) {
          let model = resultSet.getRow() as T
          dataArray.push(model)
        }
        if (callBack !== undefined) {
          callBack(dataArray)
        }
        Logger.info('Success to type: '+type+'  quaryData: '+JSON.stringify(dataArray));
      })
    }
  }

  /**
   * 删除数据库
   */
  deleteRDBStore() {
    relationalStore.deleteRdbStore(currentContext, 'weChat.db', (err: BusinessError) => {
      if (err) {
        console.error(`Failed to delete RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in deleting RdbStore.');
    });
  }
}

export default new DataRDBStore()

