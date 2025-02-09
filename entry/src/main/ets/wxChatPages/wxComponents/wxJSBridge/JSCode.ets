/**
 * define the runJavaScript code.
 */
export const code = `
  const JSBridgeMap = {};
  let callID = 0;

  function JSBridgeCallback (id, params) {
    JSBridgeMap[id](params);
    JSBridgeMap[id] = null;
    delete JSBridgeMap[id];
  }

  window.ohosCallNative = {
    callNative(method, params, callback) {
      const id = callID++;
      const paramsObj = {
          callID: id,
          data: params || null
      }
      JSBridgeMap[id] = callback || (() => {});
      JSBridgeHandle.call(method, JSON.stringify(paramsObj));
    }
  }
`;