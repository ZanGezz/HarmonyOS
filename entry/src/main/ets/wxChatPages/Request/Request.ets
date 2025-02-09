import http from '@ohos.net.http'
import { BASE_URL, TOKEN_KEY } from './NetBase'
import { ResponseData } from './ResponseData'
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { UserTokenUtils } from "./UserTokenUtils"

async function requestHttp<T>(url: string = "", method: http.RequestMethod = http.RequestMethod.GET, data?: object):
  Promise<T> {

  const httpRequest = http.createHttp()

  let urlStr = BASE_URL + url
  // 这里虽然官方文档说 get类型可以通过extraData传递过去，但是测试证明不可以-还是老老实实的自己拼接吧
  if (method === http.RequestMethod.GET) {
    if (data && Object.keys(data).length) {
      urlStr += "?" + Object.keys(data).map(key => {
        if (data[key]) {
          return `${key}=${data[key]}`
        }
        return ""
      }).join('&')
    }
  }
  // 设置请求头
  const config: http.HttpRequestOptions = {
    header: {
      'Content-Type': 'application/json',
      // "Authorization": AppStorage.Get(TOKEN_KEY) || ""
      // "Authorization":"eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI0MDEwMjIxNDEyOTU0OTE4NjE1IiwiYWNjb3VudCI6IjE5ODA1MDIyMzg5IiwibmFtZSI6IuWPuOacuiIsIm9yZ2lkIjoxMDI0OTkwNzI2NTE5NDAzNDU3LCJzdGF0aW9uaWQiOjEwMjQ3MDc1MzU4OTE5NDQ3NjksImFkbWluaXN0cmF0b3IiOmZhbHNlLCJleHAiOjE3MDg0NzA1NTh9.K9HYvIUT23txO_cLnEVpm6Mjx0UOWLX76dMN8CIJIbtL-duh3JNojpx6BRnbuaQkKniHLNnho-C7KALpf7SJnw"
    },
    method,
    readTimeout: 10000, // 超时时间
    extraData: method === http.RequestMethod.GET ? "" : data
  }
  try {
    console.log("======url",urlStr)
    console.log("======config",JSON.stringify(config))
    const res = await httpRequest.request(urlStr, config)
    console.log("======数据",JSON.stringify(res))
    if (res.responseCode === 401) {
      promptAction.showToast({ message: 'token超时' })
      return Promise.reject(new Error("token不存在或超时"))
    } else if (res.responseCode === 404) {
      promptAction.showToast({ message: '请求地址不正确' })
      return Promise.reject(new Error('请求地址不正确'))
    } else {
      // 为了方便使用json-server, 实际应用中与服务端沟通好固定格式
      const result = JSON.parse(res.result as string) as T
      return result
      // if (result.code === 200) {
      //   // 执行成功
      //   return result.data as T // 直接返回数据
      // } else {
      //   promptAction.showToast({ message: '服务器异常' })
      //   return Promise.reject(new Error(result.message))
      // }
    }
  } catch (error) {
    promptAction.showToast({ message: error.message })
    return Promise.reject(error)
  } finally {
    httpRequest.destroy(); // 销毁请求
  }
}

// 导出一个类的静态方法
export class Request {

  static requestData<T>(url: string, data?: object, method: http.RequestMethod = http.RequestMethod.GET): Promise<T> {
    return requestHttp<T>(url, method, data)
  }

  static get<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.GET, data)
  }

  static post<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.POST, data)
  }

  static delete<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.DELETE, data)
  }

  static put<T>(url: string, data?: object): Promise<T> {
    return requestHttp<T>(url, http.RequestMethod.PUT, data)
  }
}


