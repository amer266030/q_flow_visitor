# QFlow (Visitor)

QFlow (Visitor) is a Flutter-based application developed to streamline the visitor experience at job fairs hosted by Tuwaiq Academy. It addresses challenges such as long queue wait times, access to company information, and the need to carry multiple CV copies. This fully functional app allows visitors to browse company details, join queues, receive real-time notifications, and rate or save companies for later, providing a more efficient and seamless event experience.

![App Clip](q_flow_visitor.gif)

## Table of Contents

- [App Overview](#app-overview)
- [Tools/Technologies](#toolstechnologies)
- [Features](#features)
- [Data Models](#data-models)
- [Design Philosophy](#design-philosophy)
- [Getting Started](#getting-started)
- [Future Enhancements](#future-enhancements)
- [Created By](#created-by)

## App Overview

### Tools/Technologies

1. **Dart/Flutter**
   - Programing Language and framework used to build the QFlow apps for both iOS and Android from a single codebase.

2. **Supabase**
   - Provide efficient backend management, handling database functions and user authentication.

3. **One Signal**
   - A push notification service that sends real-time notifications  about queue status and upcoming interviews.

4. **Figma**
   - A collaborative design platform for creating high-quality wireframes and prototypes.

5. **Github**
   - Enables efficient collaboration, allowing our team to manage code.

6. **Excel**
   - Manage/control invitations and attendance of Companies and Visitors.

### Features

1. **Onboarding**
   - Welcomes users and introduces the app's main features.

2. **Authentication**
   - Only emails invited by the event organizer can sign in.
   - Uses email OTP verification for secure access without a password.

3. **Main Screen Navigation**
   - Four primary tabs: Home, Bookmarks, Booked Interview Tickets, and Profile.

4. **Home**
   - Displays a QR code for attendance verification.
   - Shows upcoming interviews with queue position.
   - Recommends companies based on visitor skills and company openings.
   - Lists all companies in the job fair with search and filter options.
   
5. **Bookmarks**
   - Allows visitors to save a list of companies they plan to apply for later.

6. **Booked Interview Tickets**
   - Displays interviews in three categories: Upcoming, Completed, and Cancelled.
   - Enables visitors to rate completed interviews, helping organizers enhance future events.

7. **Profile**
   - Allows profile updates, including avatar, name, gender, experience, CV upload, and social links.
   - Provides options to view the privacy policy, enable/disable notifications, switch app language (Arabic/English), toggle light/dark themes, and log out.

### Data Models

The app includes more than 11 data models that connect with database tables. The main ones are for:

- **Visitor Profile:** Stores visitor details, CV, and social links.
- **Company:** Contains company information, job openings, and queue details.
- **Interview:** Manages booked interviews, including status and ratings.
- **Bookmark:** Tracks bookmarked companies for future reference.

### Design Philosophy

- **User-Centered Design:** QFlow focuses on enhancing visitor experience by reducing queue wait times and simplifying information access.
- **Seamless Navigation:** Intuitive design and organized tabs ensure easy access to important features.
- **Real-Time Functionality:**  Integrates live queue updates and notifications for efficient event participation.

### Functionality

QFlow is fully functional and allows visitors to manage interviews, access company details, and streamline their event experience. Key functionalities include:
- **Interview Limit:** To manage large crowds effectively, each visitor can book a maximum of two interviews at any given time.
- **Single Booking Rule:** Visitors cannot book an interview with the same company twice if an interview status is "upcoming" or "completed."
- **Real-Time Updates:** Visitors receive live notifications on queue positions and upcoming interview schedules.
- **Profile Customization:** Allows users to update their personal information, upload CVs, and manage settings.

## Getting Started

### Prerequisites

- Flutter SDK
- A code editor (such as VS Code or Android Studio)

### Installation

1. Clone the repository:

```
   git clone https://github.com/amer266030/q_flow_visitor
```

3. Get the dependencies:

    
```
   flutter pub get
```

4. Run the app:
    
```
   flutter run
```

### Future Enhancements

* Interview Preparation Resources: Offer additional resources for interview preparation and follow-up.

## Created By

**Amer Alyusuf**
- [Portfolio](https://amer266030.github.io)
- [Resume](https://amer266030.github.io/assets/pdf/Amer_CV.pdf)
- [LinkedIn](https://www.linkedin.com/in/amer-alyusuf)

**Yara Albouq**
- [Portfolio](https://bind.link/@yaraalbouq)
- [Resume](https://drive.google.com/file/d/1H0d1yBl9JCLyyc3Uwz3582EW3uy3U3HE/view?usp=drivesdk)
- [LinkedIn](https://www.linkedin.com/in/yaraalbouq)

**Abdullah Alshammari**
- [Portfolio](https://bind.link/@abdullah-al-shammari)
- [Resume](https://www.dropbox.com/scl/fi/usjo2vcuarjhqaulu226e/Abdullah_Alshammari_CV.pdf?rlkey=k297kmstimne5g017fdm9bdkd&st=jwe6dwpc&dl=0)
- [LinkedIn](https://www.linkedin.com/in/abumukhlef)