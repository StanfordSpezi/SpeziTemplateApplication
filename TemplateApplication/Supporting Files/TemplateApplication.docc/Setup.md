# Build And Run a Spezi Template Application-based Application

<!--
#
# This source file is part of the Stanford Spezi Template Application open-source project
#
# SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#       
-->

How to install all the nescessary software to build, run, and modify your Spezi Template Application-base Spezi app.

## 1. Install Xcode

Applications for the Apple ecosystem are written in the [Swift programming language](https://swift.org).
The framework for developing the user interface for mobile applications in Swift is called [SwiftUI](https://developer.apple.com/xcode/swiftui/).
You will need access to a macOS-based machine to build and run the Swift-based Spezi Template Application.

Please ensure that your Mac meets the following criteria and that you install or update the software on your Mac accordingly.


### macOS - Sonoma 14.2 Or Newer

The Mac needs to run macOS Sonoma 14.2 or newer. Please [update to the latest operating system version following the Apple-provided instructions](https://support.apple.com/en-us/HT201541).

You can verify that you run the latest macOS version by clicking on the Apple Logo on the top left of your screen and selecting "About this Mac". You can see the macOS version number in the specs list under your Mac picture.


### Xcode - 15.2 Or Newer

Xcode is the integrated development environment (IDE) that is required to build and run Swift-based iOS applications.
You need to have Xcode 15.2 or later installed.
[You can install Xcode using the Mac AppStore](https://apps.apple.com/us/app/xcode/id497799835).

Please open Xcode and follow the instructions to finish the installation.

You can verify that you run the latest version of Xcode and everything is installed if you can see the "Welcome to Xcode" screen when you open Xcode, showing 15.2 or newer as the version number.

@Image(source: "Xcode", alt: "Screenshot showing the Welcome to Xcode window.")

You can learn more about Xcode, including [creating an Xcode project for an app](https://developer.apple.com/documentation/xcode/creating-an-xcode-project-for-an-app), information about the IDE interface by following the instructions on [creating your app's interface with SwiftUI](https://developer.apple.com/documentation/xcode/creating-your-app-s-interface-with-swiftui) & [Previewing your app's interface in Xcode](https://developer.apple.com/documentation/xcode/previewing-your-apps-interface-in-xcode).


## 2. Install Helper Tools

The Spezi Template Application and applications derived from it provide a pre-configured setup of integrated tools that make the development of applications easier and enforce best practices during the development of your application.

We provide a simple setup script that installs essential tools like [homebrew](https://brew.sh) (macOS package manager), [swiftlint](https://github.com/realm/SwiftLint) (automated checking of your source code for programmatic and stylistic errors), [git LFS](https://git-lfs.com) (Git extension for versioning large files), and [swift-package-list](https://github.com/FelixHerrmann/swift-package-list) (automatically give credit to all dependencies in the application user interface).
The script also installs the [Google Firebase emulator and command line interface (CLI)](https://firebase.google.com/docs/cli), including java, node, and other dependencies needed to execute the Firebase emulator to allow you to locally test your application's future cloud connection without setting up a cloud firebase project.

You can simply run the script by opening up your macOS [Terminal](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac) and executing the following command:
```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/StanfordSpezi/SpeziTemplateApplication/HEAD/Scripts/setup.sh)"
```

> Tip: If you don't feel comfortable running the setup script, you can [inspect the script yourself](https://raw.githubusercontent.com/StanfordSpezi/SpeziTemplateApplication/HEAD/Scripts/setup.sh) and use the commands in the script to install the required software yourself selectively.


## 3. Run The Application

[Google Firebase](https://firebase.google.com) is a set of backend cloud computing services and application development platforms provided by Google.
It hosts databases, services, authentication, and integration for a variety of applications, including mobile applications like the Spezi Template Application.
Stanford provides its version of a Firebase instance in the form of the [Stanford mHealth platform](https://med.stanford.edu/mhealth.html).
We use Firebase and the mHealt platform as the default integrated cloud provided in the Spezi Template Application.

> Tip: Spezi itself is independent of any cloud provider or platform! Spezi offers different modules to connect to cloud providers, including [Spezi Firebase](https://github.com/StanfordSpezi/SpeziFirebase), which is the cloud provider demonstrated in the Spezi Template Application.


### Alternative A: Get Started without Firebase

You can start using the application without a cloud connection if you enable the `--disableFirebase` feature flag, enabled by default when opening the Xcode project.

The application includes feature flags that can be configured in the [scheme editor in Xcode](https://help.apple.com/xcode/mac/11.4/index.html?localePath=en.lproj#/dev0bee46f46) and selecting your application scheme (default **TemplateApplication**), the **Run** configuration, and to switch to the **Arguments** tab to add, enable, disable, or remove arguments passed on launch.

@Image(source: "Scheme", alt: "Screenshot showing the application scheme Run configuration's launch arguments.")

The login and account setup is skipped in this configuration.


### Alternative B: Firebase Setup

The application also provides a [Firebase Firestore](https://firebase.google.com/docs/firestore)-based data upload and [Firebase Authentication](https://firebase.google.com/docs/auth) login & sign-up.
It is required to have the [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite) to be up and running to use these features to build and test the application locally.
The setup script described above installs the [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite).

> Important: You do not have to make any modifications to the Firebase configuration, log into the `Firebase` CLI using your Google account, or create a project in Firebase to run, build, and test the application!

Navigate to the root folder of this setup containing your **.xcodeproj** file ([using `cd` in your terminal](https://tutorials.codebar.io/command-line/introduction/tutorial.html)) and startup the [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite) in your [Terminal](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac) using
```bash
$ firebase emulators:start
```

@Image(source: "FirebaseCLI", alt: "Screenshot showing the terminal and the running Firebase Emulators.")

After the emulators have started up, you can run the application in your simulator to build, test, and run the application and see the results show up in Firebase.

@Image(source: "FirebaseWeb", alt: "Screenshot showing Safari and the Firebase Emulators web interface.")


### Run the App

You can build and run the application using [Xcode](https://developer.apple.com/xcode/) by opening up the **.xcodeproj** file in the root of the repository.

You can follow the Apple Documentation on [Building and running an app](https://developer.apple.com/documentation/xcode/building-and-running-an-app) to run the application in the iOS simulator right on your Mac.

@Row(numberOfColumns: 4) {
    @Column(size: 3) {
        @Image(source: "Run", alt: "Press the run button in the upper left corner to run the app.") {
            Press the run button in the upper left corner to run the app.
        }
    }
    @Column {
        @Image(source: "Welcome", alt: "The Spezi Template Application running in the iOS Simulator.") {
            The Spezi Template Application running in the iOS Simulator.
        }
    }
}

## 4. Modify The Application

> Tip: You can learn more about changing up the code if the application and customizing your Spezi Template Application-based app in the <doc:Modify> article.


### Firebase Cloud Setup

If you want to connect your project to a development or production Firebase cloud project, you can provide your [`GoogleService-Info.plist`](https://firebase.google.com/docs/ios/setup) in a base 64 representation in the [GitHub secrets](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions) (`GOOGLE_SERVICE_INFO_PLIST_BASE64`) of your project where it is picked up and loaded in the configured path setup in the [`beta-deployment.yml`] [GitHub Action](https://docs.github.com/en/actions) using the `googleserviceinfoplistpath` parameter that needs to be adapted to your project structure.

You can generate a base 64 representation of a file after you [navigated into the folder](https://en.wikipedia.org/wiki/Cd_(command)#Usage) where you have downloaded your [`GoogleService-Info.plist`](https://firebase.google.com/docs/ios/setup) file to.
```shell
base64 -i GoogleService-Info.plist
```

> Warning: We do **not recommend** to commit your Firebase secrets and configuration file to your project. While one can extract the file from the deployed application, we encourage open-source projects to make it clear to contributors to set up their own Firebase project if they plan to build and deploy a version of an open-source project.

The deployment requires you to store your Google service account JSON credentials in a base 64 representation in the `GOOGLE_APPLICATION_CREDENTIALS_BASE64`. You can learn more about how to generate the JSON in the [Firebase documentation](https://firebase.google.com/docs/app-distribution/authenticate-service-account). The service account must have the minimally required permissions (not the `Firebase App Distribution Admin` role) as documented at https://firebase.google.com/docs/projects/iam/roles-predefined for your deployment needs and setup.

Be sure to update your `.firebaserc` project name and placeholder `GoogleService-Info.plist` project identifier to always reflect the name of your project and all security rules to reflect any changes in your application.


### Other Configuration Options

The application also includes the following feature flags that can be configured in the [scheme editor in Xcode](https://help.apple.com/xcode/mac/11.4/index.html?localePath=en.lproj#/dev0bee46f46) and selecting your scheme, the **Run** configuration, and to switch to the **Arguments** tab to add, enable, disable, or remove the following arguments passed on launch:
- `--skipOnboarding`: Skips the onboarding flow to enable easier development of features in the application and to allow UI tests to skip the onboarding flow.
- `--showOnboarding`: Always show the onboarding when the application is launched. Makes it easy to modify and test the onboarding flow without the need to manually remove the application or reset the simulator.
- `--disableFirebase`: Disables the Firebase interactions, including the login/sign-up step and the Firebase Firestore upload.
- `--useFirebaseEmulator`: Defines if the application should connect to the local Firebase emulator. Always set to true when using the iOS simulator.

> Tip: You can learn how to add, modify, and remove feature flags that are passed to the application when it is started in the [Customizing the build schemes for a project](https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project#Specify-launch-arguments-and-environment-variables) tutorial in the [*Specify launch arguments and environment variables* section](https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project#Specify-launch-arguments-and-environment-variables).
