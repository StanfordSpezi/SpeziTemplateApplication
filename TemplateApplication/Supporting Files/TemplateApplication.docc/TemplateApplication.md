# ``TemplateApplication``

<!--
#
# This source file is part of the Stanford Spezi Template Application open-source project
#
# SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#       
-->

Template to provide a starting point for Spezi-based applications.

## Overview

The Spezi Template Application demonstrates using the [Spezi](https://github.com/StanfordSpezi/Spezi) ecosystem and builds on top of the [Stanford Biodesign Digital Health Template Application](https://github.com/StanfordBDHG/TemplateApplication).

> Tip: Do you want to try out the Spezi Template Application? You can download it to your iOS device using [TestFlight](https://testflight.apple.com/join/ipEezBY1)!

The following screenshots show a wide variety of features based on Spezi Modules that are part of the Spezi Template Application.

@Row(numberOfColumns: 3) {
    @Column(size: 1) {
        @Image(source: "Welcome", alt: "A screen displaying welcome information.") {
            Welcome View.
        }
    }
    @Column(size: 1) {
        @Image(source: "InterestingModules", alt: "A screen showing an overview of the modules used in the Spezi Template Application.") {
            Interesting Modules
        }
    }
    @Column(size: 1) {
        @Image(source: "Consent", alt: "A screen displaying the consent view.") {
            Consent Signature.
        }
    }
}
@Row(numberOfColumns: 3) {
    @Column(size: 1) {
        @Image(source: "HealthKitAccess", alt: "HealthKit Onboarding Flow") {
            HealthKit Access.
        }
    }
    @Column(size: 1) {
        @Image(source: "HealthKitSheet", alt: "Permissions screen of the HealthKit framework") {
            Granular HealthKit Share Control.
        }
    }
    @Column(size: 1) {
        @Image(source: "Schedule", alt: "A screen displaying the Scheduler UI.") {
            Schedule Tasks.
        }
    }
}
@Row(numberOfColumns: 3) {
    @Column(size: 1) {
        @Image(source: "Notifications", alt: "Onboarding screen showing the Notifications permission screen.") {
            Trigger Local Notifications.
        }
    }
    @Column(size: 1) {
        @Image(source: "Questionnaire", alt: "A screen showing a questionnaire using ResearchKit.") {
            Display Questionnaires.
        }
    }
    @Column(size: 1) {
        @Image(source: "ScheduleComplete", alt: "The scheduler screen showing the completed UI") {
            Keep Track of Tasks.
        }
    }
}
@Row(numberOfColumns: 3) {
    @Column(size: 1) {
        @Image(source: "Contacts", alt: "A screen displaying the Contact UI.") {
            Contact Information.
        }
    }
    @Column(size: 1) {
        @Image(source: "License", alt: "License information to list all used Swift Packages") {
            License Information.
        }
    }
    @Column(size: 1) {
        @Image(source: "Request", alt: "User Interface of the Mock Web Service") {
            Mock Web Service Requests.
        }
    }
}

> Tip: You can find all the used Spezi Modules in the [Stanford Spezi GitHub Organization](https://github.com/StanfordSpezi).
