# Continous Integration and Delivery Setup

Overview of the continous integration (CI) and continous delivery (CD) setup within a Spezi Template Application-based Spezi app. 

## Overview

The Spezi Template application includes continuous integration (CI) and continuous delivery (CD) setup.
- Automatically build and test the application on every pull request before deploying it. If your organization doesn't have a self-hosted macOS runner modeled after the setup in the [StanfordBDHG ContinuousIntegration](https://github.com/StanfordBDHG/ContinousIntegration) setup, you will need to remove the `runsonlabels` arguments in the `build-and-test.yml` file to ensure that the build runs on the default macOS runners provided by GitHub.
- An automated setup to deploy the application to TestFlight every time there is a new commit on the repository's main branch.
- Ensure a coherent code style by checking the conformance to the SwiftLint rules defined in `.swiftlint.yml` on every pull request and commit.
- Ensure conformance to the [REUSE Specification]() to property license the application and all related code.

Please refer to the [Stanford Biodesign Digital Health Template Application](https://github.com/StanfordBDHG/TemplateApplication) and the [ContinuousDelivery Example by Paul Schmiedmayer](https://github.com/PSchmiedmayer/ContinousDelivery) for more background about the CI and CD setup for the Spezi Template Application.
