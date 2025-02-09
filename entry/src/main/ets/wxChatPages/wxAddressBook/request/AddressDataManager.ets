import { userInfoModel } from '../../wxMine/model/wxUserInfoModel'
import { AddressBookListModel, chars } from '../model/wxAddressBookModel'
import UserDataManager from '../../wxMine/UserDataManager/UserDataManager'

class AddressDataMananger {

  // 查询address页面数据
  queryAddressData(callBack: (result: [AddressBookListModel[],string[]])=>void) {
    UserDataManager.queryUsers((result) => {
      callBack(this.dealWithAddressData(result))
    })
  }
  // 拼接数组
  dealWithAddressData(source: userInfoModel[]) :[AddressBookListModel[], string[]] {

    let addressBook: AddressBookListModel[] = []
    let firstChars: string[] =[]
    for (let i = 0; i < chars.length; i ++) {
      let char = chars[i]
      let user_info: userInfoModel[] = []
      for (let j = 0; j < source.length; j++) {
        let userModel = source[j]
        if (userModel.first_latter === char) {
          user_info.push(userModel)
        }
      }
      if (user_info.length > 0) {
        let addressBookListModel: AddressBookListModel = {
          first_latter: char,
          user_list: user_info
        }
        addressBook.push(addressBookListModel)
        firstChars.push(char)
      }
    }
    return [addressBook, firstChars]
  }
}
export default new AddressDataMananger()