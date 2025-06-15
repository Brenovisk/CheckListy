<p align="center">
  <img src="READMEAssets/Logo.png" alt="CheckListy Logo" width="200"/>
</p>

<p align="center">
  <strong>CheckListy</strong> is more than just a to-do list app — it's a smart task manager powered by voice commands, real-time syncing, and modern navigation built with SwiftUI.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-✔️-F05138?logo=swift&logoColor=white&style=flat"/>
  <img src="https://img.shields.io/badge/SwiftUI-✔️-blue?logo=apple&logoColor=white&style=flat"/>
  <img src="https://img.shields.io/badge/Firebase-Integrated-FFCA28?logo=firebase&logoColor=black&style=flat"/>
  <img src="https://img.shields.io/badge/Combine-Reactive-ff2e63?logo=react&logoColor=white&style=flat"/>
  <img src="https://img.shields.io/badge/Speech_Recognition-Enabled-0fcf90?logo=google&logoColor=white&style=flat"/>
  <img src="https://img.shields.io/badge/Realm-Local_Cache-5c2d91?logo=realm&logoColor=white&style=flat"/>
  <img src="https://img.shields.io/badge/Google_Login-Enabled-4285F4?logo=google&logoColor=white&style=flat"/>
  <img src="https://img.shields.io/badge/License-MIT-lightgrey?style=flat"/>
</p>


<p align="center">
  <img src="READMEAssets/demo.gif" width="200" alt="CheckListy demo GIF"/>
</p>

## ✨ Features

- ✅ Add and edit tasks quickly with a clean interface.
- 🗣️ Mark tasks as done or undone using **voice commands**:
  - `"Task Name OK"` → checks the item.
  - `"Task Name No"` or `"Task Name Não"` → unchecks the item.
- 🔄 Auto-sync with **Firebase Realtime Database**.
- 🔐 User authentication via **Firebase Authentication**.
- 🔐 Sign in with **Google**.
- ☁️ Store profile images using **Firebase Storage**.
- 💾 Local data persistence with **Realm** (used to cache the user's profile image).
- 🧼 Built-in section to delete all user data (local and remote).
- 🤝 Share lists with others in real-time.
- 🧭 Uses the new **type-based navigation** system (`navigationDestination`).
- 🎨 Full UI/UX design created in **Figma**.


## 🖼️ Screenshots

<p align="center">
  <img src="READMEAssets/screenshot-1.PNG" width="140"/>
  <img src="READMEAssets/screenshot-2.PNG" width="140"/>
  <img src="READMEAssets/screenshot-3.PNG" width="140"/>
  <img src="READMEAssets/screenshot-4.PNG" width="140"/>
  <img src="READMEAssets/screenshot-5.PNG" width="140"/>
</p>

<p align="center">
  <img src="READMEAssets/screenshot-6.PNG" width="140"/>
  <img src="READMEAssets/screenshot-7.PNG" width="140"/>
  <img src="READMEAssets/screenshot-8.PNG" width="140"/>
  <img src="READMEAssets/screenshot-9.PNG" width="140"/>
  <img src="READMEAssets/screenshot-10.PNG" width="140"/>
</p>

---

## ⚙️ Tech Stack

- [x] **Swift + SwiftUI**
- [x] **Firebase (Auth, Realtime Database, Storage)**
- [x] **Google Sign-In**
- [x] **Combine** with `@PropertyWrapper` for reactivity
- [x] **Speech Framework** (Apple) for voice recognition
- [x] **RealmSwift** (only for local photo cache)
- [x] **Offline Persistence + Auto-Sync**
- [x] Modern navigation with `navigationDestination`


## 🧪 Voice Command Examples

Just speak:

- `"Buy milk OK"` → checks the item  
- `"Buy milk No"` or `"Buy milk Não"` → unchecks the item

> Perfect for **hands-free productivity** anywhere.



## 📲 Installation (Private Dev Build)

1. Clone the repository:

```bash
git clone https://github.com/your-username/checklisty.git
cd checklisty
```

> ⚠️ ***This project is under active development:*** Features and UI may change rapidly while improvements are being made.