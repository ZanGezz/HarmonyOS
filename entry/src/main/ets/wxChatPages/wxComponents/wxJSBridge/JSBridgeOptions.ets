

export interface callType {
  call: (func: string, params: string) => void
}

export interface JavaScriptItem {
  object: callType,
  name: string,
  methodList: Array<string>,
  controller: WebviewController
}

export interface ParamsItem {
  callID: number,
  data: string
}