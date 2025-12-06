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

The following screenshots show a wide variety of features based on Spezi Modules that are part of the Spezi Template Application. Click on the links below the screenshots to learn more about the specific Spezi module.

@Row(numberOfColumns: 3) {
    @Column(size: 1) {
        @Image(source: "Welcome", alt: "A screen displaying welcome information.") {
            ``Welcome``
        }
    }
    @Column(size: 1) {
        @Image(source: "InterestingModules", alt: "A screen showing an overview of the modules used in the Spezi Template Application.") {
            ``InterestingModules``
        }
    }
    @Column(size: 1) {
        @Image(source: "Consent", alt: "A screen displaying the consent view.") {
            ``Consent``
        }
    }
}
@Row(numberOfColumns: 3) {
    @Column(size: 1) {
        @Image(source: "HealthKitAccess", alt: "HealthKit Onboarding Flow") {
            ``HealthKitPermissions``
        }
    }
    @Column(size: 1) {
        @Image(source: "HealthKitSheet", alt: "Permissions screen of the HealthKit framework") {
            ``HealthKitPermissions``
        }
    }
    @Column(size: 1) {
        @Image(source: "Schedule", alt: "A screen displaying the Scheduler UI.") {
            ``ScheduleView``
        }
    }
}
@Row(numberOfColumns: 3) {
    @Column(size: 1) {
        @Image(source: "Notifications", alt: "Onboarding screen showing the Notifications permission screen.") {
            ``NotificationPermissions``
        }
    }
    @Column(size: 1) {
        @Image(source: "Questionnaire", alt: "A screen showing a questionnaire using ResearchKit.") {
            ``ScheduleView``
        }
    }
    @Column(size: 1) {
        @Image(source: "ScheduleComplete", alt: "The scheduler screen showing the completed UI") {
            ``ScheduleView``
        }
    }
}
@Row(numberOfColumns: 3) {
    @Column(size: 1) {
        @Image(source: "Contacts", alt: "A screen displaying the Contact UI.") {
            ``Contacts``
        }
    }
    @Column(size: 1) {
        @Image(source: "License", alt: "License information to list all used Swift Packages") {
            ``AccountSheet``
        }
    }
    @Column(size: 1) {
        @Image(source: "Account", alt: "A screen displaying the current user account information.") {
            ``AccountSheet``
        }
    }
}

> Tip: You can find all the used Spezi Modules in the [Stanford Spezi GitHub Organization](https://github.com/StanfordSpezi).
