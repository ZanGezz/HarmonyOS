import { userInfoModel } from '../../wxMine/model/wxUserInfoModel'

export const AddressBookCommonData: userInfoModel[] = [
  new userInfoModel({
    head_image: 'xindepengyou',
    nick_name: '新的朋友'
  }),
  new userInfoModel({
    head_image: 'qunliao',
    nick_name: '群聊'
  }),
    new userInfoModel({
    head_image: 'weixinbiaoqian',
    nick_name: '标签'
  }),
      new userInfoModel({
    head_image: 'gongzhonghao',
    nick_name: '公众号'
  }),
  new userInfoModel({
    head_image: 'qiwei',
    nick_name: '企业微信联系人'
  })
]

export interface AddressBookListModel {
  first_latter?: string,
  user_list?: userInfoModel[]
}

export const chars = [
  'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','#'
]