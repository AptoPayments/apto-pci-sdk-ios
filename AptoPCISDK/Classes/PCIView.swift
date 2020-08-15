//
// PCIView.swift
// AptoPCISDK
//
// Created by Ivan Oliver on 15/11/2018.
//

import UIKit
import WebKit

public class PCIView: UIView, WKNavigationDelegate, WKUIDelegate {
  let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
  var queue = OperationQueue()
  private let javascriptPrefix = "window.AptoPCISDK"
  @objc public var styles: [String: Any] = [:] {
    didSet {
      customiseUI()
    }
  }
  @objc public var showCvv: Bool = true {
    didSet {
      customiseUI()
    }
  }
  @objc public var showExp: Bool = true {
    didSet {
      customiseUI()
    }
  }
  @objc public var showPan: Bool = true {
    didSet {
      customiseUI()
    }
  }
  @objc public var showName: Bool = true {
    didSet {
      customiseUI()
    }
  }
  @objc public var isCvvVisible: Bool = true {
    didSet {
      customiseUI()
    }
  }
  @objc public var isExpVisible: Bool = true {
    didSet {
      customiseUI()
    }
  }

  @objc public var alertTexts: [String: String]?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initQueue()
    initWebView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initQueue()
    initWebView()
  }
  
  @objc public func initialise(apiKey: String, userToken: String, cardId: String, lastFour: String, environment: String, name: String? = nil) {
    var parameters = "'\(apiKey)', '\(userToken)', '\(cardId)', '\(lastFour)', '\(environment)'"
    if let name = name {
      parameters += ", '\(name)'"
    }
    queue.addOperation(WebViewOperation(
      webView: webView,
      javascript: "\(javascriptPrefix).initialise(\(parameters))"
    ))
  }
  
  @objc public func lastFour() {
    queue.addOperation(WebViewOperation(
      webView: webView,
      javascript: "\(javascriptPrefix).lastFour()"
    ))
  }
  
  @objc public func obfuscate() {
    queue.addOperation(WebViewOperation(
      webView: webView,
      javascript: "\(javascriptPrefix).obfuscate()"
    ))
  }
  
  @objc public func reveal() {
    queue.addOperation(WebViewOperation(
      webView: webView,
      javascript: "\(javascriptPrefix).reveal()"
    ))
  }
  
  private func customiseUI() {
    if let flagsString = dictToString(dict: ["showPan": showPan,
                                             "showCvv": showCvv,
                                             "showExp": showExp,
                                             "showName": showName,
                                             "isCvvVisible": isCvvVisible,
                                             "isExpVisible": isExpVisible
    ]),
      let stylesString = dictToString(dict: styles){
      queue.addOperation(WebViewOperation(
        webView: webView,
        javascript: "\(javascriptPrefix).customiseUI('\(flagsString)', '\(stylesString)')"
      ))
    }
  }
  
  private func dictToString(dict: [String: Any]) -> String? {
    if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
      return String(data: data, encoding: .utf8)
    }
    return nil
  }

  private func initQueue() {
    queue.name = "PCIView operations queue"
    queue.maxConcurrentOperationCount = 1
    queue.isSuspended = true
  }
  
  private func initWebView(){
    webView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(webView)
    webView.isOpaque = false
    webView.backgroundColor = .clear
    webView.scrollView.backgroundColor = .clear
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: self.topAnchor),
      webView.leftAnchor.constraint(equalTo: self.leftAnchor),
      webView.rightAnchor.constraint(equalTo: self.rightAnchor),
      webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])
    webView.navigationDelegate = self
    webView.uiDelegate = self
    let podBundle = Bundle(for: self.classForCoder)
    if let myURL = podBundle.url(forResource: "container", withExtension: "html") {
      webView.loadFileURL(myURL, allowingReadAccessTo: myURL.deletingLastPathComponent())
    }
  }
}

internal class WebViewOperation: Operation {
  let javascript: String
  let webView: WKWebView
  let dispatchQueue: DispatchQueue

  init(webView: WKWebView, javascript: String, on: DispatchQueue? = nil) {
    self.javascript = javascript
    self.webView = webView
    self.dispatchQueue = on ?? DispatchQueue.main
  }

  override func main() {
    dispatchQueue.async {
      self.webView.evaluateJavaScript(self.javascript)
    }
  }
}

public extension PCIView {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    queue.isSuspended = false
  }
  
  func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
               initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    let alertController = UIAlertController(title: nil, message: alertText(key: "wrongCode.message"), preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: alertText(key: "wrongCode.okAction"), style: .default, handler: { action in
      completionHandler()
    }))
    
    findViewController()?.present(alertController, animated: true, completion: nil)
  }
  
  func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?,
               initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    let alertController = UIAlertController(title: nil, message: alertText(key: "inputCode.message"), preferredStyle: .alert)
    alertController.addTextField(configurationHandler: { textField in
      textField.text = defaultText
    })
    
    alertController.addAction(UIAlertAction(title: alertText(key: "inputCode.okAction"), style: .default, handler: { action in
      if let text = alertController.textFields?.first?.text {
        completionHandler(text)
      } else {
        completionHandler(defaultText)
      }
    }))
    
    alertController.addAction(UIAlertAction(title: alertText(key: "inputCode.cancelAction"), style: .default, handler: { action in
      completionHandler(nil)
    }))
    
    findViewController()?.present(alertController, animated: true, completion: nil)
  }
  
  private func alertText(key: String) -> String {
    if let text = alertTexts?[key] {
      return text
    } else {
      return key.podLocalized()
    }
  }
}

private extension String {
  func podLocalized() -> String {
    return self.podLocalized(PCIView.classForCoder())
  }
  
  func podLocalized(_ bundleClass:AnyClass) -> String {
    return getBundleTranslation(Bundle(for:bundleClass))
  }
  
  func getBundleTranslation(_ bundle:Bundle) -> String {
    var language =  Locale.preferredLanguages[0].lowercased()
    let path = bundle.path(forResource: language, ofType: "lproj")
    if let path = path, let languageBundle = Bundle(path: path) {
      return NSLocalizedString(self, bundle: languageBundle, comment: "")
    }
    else {
      // Try with just the language without region
      language = language.prefixUntil("-")
      let path = bundle.path(forResource: language, ofType: "lproj")
      if let path = path, let languageBundle = Bundle(path: path) {
        return NSLocalizedString(self, bundle: languageBundle, comment: "")
      }
      else {
        // Fall back to the user's language
        return NSLocalizedString(self, bundle: bundle, comment: "")
      }
    }
  }
  
  func prefixUntil(_ string:String) -> String {
    if let range = self.range(of: string) {
      let intIndex: Int = self.distance(from: self.startIndex, to: range.lowerBound)
      return self.prefixOf(intIndex)!
    }
    return self
  }
  
  func prefixOf(_ size:Int) -> String? {
    return String(self.prefix(size))
  }
}

extension UIView {
  func findViewController() -> UIViewController? {
    if let nextResponder = self.next as? UIViewController {
      return nextResponder
    } else if let nextResponder = self.next as? UIView {
      return nextResponder.findViewController()
    } else {
      return nil
    }
  }
}
