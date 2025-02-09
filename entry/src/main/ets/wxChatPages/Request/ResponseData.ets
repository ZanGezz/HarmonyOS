export class ResponseData<T> {
  code: number = 0
  message: string = ""
  data: T | null = null
}