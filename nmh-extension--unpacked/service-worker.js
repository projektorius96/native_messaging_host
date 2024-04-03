chrome.action.onClicked.addListener((tab) => {
    chrome.runtime.sendNativeMessage(
        'com.my_company.my_application',
        {text: 'Hello from Chrome'},
        function (response) {
            console.log('Received ' + response);
        }
    );
});