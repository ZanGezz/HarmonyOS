
import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

let dataPreferences: preferences.Preferences | null = null;

class PreferenceHelper {

  // 获取preferences实例
  createPreference(context: Context) {
    let options: preferences.Options = {name:'wx_store'};
    dataPreferences = preferences.getPreferencesSync(context, options);
  }

  // 存储数据
  save(key: string, value: preferences.ValueType) {
    if (dataPreferences) {
      dataPreferences.putSync(key, value);
      // 将数据持久化
      dataPreferences.flush((err: BusinessError) => {
        if (err) {
          console.error(`Failed to flush. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info('Succeeded in flushing.');
      })
    }
  }

  // 读取数据
  quary<T>(key: string) : T {
    if (dataPreferences) {
      return dataPreferences.getSync(key, '') as T;
    }
    return '' as T
  }

  // 删除数据
  delete(key: string) {
    if (dataPreferences) {
      dataPreferences.deleteSync(key);
    }
  }
}

export default new PreferenceHelper()