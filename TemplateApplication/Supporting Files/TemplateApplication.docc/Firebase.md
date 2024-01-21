# Set up a Firebase Backend for your Spezi Application

<!--
#
# This source file is part of the Stanford Spezi Template Application open-source project
#
# SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#
-->

How to set up Google Firebase as a managed backend for you Spezi-based iOS application, including Authentication, Database, and Cloud Storage.

## Introduction

 [Google Firebase](https://firebase.google.com) is a set of managed backend cloud computing services and application development platforms provided by Google.
 It hosts databases, services, authentication, and integration for a variety of applications, including mobile applications like the Spezi Template Application.
 Stanford provides its version of a Firebase instance in the form of the [Stanford mHealth platform](https://med.stanford.edu/mhealth.html).
 We use Firebase and the mHealth platform as the default integrated cloud provider in the Spezi Template Application.

> Tip: Spezi itself is independent of any cloud provider or platform! Spezi offers different modules to connect to cloud providers, including [Spezi Firebase](https://github.com/StanfordSpezi/SpeziFirebase), which is the cloud provider demonstrated in the Spezi Template Application.

## Set up your Local Firebase Emulator Environment

The [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite) allows you to build and test your app locally before deploying to the cloud. 
