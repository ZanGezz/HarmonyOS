import preferences from '@ohos.data.preferences'
import {TOKEN_KEY} from './NetBase'

export class UserTokenUtils{
  // 这里之所以使用传入context的方式来设置，是因为在utils的this不一定就执行entry的this
  context: Context

  constructor(context: Context) {
    this.context = context
  }
  // 获取存储用户信息的首选项仓库
  getStore() {
    return preferences.getPreferences(this.context,TOKEN_KEY)
  }
  //   设置ability的token
  async setAbiltyToken(token:string) {
    const adToken = await this.getStore()
    adToken.put(TOKEN_KEY, JSON.stringify(token))
    adToken.flush() //	将当前Preferences实例的数据异步存储到用户首选项持久化文件中。
  }

  //   设置ability的token
  async getAbiltyToken() {
    const adToken = await this.getStore()
    return await adToken.get(TOKEN_KEY,"") as string
  }
}