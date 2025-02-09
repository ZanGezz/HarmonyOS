
/**
 * LazyForEach 使用数据模型封装 BaseIDataSource
 */
@ObservedV2
export class BaseIDataSource<T> implements IDataSource {

  private listeners: DataChangeListener[] = [];
  private dataArray: T[] = [];
  @Trace isEmpty: boolean = true

  /**
   * 获取数组长度
   * @returns
   */
  totalCount(): number {
    return this.dataArray.length;
  }
  /**
   * 获取第一个元素
   */
  first(): T {
    return this.dataArray[0]
  }
  /**
   * 获取最后一个元素
   */
  last(): T {
    return this.dataArray[this.totalCount() - 1]
  }
  /**
   * 获取元素索引
   */
  indexOf(param: T) :number {
    return this.dataArray.indexOf(param)
  }
  /**
   * 获取指定位置数组元素
   * @returns
   */
  getData(index: number): T {
    return this.dataArray[index];
  }
  /**
   * 获取整个数组数据
   */
  getAllData(): T[] {
    return this.dataArray
  }
  /**
   * 添加一个新数组元素，默认添加到数组最后
   */
  pushItems(items: T[]) {
    console.log(JSON.stringify(items))
    for (let i = 0; i < items.length; i ++) {
      if (i === items.length - 1) {
        this.push(items[i])
      } else {
        this.dataArray.push(items[i])
      }
    }
    this.isEmpty = this.totalCount() > 0 ? false : true
  }
  /**
   * 添加一个元素，默认添加到数组最后
   */
  push(item: T, index: number = this.totalCount()) {

    if (index == this.totalCount()) {
      this.dataArray.push(item)
    } else {
      let aItem = this.dataArray[index]
      this.dataArray.splice(index, 1, item, aItem);
    }
    //this.reloadData()
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
      //listener.onDatasetChange([{type: DataOperationType.ADD, index: index}]);
      //this.reloadData()
      //console.log('onDataAdd')
    })
    this.isEmpty = this.totalCount() > 0 ? false : true
  }

  /**
   * 删除一个元素，默认删除最后一个
   */
  pop(item: T) {
    let index = this.dataArray.indexOf(item)
    this.dataArray.splice(index, 1);
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
      // listener.onDatasetChange([{type: DataOperationType.DELETE, index: index}]);
      //this.reloadData()
      console.log('onDataDelete')
    })
    this.isEmpty = this.totalCount() > 0 ? false : true
  }

  /**
   * 删除全部
   */
  popAll() {
    this.dataArray.splice(0, this.totalCount());
    this.isEmpty = this.totalCount() > 0 ? false : true
  }
  /**
   * 移动一个元素到另一个位置
   */
  move(from: number, to: number) {
    let fromData = this.dataArray[from]
    let toData = this.dataArray[to]
    this.dataArray.splice(from, 1);
    if (from < to) {
      this.dataArray.splice(to - 1, 1, toData, fromData)
    } else {
      this.dataArray.splice(to, 1, fromData, toData)
    }
    this.listeners.forEach(listener => {
      if (from < to) {
        for (let i = from; i <= to; i ++) {
          listener.onDataChange(i);
        }
      } else {
        for (let i = to; i <= from; i ++) {
          listener.onDataChange(i);
        }
      }
      // listener.onDatasetChange([{type: DataOperationType.DELETE, index: index}]);
      //this.reloadData()
      console.log('onDataDelete')
    })
    //this.reloadData()
    console.log('move')
  }

  /**
   * 通知组件刷新，能够重置键值keyGenerator
   */
  reloadData(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }
  /**
   * 修改一个数据
   */
  change(index: number, data: T): void {
    this.dataArray.splice(index, 1, data);
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
      //this.reloadData()
      console.log('change')
    })
  }
  /**
   * 交换两个位置的数据
   */
  exChange(aIndex: number, bIndex: number): void {
    let aItem = this.dataArray[aIndex]
    let bItem = this.dataArray[bIndex]
    this.dataArray.splice(aIndex, 1, bItem);
    this.dataArray.splice(bIndex, 1, aItem);
    //this.reloadData()
    this.listeners.forEach(listener => {
      listener.onDataChange(aIndex);
      listener.onDataChange(bIndex);
      //this.reloadData()
      console.log('change')
    })
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }
}