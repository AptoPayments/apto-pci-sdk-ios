# Apto iOS PCI SDK

[![CI Status](https://img.shields.io/travis/ioliver/AptoPCISDK.svg?style=flat)](https://travis-ci.org/ioliver/AptoPCISDK)
[![Version](https://img.shields.io/cocoapods/v/AptoPCISDK.svg?style=flat)](https://cocoapods.org/pods/AptoPCISDK)
[![License](https://img.shields.io/cocoapods/l/AptoPCISDK.svg?style=flat)](https://cocoapods.org/pods/AptoPCISDK)
[![Platform](https://img.shields.io/cocoapods/p/AptoPCISDK.svg?style=flat)](https://cocoapods.org/pods/AptoPCISDK)


The Apto PCI SDK provides a transparent `View` that can display the PCI data using a `webView`.

This document provides an overview of how to:

* [Install the SDK](#user-content-install-the-sdk)
* [Initialize the SDK](#user-content-initialize-the-sdk)
* [Show / Hide the PCI Data](#user-content-show--hide-the-pci-data)
* [Customize the PCI View](#user-content-customize-the-pci-view)

For more information, see the [Apto Developer Guides](http://docs.aptopayments.com).

To contribute to the SDK development, see [Contributions & Development](#user-content-contributions--development)

## Requirements

* iOS 10.0 (minimum version)
* Swift 5 (minimum version)
* CocoaPods. No minimum version is required, but version 1.8.3 or higher is recommended.

### Get the Mobile API key

A Mobile API Key is required to run the SDK. To retrieve your Mobile API Key:

1. Register for an account or login into the [Apto Developer Portal](https://developer.aptopayments.com). 
    
2. Select **Developers** from the menu. Your **Mobile API Key** is listed on this page.

    ![Mobile API Key](readme_images/devPortal_mobileApiKey.jpg)

    **Note:** `MOBILE_API_KEY` is used throughout this document to represent your Mobile API key. Ensure you replace `MOBILE_API_KEY` with the Mobile API Key in your account.

## Install the SDK

1. We suggest using [CocoaPods](https://cocoapods.org) to install the SDK:

2. At the top of your project's `Podfile`, ensure the platform is set to iOS 10 or higher, and frameworks are enabled:

```ruby
platform :ios, '10.0'

...

use_frameworks!
```

3. In the dependency section of your `Podfile`, add the Apto iOS SDK pod dependency:
	
```ruby
def runtimepods

	...

	pod 'AptoPCISDK'

	...
```

4. Open your Terminal app and navigate to your project's folder where the `Podfile` is contained:

```bash
	cd PATH_TO_PROJECT_FOLDER
```

5. Install the SDK with the following command:

```bash
	pod install
```

## Initialize the SDK

To initialize the PCI SDK:

1. Create a `PCIView` object:

```swift
let pciView = PCIView()
```

2. Add `pciView` to your main view:

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

3. You will need to implement the [iOS Mobile SDK](https://github.com/AptoPayments/apto-sdk-ios) or the [Mobile API](https://docs.aptopayments.com/api/MobileAPI.html) to retrieve the following values:

	* User Session Token
	* Card account ID

4. Create a `PCIConfigAuth` object. This manages the authentication configuration settings.

```swift
let configAuth = PCIConfigAuth(
	cardId: "ACCOUNT_ID",
	apiKey: "MOBILE_API_KEY",
	userToken: "USER_TOKEN",
	environment: .sbx)
```

Parameter|Description
---|---
`apiKey`|This value is the Mobile API Key (`MOBILE_API_KEY`) retrieved from the [Apto Developer Portal](https://developer.aptopayments.com).
`userToken`|This value is the user session token (`USER_TOKEN`) retrieved from the login flow.
`cardId`|This value is the account ID (`ACCOUNT_ID`) of the card with the format `crd_XXXXXXXXXX`.
`environment`|This value is the deployment mode for your app. The available values are:<ul><li>`.sbx` - Sandbox mode</li><li>`.prd` - Production mode</li></ul>

5. *(Optional)* Create a `PCIConfigCard` object, passing in the cardholder's name and the last four digits of the card. See [Display Card Data Elements](#user-content-display-card-data-elements) for more info.

```swift
let configCard = PCIConfigCard(lastFour: "XXXX",
                               nameOnCard: "NAME_ON_CARD")
```

5. Create a `PCIConfig` object, passing in the `configAuth`, `configCard`, and/or `style` parameters. See [Display Card Data Elements](#user-content-display-card-data-elements) for more information about the `PCIConfig` object.

```swift
let config = PCIConfig(configAuth: configAuth,
                       configCard: configCard)
```

6. Initialize the PCI view using `pciView.initialise`, passing in the `pciConfig` as the `PCIConfig` object.

```swift
pciView.initialise(pciConfig)
```

## Show / Hide the PCI Data

The PCI SDK enables you to:

* Show the card's complete data. To show the card's complete data, use the `showPCIData` method: `pciView.showPCIData()`.

	**Note:** The user will receive an SMS or email with a one-time passcode. This password must be entered into the displayed dialog box. If the passcode is correct, the PCI data will be shown.

* Show only the card's last four digits (if set). This hides all the PCI data. To hide all the PCI data except for the card's last four digits, use the `hidePCIData` method: `pciView.hidePCIData()`.

## Customize the PCI View

The PCI SDK uses configuration objects to change the default PCI configuration. The following elements can be customized:

* [Display Card Data Elements](#user-content-display-card-data-elements)
* [Style Card Elements](#user-content-style-card-elements)
* [Style Alerts](#user-content-style-alerts)

### Display Card Data Elements

The `PCIConfigCard` object is used to set card configurations. The following configurations are available:

Property|Description
---|---
`lastFour`|String value used as placeholders for the last 4 digits of the card when hidden. The default value is: `••••`
`labelPan`|String value specifying the text for the PAN (Primary Account Number) description label. The default value is an empty string.
`labelCvv`|String value specifying the text for the CVV description label. The default value is `CVV`.
`labelExp`|String value specifying the text for the expiration date description label. The default value is `EXP`.
`nameOnCard`|String value specifying the name displayed on the card. The default value is an empty string.
`labelName`|String value specifying the text for the name description label. The default value is an empty string.

### Style Card Elements

To style the PCIView with a theme, use the `setTheme` method anytime after initialization. The method can receive one the following values:

Value|Description
---|---
`dark`|Use this value if you have a dark background. The card text will change to white.
`light`|Use this value if you have a light background. The card text will change to black.


To style the PCIView with specific configurations, use the `setStyle` method with a `PCIConfigStyle` object after the initialization.

The following configuration options are available for the PCIConfigStyle: 

Property|Description
---|---
`textColor`|A `String` value specifying the color of the card text elements in Hex (i.e. `FFFFFF` for white)


### Style Alerts

To customize the text shown in alerts, assign a dictionary to the `alertTexts` property with the following values:

Text Option|Description
---|---
`inputCode.message`|A string value specifying the Alert message text.
`inputCode.okAction`|A string value specifying the OK button text.
`inputCode.cancelAction`|A string value specifying the cancel button text.
`wrongCode.message`|A string value specifying the message displayed, when the user enters a wrong code.


## Contributions & Development

We look forward to receiving your feedback, including new feature requests, bug fixes and documentation improvements.

If you would like to help:

1. Refer to the [issues](https://github.com/AptoPayments/apto-pci-sdk-ios/issues) section of the repository first, to ensure your feature or bug doesn't already exist (The request may be ongoing, or newly finished task).
2. If your request is not in the [issues](https://github.com/AptoPayments/apto-pci-sdk-ios/issues) section, please feel free to [create one](https://github.com/AptoPayments/apto-pci-sdk-ios/new). We'll get back to you as soon as possible.

If you want to help improve the SDK by adding a new feature or bug fix, we'd be happy to receive [pull requests](https://github.com/AptoPayments/apto-pci-sdk-ios/compare)!

## License

AptoPCISDK is available under the MIT license. See the [LICENSE file](https://github.com/AptoPayments/apto-pci-sdk-ios/AptoPCISDK/LICENSE) for more info.
