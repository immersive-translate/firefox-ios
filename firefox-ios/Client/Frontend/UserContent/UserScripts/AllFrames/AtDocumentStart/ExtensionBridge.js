(() => {
  class ExtensionBridge {
    constructor() {
      globalThis.document.addEventListener(
        "ImtExtensionToNative",
        (event) => {
          window.webkit.messageHandlers.imsScriptMessageHandler.postMessage(
            event.detail,
          );
        },
      );
    }

    sendMessages(options) {
      globalThis.document.dispatchEvent(
        new CustomEvent("ImtNativeToExtension", { detail: options }),
      );
    }
  }

  let imtExtensionBridge = new ExtensionBridge();

  window.imtExtensionBridge = new Proxy(imtExtensionBridge, {
    get: function (target, prop) {
      return (options) => {
        const { id, data } = options || {};
        return target.sendMessages({
          type: prop,
          id,
          data,
        });
      };
    },
  });
})();
