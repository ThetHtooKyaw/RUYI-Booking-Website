# RUYI Booking Website

A real-world restaurant's table booking web app built for Ruyi Restaurant using Flutter Web and Firebase. It supports both user and admin interfaces and is responsive for desktop and mobile.

## Features

- User can:
  - Browse menu
  - Book tables (with pre-order menu)
  - Receive booking confirmation emails
- Admin can:
  - Manage bookings, disable dates
  - Approve/reject bookings
  - View orders and
  - add new admin or change admin data
- Responsive design with `ResponsiveBuilder`
- Email notifications via **MailerSend API**
- Hosted on **Netlify**

## Tech Stack

- **Flutter Web**
- **Firebase Firestore** (Database)
- **Firebase Auth** (Admin Login)
- **Provider** (for menu, booking, admin logic)
- **MailerSend API** (email confirmation)
- **ResponsiveBuilder** (responsive UI)

## Live Demo

🔗 [Visit the Website](https://ruyi-restaurant.xyz/)

## Getting Started

1. Clone the repo: git clone https://github.com/yourusername/ruyi-booking.git
2. Navigate to the project: cd todo-app
3. Run the app: flutter pub get & flutter run
