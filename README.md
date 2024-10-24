##Real-Time Chat Application
A feature-rich real-time chat application built using Flutter, Dart, and Firebase, with integrated voice and video calling powered by ZEGOCLOUD.

##Features
Real-Time Messaging: Instant messaging with Firebase Cloud Firestore.
Voice and Video Calls: Powered by ZEGOCLOUD for high-quality voice and video calls.
User Authentication: Secure user sign-up and login using Firebase Authentication.
Last Seen & Online Status: Real-time status updates for users' activity.
Media Sharing: Share images and files with friends using the image picker.
Animated UI: Enhanced user experience with Lottie animations.
Persistent Storage: Uses SharedPreferences for storing small data like user preferences.

##Technologies Used
Flutter: For building the cross-platform mobile app.
Dart: The programming language used for Flutter development.
Firebase: Backend services including Authentication, Firestore, and Storage.
ZEGOCLOUD: For implementing voice and video calling features.
Packages:
firebase_core
cloud_firestore
firebase_storage
firebase_auth
image_picker
get
shared_preferences
dash_chat_2
zego_uikit_prebuilt_call
lottie


##Install dependencies:


Copy code
flutter pub get
Configure Firebase:

Set up Firebase for Android/iOS.
Add your google-services.json for Android and GoogleService-Info.plist for iOS.
Run the application:

bash
Copy code
flutter run
