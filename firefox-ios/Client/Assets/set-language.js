const value = window.GM.getSelectedLanguage();
if (value) {
    const { code } = value;
    if (code) {
        const selectedLanguage = code;
        console.log('selectedLanguage:', selectedLanguage);
        document.dispatchEvent(new CustomEvent("immersiveTranslateDocumentMessageThirdPartyTell", { detail: `{"type":"setConfig","data":{"interfaceLanguage":"${selectedLanguage}"}}` }))
    }
}
