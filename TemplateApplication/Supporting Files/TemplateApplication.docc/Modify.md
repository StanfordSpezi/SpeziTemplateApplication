# Start Development of Your Spezi-based Application

Overview of the different parts of the a Spezi Template Application-based Spezi app and how to modify them your needs.

> Important: Please first follow the instructions on how to install all the nescessary software to build, run, and modify the application (<doc:Setup>) and how to create your own Spezi-based application based on the template application (<doc:Create>).


## Onboarding Flow

The onboarding contains different steps.
It uses the [**Spezi Onboarding** module](https://github.com/StanfordSpezi/SpeziOnboarding) to display different onboarding-related views like the information about the application, a consent screen, and a screen to display a HealthKit consent view.

@Row {
    @Column {
        @Image(source: "Welcome", alt: "A screen displaying welcome information.") {
            You can find and modify the welcome messages in the ``Welcome`` view.
        }
    }
    @Column {
        @Image(source: "InterestingModules", alt: "A screen showing an overview of the modules used in the Spezi Template application.") {
            You can find and modify the sequencial onboarding information in the ``InterestingModules`` view.
        }
    }
    @Column {
        @Image(source: "Consent", alt: "A screen displaying the consent view.") {
            You can find and modify the conset setup and surrounding user interface in the ``Consent`` view.
        }
    }
    @Column {
        @Image(source: "HealthKitAccess", alt: "A screen showing a view displaying the HealthKit access screen.") {
            You can find and modify the HealthKit access wording in the ``HealthKitPermissions`` view.
        }
    }
}


## Schedule & Questionnaires

The scheduler part of the application provides the functionality to schedule a recurring task and bind it to an action, e.g., displaying a questionnaire.
It uses the [**Spezi Scheduler**](https://github.com/StanfordSpezi/SpeziScheduler) and [**Spezi Questionnaire**](https://github.com/StanfordSpezi/SpeziQuestionnaire) modules to schedule the tasks as defined in the `TemplateApplicationScheduler`.

@Row {
    @Column {
        @Image(source: "Scheduler", alt: "A screen displaying the Scheduler UI.") {
            You can find and modify the scheduled tasks by changing the configuration and setup in the ``TemplateApplicationScheduler``
        }
    }
    @Column {
        @Image(source: "Questionnaire", alt: "A screen showing a questionnaire using ResearchKit.") {
            The elements that are displayed as part of a schedule are defined in the ``TemplateApplicationTaskContext`` and displayed using the ``EventContextView`` and logic in the ``ScheduleView``.
        }
    }
    @Column {
        @Image(source: "QuestionnaireFinished", alt: "A screen displaying the Scheduler UI when the questionnaire is finished.") {
            The questionnaire content is defined using the FHIR questinnaire information found in the `Resources` folder and defined by the ``TemplateApplicationScheduler``.
        }
    }
}


## Contacts

The Contacts part of the application provides the functionality to display contact information in your application.
It uses the [**Spezi Contacts** module](https://github.com/StanfordSpezi/SpeziContact) to use the contact-related views provided by Spezi.

@Row {
    @Column {
        @Image(source: "Contacts", alt: "A screen displaying the Contact UI.") {
            You can find and modify the contact information in the ``Contacts`` view.
        }
    }
}
