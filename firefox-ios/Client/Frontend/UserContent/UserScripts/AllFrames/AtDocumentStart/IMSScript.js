"use strict";

window.__firefox__.includeOnce("IMSScript", function () {
  function IMSScript() {
    const documentMessageTypeIdentifierForThirdPartyTell = "immersiveTranslateDocumentMessageThirdPartyTell";
    const documentMessageTypeIdentifierForTellThirdParty = "immersiveTranslateDocumentMessageTellThirdParty";
    
    this.translatePage = function () {
      this.sendMessage("translatePage", {});
    };

    this.restorePage = function () {
      this.sendMessage("restorePage", {});
    };

    this.getPageStatusAsync = function () {
      this.sendAsyncMessage("getPageStatusAsync", {}).then((ret) => {
        webkit.messageHandlers.imsScriptMessageHandler.postMessage({
          type: "getPageStatusAsync",
          value: ret
        });
      }).catch((e) => {
          console.error(e);
      })
    };

    this.setConfigLanguage = async function (targetLanguage) {
      const res = await this.sendAsyncMessage("setConfig", {
        targetLanguage: targetLanguage,
      });
      return res;
    };

    this.getConfig = async function () {
      const { targetLanguage, sourceLanguage } = await this.sendAsyncMessage(
        "getConfig",
        {}
      );
      return {
        targetLanguage,
        sourceLanguage,
      };
    };

    this.getPageLanguageAsync = async function () {
      const sourceLanguage = await this.sendAsyncMessage(
        "getPageLanguageAsync",
        {}
      );
      return sourceLanguage;
    };

    this.openPopup = function (style, isSheet, overlayStyle) {
      this.sendMessage("openPopup", {
        style: style,
        isSheet: isSheet,
        overlayStyle: overlayStyle,
      });
    };

    this.closePopup = function () {
      this.sendMessage("closePopup", {});
    };
    this.togglePopup = function (style, isSheet, overlayStyle) {
      this.sendMessage("togglePopup", {
          style: style,
          isSheet: isSheet,
          overlayStyle: overlayStyle,
      });
    };
    this.sendMessage = function (type, data) {
      document.dispatchEvent(
        new CustomEvent(documentMessageTypeIdentifierForThirdPartyTell, {
          detail: JSON.stringify({
            type: type,
            data: data,
          }),
        })
      );
    };

    this.sendAsyncMessage = function (type, data) {
      return new Promise((resolve, reject) => {
        const messageId = Math.random().toString(36).substr(2);
        const messageHandler = (event) => {
          if (!event.detail) {
            return;
          }
          const message = JSON.parse(event.detail);
          if (message.id === messageId) {
            document.removeEventListener(
              documentMessageTypeIdentifierForTellThirdParty,
              messageHandler
            );
            resolve(message.payload);
          }
        };
        document.addEventListener(
          documentMessageTypeIdentifierForTellThirdParty,
          messageHandler
        );
        document.dispatchEvent(
          new CustomEvent(documentMessageTypeIdentifierForThirdPartyTell, {
            detail: JSON.stringify({
              type: type,
              data: data,
              id: messageId,
            }),
          })
        );
      });
    };
  }
  Object.defineProperty(window.__firefox__, "IMSScript", {
    enumerable: false,
    configurable: false,
    writable: false,
    value: Object.freeze(new IMSScript()),
  });
});
