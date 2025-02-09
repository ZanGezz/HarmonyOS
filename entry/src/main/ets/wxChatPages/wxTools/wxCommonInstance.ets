import { userInfoModel } from '../wxMine/model/wxUserInfoModel';

export enum PAGE_TYPE {
  chat,
  address,
  find,
  mine
}
// 单例类
@ObservedV2
class CommonInstance {
  // 设置单例
  static delegate = new CommonInstance();
  static getInstance() {
    return CommonInstance.delegate;
  }

  // 当前用户信息
  crrentUserInfo: userInfoModel = new userInfoModel()
  // 监听数据库是否创建完成
  RDBStoreComplete: boolean = false
  // 监听tabbar是否创建完成
  TabbarComplete: boolean = false
}

export default CommonInstance.getInstance()