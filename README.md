Here is the README file for your developer, based on the design files provided.

Project: Multi-Timer App ("Time Blocks")

1. App Overview

This document outlines the development plan for "Time Blocks," a comprehensive timing application for mobile. The app provides users with a central dashboard to manage multiple types of timers, stopwatches, and countdowns.

All development must strictly adhere to the provided design files.

2. Core Features (Based on Designs)

The application is comprised of five main areas:

Dashboard (dashboard/): The main "Time Blocks" screen. It displays all "Active" and "Recent" timers, stopwatches, and countdowns in separate card-based lists. Users can quickly manage active items (e.g., Pause, Resume, Reset) or restart recent items.
Stopwatch (new_stopwatch_setup/): A full-featured stopwatch screen.
Displays main time and current lap time.
Controls for "Lap" and "Pause".
Lists all previous laps.
Displays a list of "Saved Sessions" for review.
New Multi-Timer (new_timer_setup/): A setup screen for creating sequential timer presets.
Users can name a preset (e.g., "Morning Workout").
Users can add multiple timers, each with its own label (e.g., "Plank," "Rest"), duration, and alert sound.
Timers can be reordered (via drag handle) and deleted.
Presets are saved via a "Save Preset" button.
New Countdown (new_countdown_setup/): A setup screen for creating countdowns.
Users can name the countdown.
Users can set the target by either a specific "Date & Time" (using a calendar and time wheel) or a "Duration".
Provides collapsible options for "Repeat" frequency and "Alerts" (e.g., time before, sound).
Settings (settings/): An application settings screen.
Appearance: Set the app theme (e.g., System Default).
Notifications: Toggle vibration and set notification sounds.
General: Toggle "Keep Screen On" and manage "Run in Background" permissions.
About: Displays app version, a link to rate the app, and a privacy policy.
3. Technology Requirements

Platform: Flutter. The application must be built using the Flutter framework to ensure a single codebase for both iOS and Android, matching the provided designs.
4. Development Plan

This plan is phased to build the application's features modularly, based on the provided screens.

Phase 1: Settings & Core Models

Data Models: Define the core data models for the app:
MultiTimerPreset (with a list of TimerStep objects).
StopwatchSession (with a list of Lap objects).
Countdown.
AppSettings.
Settings Screen:
Implement the UI for the "Settings" screen (settings/code.html).
Implement the functionality for all items:
Theme selection (Appearance).
Vibration toggle (Notifications).
Keep Screen On toggle (General).
Navigation stubs for Sound, Background, Rate App, and Privacy Policy.
Phase 2: Stopwatch Feature

Stopwatch Screen:
Implement the UI for the main "Stopwatch" screen (new_stopwatch_setup/code.html).
Core Logic:
Implement the stopwatch logic: Start, Pause, Lap, and Reset.
Connect the logic to the "Lap" and "Pause" buttons.
UI State:
Display the running time and current lap time.
Dynamically populate the "Laps" list.
Implement the "Saved Sessions" list. (Functionality for saving a session and viewing its details can be stubbed for Phase 5).
Phase 3: Multi-Timer Feature

Setup Screen:
Implement the "New Multi-Timer" setup screen (new_timer_setup/code.html).
UI & State Management:
Implement the state management for adding, deleting, and reordering timers in the list.
Implement the inputs for preset name, timer labels, and durations (HH:MM:SS pickers).
Implement the navigation for selecting a timer sound.
Save Logic:
Implement the "Save Preset" button logic to create and store a MultiTimerPreset object.
Phase 4: Countdown Feature

Setup Screen:
Implement the "New Countdown" setup screen (new_countdown_setup/code.html).
Controls:
Implement the "Date & Time" / "Duration" segmented control to toggle the UI below it.
Implement the calendar picker.
Implement the wheel-style time picker.
Implement the "Duration" input (this will require a design, but for now, use a simple HH:MM:SS input similar to the Multi-Timer).
Options:
Implement the collapsible "Repeat" and "Alerts" sections with their respective controls.
Save Logic:
Implement the "Create Countdown" button logic to create and store a Countdown object.
Phase 5: Dashboard Integration & Core Services

Dashboard Screen:
Implement the main "Time Blocks" dashboard UI (dashboard/code.html).
Core Timer Service:
Develop the background service(s) required to run timers, stopwatches, and countdowns while the app is in the background. This is critical and connects to the "Run in Background" setting.
Dashboard Logic:
Populate the "Active" and "Recent" lists by querying the app's running services and saved data.
Implement the controls on the dashboard cards (Pause, Resume, Reset, Delete, Start Again).
Navigation:
Connect the Dashboard's top-right "Settings" icon to the Settings screen (Phase 1).
Connect the Dashboard's "+" FAB to a menu or navigation flow to access the "New Multi-Timer," "New Countdown," and "Stopwatch" screens (Phases 2, 3, 4).
Ensure all back buttons and navigation flows match the designs.
