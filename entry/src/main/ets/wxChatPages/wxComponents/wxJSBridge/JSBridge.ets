import { webview } from '@kit.ArkWeb';
import { JavaScriptItem, ParamsItem } from './JSBridgeOptions';
import { code } from './JSCode';

/**
 * Define bridge class connect WebView and ArkTS.
 */
export default class JsBridge {

  private controller: webview.WebviewController
  private onMessage: (funcName: string,callID: number, params: string) => void

  constructor(controller: webview.WebviewController, onMessage: (funcName: string,callID: number, params: string) => void) {
    this.controller = controller;
    this.onMessage = onMessage
  }

  /**
   * Injects the JavaScript object into window and invoke the function in window.
   *
   * @returns javaScriptProxy object.
   */
  javaScriptProxy(): JavaScriptItem {
    let result: JavaScriptItem = {
      object: {
        call: this.call
      },
      name: 'JSBridgeHandle',
      methodList: ['call'],
      controller: this.controller
    }
    return result;
  }

  /**
   * initialize the bridge.
   */
  initJsBridge(): void {
    this.controller.runJavaScript(code);
  }

  /**
   * 前端调用原生call方法，传递方法名和参数
   */
  call = (func: string, params: string): void => {
    let paramsObject: ParamsItem = JSON.parse(params);
    if (this.onMessage) {
      this.onMessage(func, paramsObject.callID, JSON.stringify(paramsObject.data))
    }
  }

  /**
   * The ArkTS invoke the WebView by using runJavaScript.
   */
  callback = (id: number, data: string): void => {
    this.controller.runJavaScript(`JSBridgeCallback('${id}', ${JSON.stringify(data)})`);
  }

}