import { ComponentContent, PromptAction } from '@kit.ArkUI';
import { AlertOption } from './AlertOptions';
import { AlertCustomDialog } from './AlertCustomDialogs';

/*
 * 组件只在API 12 即 HarmonyOS 5.0.0 后可用
 */
class Alert {

  /**
   * Loading旋转动画角度
   */
  private promptAction?: PromptAction;
  private contentNode?: ComponentContent<AlertOption>;
  private maskColor: string = 'rgba(0, 0, 0, 0.2.5)'
  private isModal: boolean = true

  /*
  * 弹出一个Dialog提示框
  */
  showDialog(context: UIContext, option: AlertOption) {

    if (!context || !option) {
      return;
    }
    if (option.maskColor) {
      this.maskColor = option.maskColor
    }
    if (option.isModal === false) {
      this.isModal = option.isModal
    }

    //let uiContext = AppStorage.get<UIContext>('uiContext');
    this.promptAction = context.getPromptAction();
    this.contentNode = new ComponentContent(context, wrapBuilder(AlertCustomDialog), option);
    //创建弹框
    this.promptAction.openCustomDialog(this.contentNode, {
      showInSubWindow: false,
      alignment:DialogAlignment.Center,
      autoCancel: false,            // 点击遮盖层是否取消弹框
      isModal: this.isModal,        // 模态：有全屏遮盖层
      maskColor: this.maskColor,    // 遮盖层颜色透明度
      onWillAppear: ()=>{
        // 弹框即将出现
      },
      onDidAppear: ()=>{
        // 弹框已经出现
      }
    })
  }

  /*
   * 关闭对话框
   */
  closeCustomDialog() {
    if (this.contentNode) {
      this.promptAction?.closeCustomDialog(this.contentNode);
    }
  }
}
// export default 等同于单例 无论在哪里引入，都是同一个实例
export default new Alert()