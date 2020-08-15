var _apiKey = '';
var _userToken = '';
var _cardId = '';
var _lastFour = '';
var _environment = '';
var _callback = ''

function _apto_PCI_SDK_loadScript(callback) {
    var head = document.head;
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = 'https://pci-web.ux.aptopayments.com/apto-pci-sdk-bundle.js';
    script.onreadystatechange = callback;
    script.onload = callback;
    head.appendChild(script);
}

function _apto_PCI_SDK_createIFrame(parent, callback) {
  var iframe = document.createElement('iframe');
  iframe.id = 'apto-iframe';
  iframe.src = 'https://pci-web.ux.aptopayments.com/index-fa1bc92c0223e0667c2b81f76152615a.html';
  iframe.style = 'border-width: 0px;';
  iframe.onload = callback;
  iframe.onreadystatechange = callback;
  parent.appendChild(iframe);
}

function aptoInitialiseSDK(apiKey, userToken, cardId, lastFour, environment, divName, callback) {
  _apiKey = apiKey;
  _userToken = userToken;
  _cardId = cardId;
  _lastFour = lastFour;
  _environment = environment;
  _callback = callback;
  const container = document.getElementById(divName);
  _apto_PCI_SDK_createIFrame(container, function() {
    _apto_PCI_SDK_loadScript(function() {
      window.AptoPCISDK.initialise(_apiKey, _userToken, _cardId, _lastFour, _environment);
      _callback();
    });
  })
}

function aptoCustomiseCardAppearance(styles, config = {showPan: true, showCvv: true, showExp: true}) {
  window.AptoPCISDK.customiseUI(JSON.stringify(config), JSON.stringify(styles));
}

function aptoShowCardLastFour() {
  window.AptoPCISDK.lastFour();
}

function aptoRevealCardDetails() {
  window.AptoPCISDK.reveal();
}

function aptoHideCardDetails() {
  window.AptoPCISDK.obfuscate();
}
