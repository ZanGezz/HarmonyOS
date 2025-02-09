import { AlertType } from './AlertTypes'

export interface AlertOption {
  title?: string
  content?: string
  okTitle?: string
  cancelTitle?: string
  callBack?: (title: string) => void
  alertType?: AlertType
  duration?: number
  maskColor?: string
  isModal?: boolean
  logoImage?: string
}

// 删除该朋友圈弹框
export const MomentDelete: AlertOption = {
  alertType: AlertType.Alert_Type_MomentDelete,
  maskColor: 'rgba(0, 0, 0, 0.5)',
  content: '删除该朋友圈？',
  cancelTitle: '取消',
  okTitle: '删除',
  callBack: (title: string) => {}
}

// Loading加载中
export const Loading: AlertOption = {
  alertType: AlertType.Dialog_type_LoadingAndText,
  logoImage: 'app.media.loading_n'
}

// Loading加载中
export const LoadingAndText: AlertOption = {
  alertType: AlertType.Dialog_type_LoadingAndText,
  content: '加载中',
  logoImage: 'app.media.loading_n'
}

// GIF
export const GIF: AlertOption = {
  alertType: AlertType.Alert_Type_GIF,
  logoImage: 'app.media.gongxi'
}

// Toast提示
export const Toast: AlertOption = {
  alertType: AlertType.Alert_Type_Toast,
  content: '就算天再高那又怎样，踮起脚尖就更靠近阳光！',
}

// Toast提示：暂未开通此功能
export const Toast_unOpen: AlertOption = {
  alertType: AlertType.Alert_Type_Toast,
  content: '暂未开通此功能',
}