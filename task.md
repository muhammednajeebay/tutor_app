# Flutter Task

## Tech Stack
- Flutter
- GetX
- REST APIs

## Design Reference
Figma: https://www.figma.com/design/w93pjje5ZIdHUsYq60u4Q0/Flutter-Machine-Test-FMT1?nodeid=0-1&t=98dfSFLfhVVfUZD8-1

## Objective
Develop a Learning App by converting the given Figma design into Flutter UI while demonstrating:
- GetX state management & navigation
- REST API integration
- Dynamic and reactive UI

## Updated Screen Requirements

### 1. Onboarding Flow

#### Onboarding Page 1
**UI as per Figma:**
- Image
- Title: Smarter Learning Starts Here
- Description text
- Next button
- Skip button

**Behavior:**
- Next → Onboarding Page 2
- Skip → Home Page

#### Onboarding Page 2
**UI as per Figma:**
- Image
- Title: Learn. Practice. Succeed.
- Description
- Next button
- Skip button

**Behavior:**
- Next → Home Page
- Skip → Home Page

**Technical Expectation:**
- Use GetX navigation
- Optional: store onboarding completion flag (GetStorage / in-memory)

### 2. Home Page
- Greeting section
- Active course card
- Category chips
- Popular courses (horizontal)
- Live class card
- Community section
- Testimonials
- Contact
- Bottom navigation bar

**Data:**
- Loaded dynamically from REST API or mock JSON
- State handled using GetX

### 3. Subjects / Videos Page
- Video
- Video title & description
- Video list:
  - Completed video → check icon
  - Locked video → disabled state
- List must be dynamic from API response

### 4. Streak Page
- Learning streak path UI
- Dynamic rendering using API or mock data
- From the home page, navigate to the Streak page using the "Day 7 🔥" button.

## Mandatory Technical Requirements
- Flutter (stable)
- GetX:
  - Controllers
  - Navigation
- REST API
- Loader, error, and empty states

## Time Limit
⏱ 4 hours

## APIs
**Base URL:** https://trogon.info/task/api/

- Home page: `home.php`
- Subjects: `video_details.php`
- Streak: `streak.php`

## Submission
- GitHub repository
- Screenshots