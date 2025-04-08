"use strict";

/// 图片开始
imageLongPress();
function imageLongPress() {
  /// 拦截
  let touchStartTime = 0;
  let touchTimeout;

  document.addEventListener(
    "touchstart",
    function (event) {
      if (event.target.tagName === "IMG") {
        const imgUrl = event.target.src;
        touchStartTime = Date.now();
        touchTimeout = setTimeout(() => {
          // 长按事件触发（超过750ms）
          console.log("长按图片事件被触发");
          webkit.messageHandlers.imsScriptMessageHandler.postMessage({
            type: "imageLongPress",
            value: imgUrl,
          });
          // 这里可以添加你的长按处理逻辑
        }, 750);
        event.preventDefault();
        return false;
      }
    },
    { passive: false }
  );

  document.addEventListener("touchend", function (event) {
    if (event.target.tagName === "IMG") {
      clearTimeout(touchTimeout);
      const touchDuration = Date.now() - touchStartTime;
      if (touchDuration < 750) {
        // 短按事件处理
        console.log("点击图片事件被触发");
        // 这里可以添加你的点击处理逻辑
      }
    }
  });
}
