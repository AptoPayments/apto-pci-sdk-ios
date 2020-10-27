# AptoPCISDK

[![Version](https://img.shields.io/cocoapods/v/AptoPCI.svg?style=flat)](https://cocoapods.org/pods/AptoPCISDK)
[![License](https://img.shields.io/cocoapods/l/AptoPCI.svg?style=flat)](https://cocoapods.org/pods/AptoPCISDK)
[![Platform](https://img.shields.io/cocoapods/p/AptoPCI.svg?style=flat)](https://cocoapods.org/pods/AptoPCISDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AptoPCISDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AptoPCISDK'
```

## Using the PCI SDK

To use the PCI SDK, simply instantiate a PCIView and add it to yor view hierarchy:

```swift
view.addSubview(pciView)
pciView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
  pciView.topAnchor.constraint(equalTo: topConstraint, constant: 40),
  pciView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
  pciView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
  pciView.heightAnchor.constraint(equalToConstant: 240),
])
```

Then, initialize the SDK using the initialize medhod:

```swift
pciView.initialise(apiKey: "API_KEY",
                   userToken: "USER_TOKEN",
                   cardId: "CARD_ID",
                   lastFour: "1234",
                   environment: "sandbox")
```

Note: The allowed values for the `environment` parameter are `sandbox` and `production`.

To show the card's last four, use the following snippet:

```swift
pciView.lastFour()
```

To show the card's complete data, use the following snippet:

```swift
pciView.reveal()
```

The PCI SDK will verify the user (if needed) and will show the card data.

## Customise the PCI SDK

The PCI SDK look & feel can be customised in different ways:

### Showing / hiding elements

You can decide which elements are shown by the PCI SDK. There are three elements that can be shown / hidden:

1. PAN
1. CVV
1. Exp. Date

You can, also, define the css styles of various components, including:

1. IFrame (container)
1. PAN field.
1. CVV field.
1. Exp. Date field

### Styling elements

To customise the PCI look and feel, you can use the following snippet:

```swift
pciView.showPan = true
pciView.showCvv = false
pciView.showExp = false
pciView.styles = [
  "container": "color: red",
  "content": [
    "pan": "color: blue",
    "cvv": "color: yellow",
    "exp": "color: green"
  ]
]
```

### Text customization

To customize the different texts shown in alerts, you can use the following attribute:

```swift
pciView.alertTexts = [
    "inputCode.message": "What's your secret code?",
    "inputCode.okAction": "Ok",
    "inputCode.cancelAction": "Cancel",
    "wrongCode.message": "Invalid code",
    "wrongCode.okAction": "Ok"
]
```

## Author

Pau Teruel, pau@aptopayments.com

## License

AptoPCISDK is available under the MIT license. See the LICENSE file for more info.
