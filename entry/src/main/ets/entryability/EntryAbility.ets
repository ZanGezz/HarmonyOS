import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import DataRDBStore from '../wxChatPages/wxTools/DataRDBStore';
import Logger from '../wxChatPages/wxTools/Logger';

import CommonInstance, { PAGE_TYPE } from '../wxChatPages/wxTools/wxCommonInstance';

import PreferenceHelper from '../wxChatPages/wxTools/PreferenceHelper';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    //wxTabPage
    windowStage.loadContent('wxChatPages/wxBase/TabPage', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
    // 设置全屏模式
    this.setFullScreen(windowStage)
    // 创建数据库
    PreferenceHelper.createPreference(this.context)
    DataRDBStore.createDBStore(this.context)
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  // 设置全屏模式
  setFullScreen(windowStage: window.WindowStage) {
    globalThis.windowStage = windowStage;
    windowStage.getMainWindow()
      .then(win => {
        win.setWindowLayoutFullScreen(true);
      })
  }
}
