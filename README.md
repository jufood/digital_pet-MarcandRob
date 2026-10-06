# Digital Pet - In-Class Activity 07

## Team Members

- Rob Han - Team 2: Pet Personality
- Marc - Team 1: Care Systems

## Project Overview

This Flutter application simulates a digital pet whose state changes based on user actions and time.

The app includes:
- Editable pet name
- Happiness and hunger meters
- Mood feedback
- Feed, Play, Reset, Pause, and Resume controls
- Automatic hunger increase every 30 seconds
- Win and game-over conditions
- Animated pet feedback and meters
- Reduced-motion support

## Team Responsibilities

### Team 1 - Care Systems

Marc implemented:
- Feed behavior
- Play behavior
- Reset behavior
- Happiness and hunger state updates
- Meter clamping from 0 to 100
- 30-second hunger timer
- Win condition
- Loss condition
- Timer lifecycle management
- Pause and Resume session controls

### Team 2 - Pet Personality

Rob implemented:
- Pet image asset
- Editable pet-name interface
- Mood label
- Mood color changes
- Pet speech
- Animated pet scaling
- Animated happiness and hunger meters
- Reduced-motion support
- Pet personality user interface

## Core State Rules

### Mood

- Happiness below 30: Unhappy / Red
- Happiness from 30 to 70: Neutral / Yellow
- Happiness above 70: Happy / Green

### Hunger Timer

Hunger increases by 5 every 30 seconds.

If hunger is already 100 and another timer tick occurs:
- Hunger remains at 100
- Happiness decreases by 20

### Win Condition

The player wins when happiness remains above 80 continuously for 3 minutes.

If happiness falls to 80 or below, the win timer is canceled.

### Loss Condition

Game over occurs when:

- Hunger = 100
- Happiness <= 10

After a win or game over, care actions are disabled until Reset is pressed.

## Advanced Features

### 1. Session Controls

The app includes Pause and Resume controls.

When paused:
- Care actions are disabled
- Hunger timer stops
- Win timer stops

When resumed:
- Game timers restart safely

### 2. Visual Polish and Accessible Motion

The app uses Flutter animation widgets including:

- `AnimatedScale`
- `AnimatedSwitcher`
- `TweenAnimationBuilder`

The pet changes color and size based on its happiness level.

The app also checks:

```dart
MediaQuery.of(context).disableAnimations
