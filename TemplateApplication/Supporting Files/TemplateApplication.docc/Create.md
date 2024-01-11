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

The Spezi Template application repository provides a convenient script to rename all aspects of the Spezi Template Application to your application name, update the bundle identifier, and remove unused documentation and files that are not needed for your own project.

The shell script can be called as follows:
```bash
$ sh Scripts/create.sh --name <appName> --bundleIdentifier <bundleId> [--provisioningProfile <procitationFile>]
```

Argument | Description
--- | ---
`--name` | Name of the application. (required)
`--bundleIdentifier` | The iOS bundle identifier of the application. (required)
`--provisioningProfile` | The name of the iOS provisioning profile to build the application. (optional, defaults to the value of --name).
`--help` | Display help and exit.

The following example shows renaming the application to "My Spezi App":

```bash
$ sh Scripts/create.sh --name "My Spezi App" --bundleIdentifier "edu.stanford.spezi.myapp"
```

## 3. Setup the Continous Integration and Delivery Setup

Continuous integration (CI) and continuous delivery (CD) are essential to automatically test and deploy your application at any time.
Each Spezi Template Application-based Spezi app already has the necessary infrastructure in place; the Spezi Template Application includes continuous integration (CI) and continuous delivery (CD) setup:
- Automatically build and test the application on every pull request before deploying it. Suppose your organization doesn't have a self-hosted macOS runner modeled after the setup in the [StanfordBDHG ContinuousIntegration](https://github.com/StanfordBDHG/ContinousIntegration) setup. In that case, you will need to remove the `runsonlabels` arguments in the `build-and-test.yml` file to ensure that the build runs on the default macOS runners provided by GitHub.
- An automated setup to deploy the application to TestFlight every time there is a new commit on the repository's main branch. You will need to provide the provisioning profile and other GitHub secrets to make them available to the GitHub Action.
- Ensure a coherent code style by checking the conformance to the SwiftLint rules defined in `.swiftlint.yml` on every pull request and commit.
- Ensure conformance to the [REUSE Specification]() to property license the application and all related code.
- Deploy documentation of the application to GitHub pages with every commit to the main branch.

Please refer to the [Stanford Biodesign Digital Health Template Application](https://github.com/StanfordBDHG/TemplateApplication) and the [ContinuousDelivery Example by Paul Schmiedmayer](https://github.com/PSchmiedmayer/ContinousDelivery) for more background about the CI and CD setup for the Spezi Template Application.
