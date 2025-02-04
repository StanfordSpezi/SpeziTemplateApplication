# Build And Run the Spezi Template Application

<!--
#
# This source file is part of the Stanford Spezi Template Application open-source project
#
# SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#       
-->

The Spezi Template Application is a fully functioning iOS application built using the [Stanford Spezi](https://spezi.stanford.edu) ecosystem that can be used as a starting point for creating your own iOS app. The following tutorial will walk you through the steps needed to configure your Mac to build and run the Spezi Template Application, after which you can customize it for your own project.

## 1. Install Xcode

Applications for the Apple ecosystem are written in the [Swift programming language](https://swift.org).
The framework for developing the user interface for mobile applications in Swift is called [SwiftUI](https://developer.apple.com/xcode/swiftui/).

You will need access to a macOS-based machine to build and run the Swift-based Spezi Template Application. Please ensure that your Mac meets the following criteria and that you install or update the software on your Mac accordingly.

### macOS - Sequoia 15.2 Or Newer

The Mac needs to run macOS Sequoia 15.2 or newer. Please [update to the latest operating system version following the Apple-provided instructions](https://support.apple.com/en-us/HT201541). You can verify that you run the latest macOS version by clicking on the Apple Logo on the top left of your screen and selecting "About this Mac". You can see the macOS version number in the specs list under your Mac picture.

### Xcode - 16.2 Or Newer

Xcode is the integrated development environment (IDE) that is required to build and run Swift-based iOS applications.
You need to have Xcode 16.2 or later installed. [You can install Xcode using the Mac AppStore](https://apps.apple.com/us/app/xcode/id497799835).

Please open Xcode and follow the instructions to finish the installation.

You can verify that you run the latest version of Xcode and everything is installed if you can see the "Welcome to Xcode" screen when you open Xcode, showing 16.2 or newer as the version number.

@Image(source: "Xcode", alt: "Screenshot showing the Welcome to Xcode window.")

You can learn more about Xcode, including [creating an Xcode project for an app](https://developer.apple.com/documentation/xcode/creating-an-xcode-project-for-an-app), information about the IDE interface by following the instructions on [creating your app's interface with SwiftUI](https://developer.apple.com/documentation/xcode/creating-your-app-s-interface-with-swiftui) & [Previewing your app's interface in Xcode](https://developer.apple.com/documentation/xcode/previewing-your-apps-interface-in-xcode).


## 2. Install Helper Tools

The Spezi Template Application provides a set of pre-configured tools that simplify app development and enforce best practices.

We provide a simple setup script that installs essential tools like [homebrew](https://brew.sh) (macOS package manager) and [git LFS](https://git-lfs.com) (Git extension for versioning large files).

The script also installs the [Google Firebase emulator and command line interface (CLI)](https://firebase.google.com/docs/cli) and all its dependencies, including Java and Node.js, letting you test cloud features locally without setting up a Firebase project.

You can simply run the script by opening up your macOS [Terminal](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac) and executing the following command:

```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/StanfordSpezi/SpeziTemplateApplication/HEAD/Scripts/setup.sh)"
```

> Tip: If you don't feel comfortable running the setup script, you can [inspect the script yourself](https://raw.githubusercontent.com/StanfordSpezi/SpeziTemplateApplication/HEAD/Scripts/setup.sh) and use the commands in the script to install the required software yourself selectively.


## 3. Set Up the Backend

As with most complex mobile applications, Stanford Spezi relies on a cloud-based backend to handle user authentication, data storage, and other services. [Google Firebase](https://firebase.google.com) is a managed backend cloud computing platform provided by Google that is pre-integrated with the Spezi Template Application.

> Tip: Although the Spezi Template Application is pre-integrated with Google Firebase, Spezi itself is independent of any cloud provider or platform! Spezi offers different modules to connect to cloud providers, including [Spezi Firebase](https://github.com/StanfordSpezi/SpeziFirebase), which is the cloud provider demonstrated in the Spezi Template Application.

There are two alternatives for testing the Spezi Template Application.

- A. Run the application without Firebase: This option disables all cloud-based functionality but allows for basic testing of local features.
- B. Use the Firebase Emulator Suite: This method emulates Firebase services locally on your Mac, providing a more complete testing environment that mimics cloud functionality.

> Important: These testing approaches are meant for development purposes only. For production deployment, you'll need to use an actual Firebase account. Stanford researchers can utilize the Stanford mHealth platform, Stanford's dedicated Firebase instance that supports many digital health projects.

### Alternative A: Test without Firebase

You can test the application without a backend if you enable the `--disableFirebase` feature flag, which is *enabled by default when opening the Xcode project*. This will disable all cloud-based functionality in the application, including user registration, sign in, and data upload. The login and account setup steps will therefore be skipped in this configuration.

> Tip: Feature flags can be configured in the [scheme editor in Xcode](https://help.apple.com/xcode/mac/11.4/index.html?localePath=en.lproj#/dev0bee46f46) and selecting your application scheme (default **TemplateApplication**), the **Run** configuration, and to switch to the **Arguments** tab to add, enable, disable, or remove arguments passed on launch.

@Image(source: "Scheme", alt: "Screenshot showing the application scheme Run configuration's launch arguments.")


### Alternative B: Set Up the Firebase Emulator Suite

The application also provides a [Firebase Firestore](https://firebase.google.com/docs/firestore)-based data upload mechanism and [Firebase Authentication](https://firebase.google.com/docs/auth) login & sign-up. If you wish to test this functionality, you will need to have the [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite) installed and running. This tool emulates a cloud-based backend on your Mac and does not require that you have a Firebase account to use.

The setup script described above installs the [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite).

> Important: You do not have to make any modifications to the Firebase configuration, log into the `Firebase` CLI using your Google account, or create a project in Firebase to run, build, and test the application!

Navigate to the root folder of this setup containing your **.xcodeproj** file ([using `cd` in your terminal](https://tutorials.codebar.io/command-line/introduction/tutorial.html)) and start the [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite) in your [Terminal](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac) using
```bash
$ firebase emulators:start
```

@Image(source: "FirebaseCLI", alt: "Screenshot showing the terminal and the running Firebase Emulators.")

After the emulators have started up, you can open the web interface by navigating to `http://127.0.0.1:4000/` in your web browser. When you run the Spezi Template Application in the next step, you will be able to use the application and see data populating in the emulator.

@Image(source: "FirebaseWeb", alt: "Screenshot showing Safari and the Firebase Emulators web interface.")


## 4. Run the App

You can build and run the Spezi Template Application using [Xcode](https://developer.apple.com/xcode/) by opening up the **.xcodeproj** file in the root of the repository. Ensure that the `Run Destination` in the upper toolbar is set to an iOS simulator such as `iPhone 16 Pro (18.0)`.

For more information and details on how to run the app on other simulators or physical devices, please see [Building and running an app](https://developer.apple.com/documentation/xcode/building-and-running-an-app) in the official Apple documentation.

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

> Tip: When building the application you may encounter a build error "Target 'SpeziAccountMacros' must be enabled before it can be used.'". This error can be addressed by clicking on the error message in the Issue Navigator and selecting the "Trust & Enable" option.

## 5. Modify The Application

Now that you have successfully built and run the Spezi Template Application on your Mac, you can start customizing the application for your project. Continue with the <doc:Modify> article to learn how to make common modifications to the Spezi Template Application.


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
