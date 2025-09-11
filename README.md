# Budget Buddy 💰📊

### A modern expense tracker app to manage your personal finances with both offline and online support.

Budget Buddy helps you take control of your spending habits by combining powerful state management, offline persistence, and cloud synchronization in one seamless experience.

## ✨ Features

📂 Expense & Income Tracking – Add, edit, and delete transactions with categories and notes.

📅 History & Insights – View detailed logs and summaries of your expenses and incomes over time.

📊 Analytics Dashboard – Visualize your spending patterns with charts and statistics.

🔐 Authentication – Secure login and signup using Firebase Authentication.

📡 Hybrid Storage

Offline Mode: Store data locally using SQLite and Hive.

Online Mode: Sync with Firebase Firestore when connected to the internet.

🔄 Auto-Sync – Changes made offline are automatically pushed to the cloud when online.

🎯 State Management with Provider – Efficient and reactive app-wide state handling.

🌙 Dark & Light Theme – Switch themes to match your preference.

## 🛠️ Tech Stack

Flutter – Cross-platform app development

Provider – State management

SQLite + Hive – Local persistence

Firebase (Auth + Firestore) – Remote database & authentication

## 🚀 Getting Started

Clone the repo and run the app:
git clone https://github.com/yourusername/budget-buddy.git
cd budget-buddy
flutter pub get
flutter run
