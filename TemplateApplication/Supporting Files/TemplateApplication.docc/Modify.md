# Start Development of Your Spezi-based Application

<!--
#
# This source file is part of the Stanford Spezi Template Application open-source project
#
# SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#    
-->

Overview of the different parts of the Spezi Template Application-based Spezi app and how to modify them to your needs.

> Important: Please first follow the instructions on how to install all the necessary software to build, run, and modify the application (<doc:Setup>) and how to create your own Spezi-based application based on the Spezi Template Application (<doc:Create>).


## Onboarding Flow

The onboarding contains different steps.
It uses the [**Spezi Onboarding** module](https://github.com/StanfordSpezi/SpeziOnboarding) to display different onboarding-related views like the information about the application, a consent screen, and a screen to display a HealthKit consent view.

@Row(numberOfColumns: 4) {
    @Column(size: 1) {
        @Image(source: "Welcome", alt: "A screen displaying welcome information.") {
            You can find and modify the welcome messages in the ``Welcome`` view.
        }
    }
    @Column(size: 1) {
        @Image(source: "InterestingModules", alt: "A screen showing an overview of the modules used in the Spezi Template Application.") {
            You can find and modify the sequential onboarding information in the ``InterestingModules`` view.
        }
    }
    @Column(size: 1) {
        @Image(source: "Consent", alt: "A screen displaying the consent view.") {
            You can find and modify the consent setup and surrounding user interface in the ``Consent`` view.
        }
    }
}

The application also automatically pulls and processes HealthKit data types that are defined in the ``TemplateApplicationDelegate`` using the [**Spezi HealthKit** module](https://github.com/StanfordSpezi/SpeziHealthKit).

@Row(numberOfColumns: 4) {
    @Column(size: 1) {
        @Image(source: "HealthKitAccess", alt: "HealthKit Onboarding Flow") {
            You can find and modify the HealthKit onboarding flow in the ``HealthKitPermissions`` view.
        }
    }
    @Column(size: 1) {
        @Image(source: "HealthKitSheet", alt: "Permissions screen of the HealthKit framework") {
            You can define which elements should be pulled from HealthKit in the ``TemplateApplicationDelegate``.
        }
    }
}

## Schedule & Questionnaires

The scheduler part of the application provides the functionality to schedule a recurring task and bind it to an action, e.g., displaying a questionnaire.
It uses the [**Spezi Scheduler**](https://github.com/StanfordSpezi/SpeziScheduler) and [**Spezi Questionnaire**](https://github.com/StanfordSpezi/SpeziQuestionnaire) modules to schedule the tasks as defined in the `TemplateApplicationScheduler`.

@Row(numberOfColumns: 4) {
    @Column(size: 1) {
        @Image(source: "Schedule", alt: "A screen displaying the Scheduler UI.") {
            The elements that are displayed as part of a schedule are defined in the ``TemplateApplicationTaskContext`` and displayed using the ``EventContextView`` and logic in the ``ScheduleView``.
        }
    }
    @Column(size: 1) {
        @Image(source: "Notifications", alt: "Onboarding screen showing the Notifications permission screen.") {
            You can find and modify the scheduled tasks, including local notifications, by changing the configuration and setup in the ``TemplateApplicationScheduler``.
        }
    }
    @Column(size: 1) {
        @Image(source: "Questionnaire", alt: "A screen showing a questionnaire using ResearchKit.") {
            The questionnaire content is defined using the FHIR questionnaire information found in the `Resources` folder and defined by the ``TemplateApplicationScheduler``.
        }
    }
    @Column(size: 1) {
        @Image(source: "ScheduleComplete", alt: "The scheduler screen showing the completed UI") {
            The [**Spezi Scheduler**](https://github.com/StanfordSpezi/SpeziScheduler) module keeps track of the completion state and due dates of tasks and events.
        }
    }
}


## Additional Application

The [**Spezi Contacts** module](https://github.com/StanfordSpezi/SpeziContact) uses the contact-related views provided by Spezi.

@Row(numberOfColumns: 4) {
    @Column(size: 1) {
        @Image(source: "Contacts", alt: "A screen displaying the Contact UI.") {
            You can find and modify the contact information in the ``Contacts`` view.
        }
    }
    @Column(size: 1) {
        @Image(source: "License", alt: "License information to list all used Swift Packages") {
            You can investigate the ``ContributionsList`` to learn how the application loads and displays the license information.
        }
    }
    @Column(size: 1) {
        @Image(source: "Request", alt: "User Interface of the Mock Web Service") {
            If Firebase is disabled, the Mock Web Service allows you to see the requests that would be sent to a web service.
        }
    }
}
