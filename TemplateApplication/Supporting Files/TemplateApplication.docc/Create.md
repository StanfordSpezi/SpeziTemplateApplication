# Create Your Spezi-based Application

<!--
#
# This source file is part of the Stanford Spezi Template Application open-source project
#
# SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#       
-->

How to create your own Spezi-based application based on the Spezi Template Application.


## 1. Create Your Own Repository

You can create your own Spezi-based application by creating a new GitHub repo and [using the Stanford Spezi Template Application as a template](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template).

> Tip: Spezi is completely independent of the Spezi Template Application or any other setup. You can always import one or more Spezi modules in any Swift and SwiftUI-based application.


## 2. Change The Name and Key Information

...


## 3. Setup the Continous Integration and Delivery Setup

Continuous integration (CI) and continuous delivery (CD) is essential to automatically test and deploy your application at any time.
Each Spezi Template Application-based Spezi app already has the nescessary infrastructure in place; the Spezi Template Application includes continuous integration (CI) and continuous delivery (CD) setup:
- Automatically build and test the application on every pull request before deploying it. If your organization doesn't have a self-hosted macOS runner modeled after the setup in the [StanfordBDHG ContinuousIntegration](https://github.com/StanfordBDHG/ContinousIntegration) setup, you will need to remove the `runsonlabels` arguments in the `build-and-test.yml` file to ensure that the build runs on the default macOS runners provided by GitHub.
- An automated setup to deploy the application to TestFlight every time there is a new commit on the repository's main branch.
- Ensure a coherent code style by checking the conformance to the SwiftLint rules defined in `.swiftlint.yml` on every pull request and commit.
- Ensure conformance to the [REUSE Specification]() to property license the application and all related code.

Please refer to the [Stanford Biodesign Digital Health Template Application](https://github.com/StanfordBDHG/TemplateApplication) and the [ContinuousDelivery Example by Paul Schmiedmayer](https://github.com/PSchmiedmayer/ContinousDelivery) for more background about the CI and CD setup for the Spezi Template Application.
