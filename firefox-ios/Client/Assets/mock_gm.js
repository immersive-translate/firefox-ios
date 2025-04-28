// WebViewJavascriptBridge
(() => {
  async function WJ_doSend(obj, cb) {
    const { type, ...data } = obj;
    let result = null;
    if (type === "setDefaultBrowser") {
      await callNative("business.setDefaultBrowser", {});
    } else if (type === "isDefaultBrowser") {
      result = await callNative("business.isDefaultBrowser", {});
    } else if (type === "shareContent") {
      await callNative("business.shareContent", data);
    } else {
      result = await callNative(type, data);
    }
    if (cb) {
      cb(result);
    }
    return result;
  }

  function callNative(type, data = {}) {
    return new Promise((resolve) => {
      const id = Date.now() + Math.random().toString(36).substring(2, 15);
      globalThis.document.dispatchEvent(
        new CustomEvent("ImtExtensionToNative", {
          detail: {
            type,
            id,
            data,
          },
        }),
      );
      const listener = (event) => {
        if (event.detail.id === id) {
          resolve(event.detail.data);
          globalThis.document.removeEventListener(
            "ImtNativeToExtension",
            listener,
          );
        }
      };
      globalThis.document.addEventListener(
        "ImtNativeToExtension",
        listener,
      );
    });
  }
  let handlers = {};

  function registerHandler(name, handler) {
    handlers[name] = handler;
  }

  globalThis.document.addEventListener(
    "ImtNativeToExtension",
    (event) => {
      const { type, id, data } = event.detail;
      const eventHandler = handlers[type];
      if (eventHandler) {
        eventHandler(data, (data) => {
          globalThis.document.dispatchEvent(
            new CustomEvent("ImtExtensionToNative", {
              detail: {
                ...event.detail,
                id: event.detail.id,
                data: data,
              },
            }),
          );
        });
      }
    },
  );
  window.WebViewJavascriptBridge = {
    doSend: WJ_doSend,
    registerHandler: registerHandler,
  };
})();

async function GM_getValue(name, defaultVal) {
  let value = await window.WebViewJavascriptBridge.doSend({
    type: "localStorage.getItem",
    key: name,
  });
  try {
    value = value || defaultVal;
    return JSON.parse(value);
  } catch (error) {
    return value || defaultVal;
  }
}

function GM_setValue(name, value) {
  if (typeof value === "object") value = JSON.stringify(value);
  return window.WebViewJavascriptBridge.doSend({
    type: "localStorage.setItem",
    key: name,
    value: String(value),
  });
}

function GM_deleteValue(name) {
  return window.WebViewJavascriptBridge.doSend({
    type: "localStorage.removeItem",
    key: name,
  });
}

async function GM_listValues() {
  const length = await window.WebViewJavascriptBridge.doSend({
    type: "localStorage.length",
  });
  const keys = [];
  for (let i = 0; i < length; i++) {
    const value = await window.WebViewJavascriptBridge.doSend({
      type: "localStorage.key",
      index: i,
    });
    keys.push(value);
  }
  return keys;
}

async function GM_xmlhttpRequest(details) {
  const { url, method, ...options } = details;

  // options.body 是blob 将 body 转换为 base64
  if (typeof options.data === "object" && options.data instanceof Blob) {
    options.base64Data = await blobToBase64(options.data);
    delete options.data;
  }

  if (typeof options.data === "object" && options.data instanceof FormData) {
    const formDataObj = {};
    for (const [key, value] of options.data.entries()) {
      if (typeof value === "object" && value instanceof Blob) {
        formDataObj[`base64_${key}`] = await blobToBase64(value);
      } else {
        formDataObj[key] = value;
      }
    }
    options.formData = JSON.stringify(formDataObj);
    delete options.data;
  }

  const response = await window.WebViewJavascriptBridge.doSend({
    type: "httpClient.request",
    url: url,
    method: method,
    params: JSON.stringify(options),
  });
  // 假设原生端返回的响应是一个 JSON 对象，包含状态码和数据
  if (!response) {
    if (details.onerror) {
      details.onerror("No response received");
    }
    return;
  }

  try {
    const parsedResponse = JSON.parse(response);
    // 从响应头中获取Content-Type
    const contentType = parsedResponse.headers &&
        (parsedResponse.headers["Content-Type"] ||
          parsedResponse.headers["content-type"]) ||
      "application/json";
    const options = {
      status: parsedResponse.statusCode,
      statusText: parsedResponse.statusText,
      responseHeaders: parsedResponse.headers,
      responseURL: parsedResponse.responseURL,
      responseText: typeof parsedResponse.data == "object"
        ? JSON.stringify(parsedResponse.data)
        : parsedResponse.data,
    };

    // 处理不同类型的响应数据
    if (parsedResponse.base64Data) {
      options.response = base64ToBlob(
        parsedResponse.base64Data,
        contentType,
      );
    }

    if (details.onload) {
      details.onload(options);
    }
  } catch (error) {
    if (details.onerror) {
      details.onerror("Failed to parse response: " + error.message);
    }
  }
}

function blobToBase64(data) {
  const reader = new FileReader();
  const p = new Promise((resolve, reject) => {
    reader.onload = function () {
      const dataUrl = reader.result;
      resolve(dataUrl);
    };
    reader.onerror = function () {
      reject(reader.error);
    };
  });
  reader.readAsDataURL(data);
  return p;
}

function base64ToBlob(base64Data, contentType = "application/octet-stream") {
  if (!base64Data) return null;

  try {
    // 解码base64数据
    const byteCharacters = atob(base64Data);
    const byteArrays = [];

    // 将字符串数据分块并转换为Uint8Array
    for (let offset = 0; offset < byteCharacters.length; offset += 512) {
      const slice = byteCharacters.slice(offset, offset + 512);

      const byteNumbers = new Array(slice.length);
      for (let i = 0; i < slice.length; i++) {
        byteNumbers[i] = slice.charCodeAt(i);
      }

      const byteArray = new Uint8Array(byteNumbers);
      byteArrays.push(byteArray);
    }

    // 创建Blob对象，使用正确的MIME类型
    return new Blob(byteArrays, { type: contentType });
  } catch (error) {
    console.error("Error converting base64 to blob:", error);
    return null;
  }
}

function GM_registerMenuCommand(name, func, accessKey) {
  console.log(`Menu command registered: ${name}`);
  // 实际上，你需要在页面上添加一个用户界面元素，如按钮，并将 func 绑定为其点击事件处理程序
}

function GM_addStyle(css) {
  const style = document.createElement("style");
  style.type = "text/css";
  style.innerHTML = css;
  document.head.appendChild(style);
}

async function GM_openInTab(url, openInBackground) {
  return window.WebViewJavascriptBridge.doSend({
    type: "window.open",
    url,
  });
}

async function GM_getSelectedLanguage() {
  let value = await window.WebViewJavascriptBridge.doSend({
    type: "business.getSelectedLanguage",
  });
  try {
    return JSON.parse(value);
  } catch (error) {
    return {};
  }
}

window.GM = {
  getValue: GM_getValue,
  setValue: GM_setValue,
  deleteValue: GM_deleteValue,
  listValues: GM_listValues,
  xmlhttpRequest: GM_xmlhttpRequest,
  registerMenuCommand: GM_registerMenuCommand,
  addStyle: GM_addStyle,
  openInTab: GM_openInTab,
  getSelectedLanguage: GM_getSelectedLanguage,
};
