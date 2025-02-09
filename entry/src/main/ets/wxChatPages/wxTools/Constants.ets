
import display from '@ohos.display';

interface Screen {
  width: number,
  height: number,
  statusBarHeight: number,
  navigationHeight: number,
  tabBarHeight: number
}

export class Constants {

  /**
   获取屏幕宽高(vp)
   */
  static getScreenSizeVp(): Screen {

    let defDisplay = display.getDefaultDisplaySync();
    // 屏幕宽高
    let screen: Screen = {
      width : px2vp(defDisplay.width),
      height : px2vp(defDisplay.height),
      statusBarHeight : 40,
      tabBarHeight : 88,
      navigationHeight : 88
    };
    return screen;
  }

  /**
   * 屏幕宽
   */
  static readonly SCREEN_WIDTH: number = this.getScreenSizeVp().width

  /**
   * 屏幕高
   */
  static readonly SCREEN_HEIGHT: number = this.getScreenSizeVp().height

  /**
   * 导航高度
   */
  static readonly NAVI_HEIGHT: number = this.getScreenSizeVp().navigationHeight

  /**
   * 状态栏
   */
  static readonly STATUS_BAR_HEIGHT : number = this.getScreenSizeVp().statusBarHeight

  /**
   * tabBar高度
   */
  static readonly TAB_BAR_HEIGHT: number = this.getScreenSizeVp().tabBarHeight
  /**
   * content 高度
   */
  static readonly CONTENT_HEIGHT: number = this.getScreenSizeVp().height - this.TAB_BAR_HEIGHT - this.NAVI_HEIGHT
  /**
   * 键盘高度
   */
  static readonly KEYBOARD_HEIGHT: number = 310
}

export class Strings {
  /**
   * 存储当前用户id
   */
  static readonly USER_ID: string = 'user_id'
  /**
   * 朋友圈当前offset
   */
  static readonly CircleListContentOffSet: string = 'CircleListContentOffSet'
}

