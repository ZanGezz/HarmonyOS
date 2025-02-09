import { relationalStore } from '@kit.ArkData'
import DataRDBStore, { TABLE_TYPE } from '../../wxTools/DataRDBStore'
import { CircleListModel, CircleZanModel, CirclePingModel, CircleLocationModel, CircleLinkModel, CircleImageModel } from '../../wxFind/model/FriendCircleListModel'

// Find页面数据处理
class CircleDataManager {
  // 查询朋友圈列表
  queryCircleListData(callBack: (result: CircleListModel[]) => void, offset: number = 0, size: number = 20) {
    // 查询朋友圈内容
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.CircleList)
    // 按id倒序
    predicate.orderByDesc('id')
    // 查询条数
    predicate.limitAs(size)
    // 查询id为 offset到offset*size 之间的数据
    predicate.offsetAs(offset)

    DataRDBStore.quaryData<CircleListModel>(TABLE_TYPE.CircleList,(result) => {
      if (callBack !== undefined) {
        // 没有数据直接返回
        if (result.length === 0) {
          callBack(result)
          return
        }
        // 有数据，查询关联数据
        let zanComplete: boolean = false
        let pingComplete: boolean = false
        let imageComplete: boolean = false
        let locationComplete: boolean = false
        let linkComplete: boolean = false
        for (let i = 0; i < result.length; i ++) {
          let message = result[i]
          // 获取赞
          this.queryCircleListInfoData<CircleZanModel>(message.message_id!, TABLE_TYPE.CircleZan, (zanData) =>{
            message.zanData = zanData
            zanComplete = true
            if (this.canCallBack(zanComplete,pingComplete,imageComplete,locationComplete,linkComplete) && i === result.length-1) {
              setTimeout(()=>{
                callBack(result)
              },150)
            }
          })
          // 获取评论
          this.queryCircleListInfoData<CirclePingModel>(message.message_id!, TABLE_TYPE.CirclePing, (pingData) =>{
            message.pingData = pingData
            pingComplete = true
            if (this.canCallBack(zanComplete,pingComplete,imageComplete,locationComplete,linkComplete) && i === result.length-1) {
              setTimeout(()=>{
                callBack(result)
              },150)
            }
          })
          // 获取地理位置
          this.queryCircleListInfoData<CircleLocationModel>(message.message_id!, TABLE_TYPE.CircleLocation, (locationData) =>{
            if (result.length > 0) {
              message.locationData = locationData[0]
            }
            locationComplete = true
            if (this.canCallBack(zanComplete,pingComplete,imageComplete,locationComplete,linkComplete) && i === result.length-1) {
              setTimeout(()=>{
                callBack(result)
              },150)
            }
          })
          // 获取网络链接
          this.queryCircleListInfoData<CircleLinkModel>(message.message_id!, TABLE_TYPE.CircleLink, (linkData) =>{
            if (result.length > 0) {
              message.linkData = linkData[0]
            }
            linkComplete = true
            if (this.canCallBack(zanComplete,pingComplete,imageComplete,locationComplete,linkComplete) && i === result.length-1) {
              setTimeout(()=>{
                callBack(result)
              },150)
            }
          })
          // 获取图片
          this.queryCircleListInfoData<CircleImageModel>(message.message_id!, TABLE_TYPE.CircleImage, (imageData) =>{
            message.imageData = imageData
            imageComplete = true
            if (this.canCallBack(zanComplete,pingComplete,imageComplete,locationComplete,linkComplete) && i === result.length-1) {
              setTimeout(()=>{
                callBack(result)
              },150)
            }
          })
        }
      }
    }, predicate)
  }

  // 判断是否可以callBack
  canCallBack(zanComplete: boolean,
    pingComplete: boolean,
    imageComplete: boolean,
    locationComplete: boolean,
    linkComplete: boolean) :boolean {
    return zanComplete && pingComplete && imageComplete && locationComplete && linkComplete
  }


  // 根据message_id 获取点赞评论 图片 链接 地理位置
  queryCircleListInfoData<T>(message_id: number, type: TABLE_TYPE, callBack: (result: T[])=>void) {
    // 根据message_id 查询评论点赞内容
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(type)
    predicate.equalTo('message_id', message_id)
    DataRDBStore.quaryData<T>(type, (result) => {
      if (callBack !== undefined) {
        callBack(result)
      }
    },predicate)
  }

  // 插入或删除评论数据
  insertOrDeletePingData(inOrDel: boolean, ping: CirclePingModel, callBack: (success: boolean)=>void = (success: boolean)=>{}) {
    if (inOrDel) {
      DataRDBStore.insertData<CirclePingModel>(ping,TABLE_TYPE.CirclePing,(isSuccess)=>{
        callBack(isSuccess)
      })
    } else {
      let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.CirclePing)
      predicate.equalTo('time', ping.time).and().equalTo('message_id', ping.message_id)
      DataRDBStore.deleteData(TABLE_TYPE.CirclePing, (isSuccess)=>{
        callBack(isSuccess)
      },predicate)
    }
  }

  // 插入或删除点赞数据
  insertOrDeleteZanData(inOrDel: boolean, zan: CircleZanModel, callBack: (success: boolean)=>void = (success: boolean)=>{}) {
    if (inOrDel) {
      DataRDBStore.insertData<CircleZanModel>(zan,TABLE_TYPE.CircleZan,(isSuccess)=>{
        callBack(isSuccess)
      })
    } else {
      let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.CircleZan)
      predicate.equalTo('user_id', zan.user_id).and().equalTo('message_id', zan.message_id)
      DataRDBStore.deleteData(TABLE_TYPE.CircleZan, (isSuccess)=>{
        callBack(isSuccess)
      }, predicate)
    }
  }

  // 根据user_id删除朋友圈
  DeleteUserMoment(user_id: number, callBack: (success: boolean) => void = (success: boolean) => {}) {
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.CircleList)
    predicate.equalTo('user_id', user_id)
    DataRDBStore.quaryData<CircleListModel>(TABLE_TYPE.CircleList, (result) => {
      for (let i = 0; i < result.length; i ++) {
        let message: CircleListModel = result[i]
        this.deleteMoment(message, (success) => {
          if (i === result.length - 1) {
            callBack(success)
          }
        })
      }
    })
  }

  // 根据message_id删除朋友圈
  deleteMoment(message: CircleListModel, callBack: (deleteSuccess: boolean)=>void = (deleteSuccess: boolean)=>{}) {

    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_TYPE.CircleList)
    predicate.equalTo('message_id',message.message_id)
    DataRDBStore.deleteData(TABLE_TYPE.CircleList,(isSuceess)=>{
      if (isSuceess) {
        // 成功，继续删除关联的点赞，评论，图片，链接
        this.deleteCircleInfoData(TABLE_TYPE.CircleLocation, message.message_id!)
        this.deleteCircleInfoData(TABLE_TYPE.CircleLink, message.message_id!)
        this.deleteCircleInfoData(TABLE_TYPE.CircleZan, message.message_id!)
        this.deleteCircleInfoData(TABLE_TYPE.CirclePing, message.message_id!)
        this.deleteCircleInfoData(TABLE_TYPE.CircleImage, message.message_id!, (suceess)=>{
          callBack(suceess)
        })
      }
    },predicate)
  }

  // 删除关联的点赞，评论，图片，链接
  deleteCircleInfoData(type: TABLE_TYPE, message_id: number, callBack: (isSuceess: boolean)=>void = (isSuceess: boolean)=>{}) {
    let predicate: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(type)
    predicate.equalTo('message_id', message_id)
    DataRDBStore.deleteData(type, (isSuccess)=>{
      callBack(isSuccess)
    },predicate)
  }
}
export default new CircleDataManager()