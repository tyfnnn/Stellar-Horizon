# Stellar Horizon

![Stellar Horizon App](https://github.com/user-attachments/assets/f3732faf-3d1c-4b92-998d-6f6d7137e5ed)

## Explore the Universe From Your iOS Device

Stellar Horizon transforms your iOS device into a portal to the cosmos. With stunning visuals, real-time data, and interactive features, this app brings the wonders of space exploration directly to your fingertips.

**Website:** [stellarhorizon.visual-stories.de](https://stellarhorizon.visual-stories.de)  
**See it in action:** [Watch Demo on Instagram](https://instagram.com/your_instagram_reel_link)

## ✨ Key Features

### 🔭 Astronomy Gallery
* Browse breathtaking astrophotography from **NASA**, **ESA**, and other space agencies
* Interactive social features - like and comment on your favorite cosmic images
* Save your favorite celestial views for offline viewing

### 🌐 3D Interactive Earth
* Explore a **SceneKit**-powered 3D Earth model with realistic textures and lighting
* Visualize historical climate data through selectable Earth texture options
* Smooth rotation animations with star field background for immersive experience

### 🛰️ ISS Live Tracker
* Real-time tracking of the International Space Station on a MapKit-powered map
* Monitor the ISS's current position, speed, and orbital trajectory
* Stay informed of upcoming overhead passes at your location

### 📱 Space News Hub
* Stay updated with curated articles from NASA, ESA, and other space authorities
* Bookmark important news for later reference
* Built-in WebKit integration for seamless reading experience

### 👤 User Accounts & Personalization
* Secure authentication via Firebase (email/password or Google Sign-In)
* Anonymous browsing option for quick access
* Personalized experience with saved preferences and favorites

## 🛠️ Technical Architecture

Stellar Horizon is built using modern iOS development practices:

* **UI Framework**: SwiftUI for responsive, declarative UI design
* **3D Visualization**: SceneKit for Earth model and space simulations
* **Authentication**: Firebase Authentication with multiple sign-in methods
* **Data Storage**: Firestore for user data, bookmarks, and interactions
* **Image Handling**: Asynchronous image loading and caching
* **Networking**: Efficient API clients for NASA, ESA, and n2yo.com services
* **Animations**: Custom and Lottie-powered animations for engaging UI

## 📱 Screenshots

![Screenshot12](https://github.com/user-attachments/assets/fc246217-34f9-4502-81b0-aaa5f6204f10)
![Screenshot11](https://github.com/user-attachments/assets/4ee110b8-4390-462c-9979-6c59f3f65a32)
![Screenshot10](https://github.com/user-attachments/assets/2a4791f8-fa08-4c10-870a-1fa1b468b40f)
![Screenshot9](https://github.com/user-attachments/assets/6b311836-3d77-4eb9-b798-200302d980a4)
![Screenshot8](https://github.com/user-attachments/assets/a1a9af6c-a1cd-4d56-8c33-adfe0a43246c)
![Screenshot7](https://github.com/user-attachments/assets/2d7d2a0b-f324-4ac4-be3b-9ae440e0bec4)
![Screenshot6](https://github.com/user-attachments/assets/ec562b6f-af29-4cf7-97ff-fb46f19ba733)
![Screenshot5](https://github.com/user-attachments/assets/fced0803-d332-4ba2-abbc-90188404f55e)
![Screenshot4](https://github.com/user-attachments/assets/067af48c-c79e-487b-90e0-77a0d83c8cda)
![Screenshot3](https://github.com/user-attachments/assets/165cdc2f-4568-42af-a551-016ea95873ab)
![Screenshot2](https://github.com/user-attachments/assets/b05b5c49-f6ea-4200-a2c4-74a6ca01b549)
![Screenshot1](https://github.com/user-attachments/assets/772fddbf-edc9-4524-8fde-568db06d31e6)

(Screenshots would be inserted here)

## ⚙️ Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/stellar-horizon.git
   cd stellar-horizon
   ```

2. **Install dependencies**
   ```bash
   # If using CocoaPods
   pod install
   
   # If using Swift Package Manager
   # Dependencies are automatically resolved when opening in Xcode
   ```

3. **Configure API keys**
   * Create a `Config.swift` file with your API keys:
   ```swift
   struct Config {
       static let nasaApiKey = "YOUR_NASA_API_KEY"
       static let n2yoApiKey = "YOUR_N2YO_API_KEY"
   }
   ```

4. **Firebase setup**
   * Create a project in the [Firebase Console](https://console.firebase.google.com/)
   * Enable Authentication and Firestore
   * Download and add the `GoogleService-Info.plist` to your project

5. **Open in Xcode**
   * Launch `Stellar Horizon.xcworkspace` or `Stellar Horizon.xcodeproj`
   * Select your development team
   * Build and run!

## 🧩 Dependencies

* **Firebase** - Authentication, Firestore, Storage
* **FeedKit** - RSS feed parsing for space news
* **Lottie** - High-quality animations
* **Google Sign-In** - Alternative authentication method

## 📄 License & Attribution

Stellar Horizon is available under the MIT License. When using this application, please provide appropriate attribution:

* NASA data and imagery: "Source: NASA"
* ESA data and imagery: "Source: ESA"
* Berkeley Earth temperature data: "Source: Berkeley Earth Land/Ocean Temperature Record"
* Satellite information: "Satellite information provided by n2yo.com"

## 👥 Contributors & Acknowledgments

Special thanks to:
* NASA and ESA for their open data initiatives
* The space science community for inspiration
* Open source contributors who make projects like this possible

## 📞 Contact & Support

For questions, feedback, or support, please:
* Create an issue in the GitHub repository
* Contact the development team at [contact@example.com]

---

**Stellar Horizon** - Because the universe belongs in your pocket.
