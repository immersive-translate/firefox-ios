"use strict";
(() => {
  /// 图片开始
  imageLongPress();

  function imageLongPress() {
    // Inject CSS to disable default context menu and selection ONLY for images
    // Do this early, but handle cases where head/documentElement might not be ready
    try {
      const style = document.createElement("style");
      style.textContent = `
        img {
          -webkit-touch-callout: none !important;
          -webkit-user-select: none !important;
        }
      `;
      style.id = "ims-long-press-image-styles"; // Keep ID for potential debugging

      // Find a suitable parent node to append the style tag
      const parentNode = document.head || document.documentElement;
      if (parentNode) {
        parentNode.appendChild(style);
        console.log(
          "Applied styles to disable touch callout/user select for images.",
        );
      } else {
        console.warn(
          "Could not find document.head or document.documentElement to inject styles at document_start.",
        );
        // As a fallback, might try again later using DOMContentLoaded or a MutationObserver
        // For now, just log a warning.
      }
    } catch (e) {
      console.error("Error injecting CSS for images:", e);
    }

    let touchTimeout = null;
    let startX = 0;
    let startY = 0;
    let targetImage = null;
    const moveThreshold = 10;
    const longPressDuration = 600; // User's value

    // Function to reset touch state variables
    function resetTouchState() {
      clearTimeout(touchTimeout);
      touchTimeout = null;
      startX = 0;
      startY = 0;
      targetImage = null;
    }

    document.addEventListener(
      "touchstart",
      function (event) {
        if (event.target.tagName === "IMG") {
          resetTouchState();
          targetImage = event.target;
          startX = event.touches[0].clientX;
          startY = event.touches[0].clientY;

          // Set the timer to detect long press
          touchTimeout = setTimeout(() => {
            if (targetImage) {
              // 1. Send message to Native
              webkit.messageHandlers.imsScriptMessageHandler.postMessage({
                type: "imageLongPress",
                data: targetImage.src,
              });

              // 2. Reset state
              resetTouchState();
            }
          }, longPressDuration);
        }
      },
      // Use passive: true since we rely on CSS for prevention
      { passive: true },
    );

    document.addEventListener("touchmove", function (event) {
      if (touchTimeout && targetImage) {
        const currentX = event.touches[0].clientX;
        const currentY = event.touches[0].clientY;
        const deltaX = Math.abs(currentX - startX);
        const deltaY = Math.abs(currentY - startY);

        if (deltaX > moveThreshold || deltaY > moveThreshold) {
          resetTouchState();
        }
      }
    }, { passive: true } // touchmove should be passive
    );

    document.addEventListener("touchend", function (event) {
      resetTouchState();
    });

    document.addEventListener("touchcancel", function (event) {
      resetTouchState();
    });
  }
})();
