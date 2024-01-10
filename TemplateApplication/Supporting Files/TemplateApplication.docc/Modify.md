# Start Development of Your Spezi-based Application

Overview of the different parts of the a Spezi Template Application-based Spezi app and how to modify them your needs.

> Important: Please first follow the instructions on how to install all the nescessary software to build, run, and modify the application (<doc:Setup>) and how to create your own Spezi-based application based on the template application (<doc:Create>).


## Template Onboarding Flow

The onboarding contains different steps.
It uses the [**Spezi Onboarding** module](https://github.com/StanfordSpezi/SpeziOnboarding) to display different onboarding-related views like the information about the application, a consent screen, and a screen to display a HealthKit consent view.

<p float="left">
 <img width="250" alt="A screen displaying welcome information." src="Figures/TemplateOnboardingFlow/Welcome.png">
 <img width="250" alt="A screen showing an overview of the modules used in the Spezi Template application." src="Figures/TemplateOnboardingFlow/InterestingModules.png">
 <img width="250" alt="A screen displaying the consent view." src="Figures/TemplateOnboardingFlow/Consent.png">
 <img width="250" alt="A screen showing a view displaying the HealthKit access screen." src="Figures/TemplateOnboardingFlow/HealthKitAccess.png">
</p>


## Template Schedule

The scheduler part of the application provides the functionality to schedule a recurring task and bind it to an action, e.g., displaying a questionnaire.
It uses the [**Spezi Scheduler**](https://github.com/StanfordSpezi/SpeziScheduler) and [**Spezi Questionnaire**](https://github.com/StanfordSpezi/SpeziQuestionnaire) modules to schedule the tasks as defined in the `TemplateApplicationScheduler`.

<p float="left">
 <img width="250" alt="A screen displaying the Scheduler UI." src="Figures/TemplateSchedule/Scheduler.png">
 <img width="250" alt="A screen showing a questionnaire using ResearchKit." src="Figures/TemplateSchedule/Questionnaire.png">
 <img width="250" alt="A screen displaying the Scheduler UI when the questionnaire is finished." src="Figures/TemplateSchedule/QuestionnaireFinished.png">
</p>


## Template Contacts

The Contacts part of the application provides the functionality to display contact information in your application.
It uses the [**Spezi Contacts** module](https://github.com/StanfordSpezi/SpeziContact) to use the contact-related views provided by Spezi.

<p float="left">
 <img width="250" alt="A screen displaying the Contact UI." src="Figures/TemplateContacts/Contacts.png">
</p>
