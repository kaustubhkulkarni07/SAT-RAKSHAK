# 🛰️ SAT-RAKSHAK: Space-Tech for Soil Survival

![Project Banner](https://img.shields.io/badge/Status-Operational-brightgreen) ![Tech](https://img.shields.io/badge/Tech-Sentinel--1%20Radar-blue) ![Stack](https://img.shields.io/badge/Stack-Flutter%20%7C%20Python%20%7C%20GEE-orange)

> **"Clouds block the view, but not the truth."**
> A disaster management system that uses **Synthetic Aperture Radar (SAR)** to see through clouds and verify flood damage for Indian farmers.

---

## 📜 The Problem
During heavy monsoons, agricultural lands in India face severe flooding. However, assessing this damage is difficult because:
1.  **Cloud Cover:** Optical satellites (like Google Maps/Landsat) cannot see the ground during rains.
2.  **Manual Delays:** Government surveys take weeks to reach remote farms.
3.  **Lack of Proof:** Farmers struggle to provide digital evidence for insurance claims.

## 💡 The Solution: Sat-Rakshak
**Sat-Rakshak** (Satellite Protector) is an end-to-end mobile application that integrates **Space Technology** with **Governance**.
* **Radar Vision:** Uses **Sentinel-1 Satellite data** (C-Band SAR) which penetrates clouds, rain, and smoke.
* **7/12 Integration:** Farmers simply enter their **Gat Number**, and the system resolves the geospatial coordinates.
* **Instant Verification:** Generates an official **AI-Verified PDF Report** determining flood status using backscatter thresholding.

---

## 🏗️ System Architecture

The project follows a **Microservices Architecture** bridging a mobile frontend with a cloud-based geospatial engine.

mermaid
graph LR
    A[Mobile App (Flutter)] -- Gat No. Request --> B[Ngrok Secure Tunnel]
    B -- Forward Request --> C[FastAPI Server (Python)]
    C -- Geo-Processing --> D[Google Earth Engine]
    D -- Sentinel-1 Data --> C
    C -- PDF Generation --> A

1. Liquid Onboarding
   <img width="540" height="1200" alt="image" src="https://github.com/user-attachments/assets/9acef504-3d69-438f-9bdc-9157a8ccd310" />
   <img width="540" height="1200" alt="image" src="https://github.com/user-attachments/assets/0350db8e-a4d9-4679-8abb-7467d4ed0e3a" />
   <img width="540" height="1200" alt="image" src="https://github.com/user-attachments/assets/53f41b06-0100-45da-8e76-7fa84184dfac" />

3. Gat Number Input
  <img width="540" height="1200" alt="image" src="https://github.com/user-attachments/assets/6c718092-7cde-4655-98e9-30bf4f8f0f8a" />

3. Flood Report
  <img width="540" height="1200" alt="image" src="https://github.com/user-attachments/assets/3d404142-b7ae-4f9d-9f0e-67eee5917634" />

Smooth ripple animation introduction,User enters Village & Gat No.,Official PDF with geospatial evidence

## 🧠 The Algorithm (How it works)
We utilize the Backscatter Intensity Principle of Radar waves:

Signal Transmission: Sentinel-1 sends radio waves to the earth.

Reflection Analysis:

Dry Land: Rough surface → High scatter → Bright Pixels

Flooded Water: Smooth surface → Specular reflection (waves bounce away) → Dark Pixels

Thresholding:

We apply a threshold (approx -16dB).

Pixels below this value are classified as Flood Water.

Speckle Filtering: A Focal Mean filter is applied to remove radar noise (graininess) for clearer mapping.

🚀 Installation & Setup
1. Backend (Python/Colab)
You need a running Python server to process satellite data.

Open the Sat_Rakshak_Backend.ipynb in Google Colab.

Add your Ngrok Auth Token.

Run the cells to start the FastAPI Server.

Copy the public URL (e.g., https://xyz.ngrok-free.app).

2. Frontend (Flutter)
Clone the repo:
git clone [https://github.com/YourUsername/Sat-Rakshak.git](https://github.com/YourUsername/Sat-Rakshak.git)
Navigate to lib/main.dart and paste your Ngrok URL:
final String _serverUrl = "YOUR_NGROK_LINK_HERE";
Run the app:
flutter run

## 📂 Directory Structure
Plaintext
Sat-Rakshak/
├── android/            # Android Native Config
├── lib/
│   ├── main.dart       # Main App Logic & Flood Check Screen
│   ├── onboarding.dart # Animated Introduction Screens
├── assets/             # Images and Icons
├── pubspec.yaml        # Flutter Dependencies
└── README.md           # Project Documentation

## 🔮 Future Scope
Drone Verification: Deploying drones for high-res validation in unclear areas.

Crop Loss Calculation: Integrating crop-type data to estimate financial loss (in Rupees).

Government API: Direct integration with Mahabhulekh for real-time land records.

## 👨‍💻 Contributors
Kaustubh Kulkarni - Lead Developer (AIML Engineer & Geospatial)
