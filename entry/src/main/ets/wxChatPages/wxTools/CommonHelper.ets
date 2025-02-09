
// 导入模块
import { i18n } from '@kit.LocalizationKit';
import { intl } from '@kit.LocalizationKit';
import Logger from '../wxTools/Logger'
import systemDateTime from '@ohos.systemDateTime';

// 工具类
class CommonHelper {
  /**
   * 返回一个随机数
   * Math.floor 向下取整,
   * Math.ceil 向上取整,
   * Math.round 四舍五入取整,
   * Math.PI 圆周率,
   * Math.random 0-1之间取随机小数,
   * Math.abs 取绝对值,
   * Math.max Math.min 取最大值最小值,
   * Math.pow(x, y) 取x的y次方,
   * Math.sqrt(x) 取x的平方根,
   * @param randomNumLenth 获取一个几位的随机数
   */
  getRandomNumber(randomNumLenth: number) :number {
    let random = String(Math.floor(Math.random() * Math.pow(10, randomNumLenth)))
    if (random.length < randomNumLenth) {
      Logger.info('位数不够重新获取')
      return this.getRandomNumber(randomNumLenth)
    } else {
      Logger.info('取值成功')
      return Number(random)
    }
  }

  /**
   *  汉字转拼音, 返回首字母
   *  content: 需要被翻译的汉字
   */
  exchangeChineseToChar(content: string) :string[] {
    // 音译成Latn格式 Any-Latn: nǐ hǎo Latin-ASCII：ni hao
    let transliterator = i18n.Transliterator.getInstance('Any-Latin');   // Any-Latn表示将任意文本转换为Latn文本
    let letter = transliterator.transform(content);   // letter = "nǐ hǎo "
    let transliterator2 = i18n.Transliterator.getInstance('Latin-ASCII'); // Latin-ASCII表示将Latin文本转换为ASCII文本
    letter = transliterator2.transform(letter);  // letter = "ni hao"
    let firstLetter = ''
    if (letter.length > 0) {
      // 判断是否是有效字母，特殊字符不是字母
      let isLetter = i18n.Unicode.isLetter(letter[0]);
      if (isLetter) {
        firstLetter = letter[0].toUpperCase()
      } else {
        firstLetter = '#'
      }
    }
    return [letter, firstLetter]
  }

  /**
   * 获取当前时间戳
   * isNanoseconds true 则获取 1729826261472952300 = 1970年01月01日星期四 08:00:00
   * isNanoseconds true 则获取当前时间戳
   * useS: 是否使用秒，默认使用， 否则直接返回毫秒
   */
  getCurrentTimeinterval(useS: boolean = false, isNanoseconds: boolean = false) :number {
    if (useS) {
      return Math.floor(systemDateTime.getTime(isNanoseconds)/1000)
    }
    return systemDateTime.getTime(isNanoseconds)
  }
  /**
   * 时间戳转化为字符串
   * YYYY：年 MM：月 DD：日 week：星期 hh：时 mm：分 ss：秒
   * fullTime = 2024年9月12日星期四 中国标准时间 上午10:52:46
   */
  exChangeTimeToString(time: number, dateFormat: string = 'YYYY:MM:DD week hh:mm:ss') :string {
    // 仅显示一部分时间
    let dateString = dateFormat
    let date = new Date(time)
    let newDateFormat = new intl.DateTimeFormat('zh-CN', { year: 'long',month: '2-digit', day: '2-digit',weekday: 'long',hour: '2-digit',minute: '2-digit',second: '2-digit'});
    let fullTime = newDateFormat.format(date);
    let year = fullTime.substring(0,4)
    let month = fullTime.substring(5,7)
    let day = fullTime.substring(8,10)
    let week = fullTime.substring(11,14)
    let hour = fullTime.substring(15,17)
    let min = fullTime.substring(18,20)
    let sec = fullTime.substring(21,23)
    dateString = dateString.replace('YYYY', year)
    dateString = dateString.replace('MM',month)
    dateString = dateString.replace('DD',day)
    dateString = dateString.replace('week',week)
    dateString = dateString.replace('hh',hour)
    dateString = dateString.replace('mm',min)
    dateString = dateString.replace('ss',sec)
    //Logger.info(year+'年'+month+'月'+day+'日'+hour+'时'+min+'分'+sec+'秒'+week)
    return dateString
  }
  /**
   * 朋友圈时间转换
   */
  wxCircleTimeinterval(time: number = 0) :string {

    let timeOffset = Math.floor((this.getCurrentTimeinterval() - time)/1000)
    // 分
    let min = 60
    // 时
    let hour = min*60
    // 天
    let day = hour*24
    // month
    let month = day*30
    // 年
    let year =month*12
    if (timeOffset < min) {
      return String(timeOffset)+'秒前'
    } else if (timeOffset < hour) {
      return String(Math.floor(timeOffset/min))+'分钟前'
    } else if (timeOffset < day) {
      return String(Math.floor(timeOffset/hour))+'小时前'
    } else if (timeOffset < month) {
      return String(Math.floor(timeOffset/day))+'天前'
    } else if (timeOffset < year) {
      return String(Math.floor(timeOffset/month))+'个月前'
    } else {
      return String(Math.floor(timeOffset/year))+'年前'
    }
  }
  /**
   * 微信显示时间处理
   */
  wxChatListTime(time: number = 0) :string {

    let timeOffset = Math.floor((this.getCurrentTimeinterval() - time)/1000)
    let day = 60*60*12
    let timeString = ''
    //Logger.info(String(this.getCurrentTimeinterval())+'-'+String(time)+'-'+String(timeOffset)+'-'+String(day))
    if (timeOffset < day) {
      timeString = this.exChangeTimeToString(time,'hh:mm')
    } else if (timeOffset > day && timeOffset < day*2) {
      timeString = '昨天 ' + this.exChangeTimeToString(time,'hh:mm')
    } else if (timeOffset > day*2 && timeOffset < day*6) {
      timeString = this.exChangeTimeToString(time, 'week')
    } else if (timeOffset > day *6) {
      timeString = this.exChangeTimeToString(time, 'YYYY年MM月DD日')
    }
    return timeString
  }

  /**
   * 去除@ObservedV2和@Trace 导致class在JSON.stringify序列化后，key增加的前缀__ob_的问题
   */
  remove__ob_func<T>(param: T): T {
    let jsonStr = JSON.stringify(param)
    jsonStr = jsonStr.replace(/(__ob_)/g, (match: string, letter: string): string => {return ''});
    Logger.info(jsonStr)
    return JSON.parse(jsonStr) as T
  }

  /**
   * 对象类型转换
   */
  FormatJSON<T>(param: T): undefined {
    return JSON.parse(JSON.stringify(param))
  }
}
export default new CommonHelper()

// 防抖函数 Debounce
let lastTime: number = 0
export function Deb(action: ()=>void, interval: number = 500) {
  const nowTime = Date.now();
  Logger.info(String(nowTime))
  Logger.info(String(lastTime))
  Logger.info(String(nowTime - lastTime))
  if (nowTime - lastTime > interval) {
    lastTime = nowTime;
    if (action) {
      action()
    }
  }
}

@Extend(Row)
function onDbClick(event1: (event: ClickEvent)=>void) {
  .onClick((event)=>{
    Deb(()=>{
      event1(event)
    })
  })
}
