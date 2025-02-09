
import { emitter } from '@kit.BasicServicesKit';
import Logger from './Logger'

interface EmitterData {
  content: string,
}

class HMEmitter {

  // 订阅事件 带回调参数
  on(eventId: number, callBack: (data: string) => void) {
    let event: emitter.InnerEvent = {
      eventId: eventId
    }
    emitter.on(event, (eventData: emitter.EventData) => {
      let param: EmitterData = eventData.data as EmitterData
      Logger.info(JSON.stringify(param))
      if (callBack) {
        callBack(JSON.stringify(param.content))
      }
    });
  }

  // 发送事件 param: JSON.string
  emit(eventId: number, param: string = '') {
    // 定义一个eventId为1的事件，事件优先级为Low
    let event: emitter.InnerEvent = {
      eventId: eventId,
      priority: emitter.EventPriority.LOW
    };
    // 参数
    let eventData: emitter.EventData = {
      data: { content: param }
    };
    // 发送eventId为1的事件，事件内容为eventData
    emitter.emit(event, eventData);
  }
}

export default new HMEmitter()