<div class= "body">
  <div class= "center">
      <img src="READMEAssets/Logo.png" class= "logo" />  
  </div>

  <div class= "bySide">
    <div class = "column">
      <p align="center"><span>CheckListy</span> is more than just a to-do list app — it's a smart task manager powered by voice commands, real-time syncing, and modern navigation built with SwiftUI.
      </p>s

  <p align="center" style="padding-top:16px; ">
    <img src="https://img.shields.io/badge/Swift-✔️-F05138?logo=swift&logoColor=white&style=flat" />
    <img src="https://img.shields.io/badge/SwiftUI-✔️-blue?logo=apple&logoColor=white&style=flat" />
    <img src="https://img.shields.io/badge/Firebase-Integrated-FFCA28?logo=firebase&logoColor=black&style=flat" />
    <img src="https://img.shields.io/badge/Combine-Reactive-ff2e63?logo=react&logoColor=white&style=flat" />
    <img src="https://img.shields.io/badge/Speech_Recognition-Enabled-0fcf90?logo=google&logoColor=white&style=flat" />
    <img src="https://img.shields.io/badge/Realm-Local_Cache-5c2d91?logo=realm&logoColor=white&style=flat" />
    <img src="https://img.shields.io/badge/Google_Login-Enabled-4285F4?logo=google&logoColor=white&style=flat" />
    <img src="https://img.shields.io/badge/License-MIT-lightgrey?style=flat" />
  </p>
    </div>

  <div class = "column">
  <div class="slider"> 
    <div class="slides">
      <img src="READMEAssets/screenshot-1.PNG" width="100" />
      <img src="READMEAssets/screenshot-2.PNG" width="100" />
      <img src="READMEAssets/screenshot-3.PNG" width="100" />
      <img src="READMEAssets/screenshot-4.PNG" width="100" />
      <img src="READMEAssets/screenshot-5.PNG" width="100" />
      <img src="READMEAssets/screenshot-6.PNG" width="100" />
      <img src="READMEAssets/screenshot-7.PNG" width="100" />
      <img src="READMEAssets/screenshot-8.PNG" width="100" />
      <img src="READMEAssets/screenshot-9.PNG" width="100" />
      <img src="READMEAssets/screenshot-10.PNG" width="100" />
      <img src="READMEAssets/screenshot-11.PNG" width="100" />
    </div>
  </div>
  </div>
  </div>

  <div class="bySide" >
    <div class= "column" >

<span>✨ Features</span>

- ✅ Add and edit tasks quickly with a clean interface.
- 🗣️ Mark tasks as done or undone using <span>voice commands</span>:
- `"Task Name OK"` → checks the item.
- "Task Name No"`or`"Task Name Não"` → unchecks the item.
- 🔄 Auto-sync with <span>Firebase Realtime Database</span>.
- 🔐 User authentication via <span>Firebase Authentication</span>.
- 🔐 Sign in with <span>Google</span>.
- ☁️ Store profile images using <span>Firebase Storage</span>.
- 💾 Local data persistence with <span>Realm</span> (used to cache the user's profile image).
- 🧼 Built-in section to delete all user data (local and remote).
- 🎨 Full UI/UX design created in <span>Figma</span>.

  </div>

    <div class= "screenshots column" >
      <img src="READMEAssets/demo.gif" alt="Demonstração do CheckListy" class= "screenshots" />
    </div>

    </div>

  <span> ⚙️ Tech Stack </span>

  - [x] <span>Swift + SwiftUI</span>
  - [x] <span>Firebase (Auth, Realtime Database, Storage)</span>
  - [x] <span>\*Combine</span> with `@PropertyWrapper` for reactivity
  - [x] <span>Speech Framework</span> (Apple) for voice recognition
  - [x] <span>RealmSwift</span> (only for local photo cache)
  - [x] <span>Offline Persistence + Auto-Sync Firebase</span>
  - [x] Uses the new <span>type-based navigation system</span>

  <span>🧪 Voice Command Examples</span>

    <div class= "box">

  Just speak:

  - `"Buy milk OK"` → checks the item
  - `"Buy milk No"` or `"Buy milk Não"` → unchecks the item

    Perfect for <span>hands-free</span> productivity in any environment.

    </div>

  <span>📲 Installation (Private Dev Build)</span>

  1. Clone the repository:

  ```bash
   git clone https://github.com/your-username/checklisty.git
   cd checklisty
  ```

    <div class= "box">
      <span>⚠️ This project is under active development :</span> 
      Features and UI may change rapidly while improvements are being made.
    </div>

</div>

<!-- README style -->
<style>
    :root {
      --bg-color: #121212;
      --text-color: #e0e0e0;
      --box-bg: #333;
      --highlight: #fff;
      --border-radius: 8px;
      --padding: 32px;
    }

    .body {
      background-color: var(--bg-color);
      color: var(--text-color);
      font-family: sans-serif;
      padding: var(--padding);
      margin: 0;
    }

    .container {
      background-color: var(--bg-color);
      padding: var(--padding);
      border-radius: var(--border-radius);
    }

    span{
      color: #e0e0e0; font-weight: bold;
    }

    .logo {
      width: 200px; 
      padding: 32px 0px;
    }

    .center {
      display: flex;
      justify-content: center;
      padding: 32px 0;
    }

    .slider {
      max-width: 200px;
      margin: 0 auto 32px;
      overflow: hidden;
      border-radius: 10px;
    }

    .slides {
      display: flex;
      animation: slide 20s infinite;
    }

    .slides img {
      width: 100%;
      height: auto;
    }

    @keyframes slide {
      0%, 10% { transform: translateX(0%); }
      15%, 25% { transform: translateX(-100%); }
      30%, 40% { transform: translateX(-200%); }
      45%, 55% { transform: translateX(-300%); }
      60%, 70% { transform: translateX(-400%); }
      75%, 85% { transform: translateX(-500%); }
      90%, 100% { transform: translateX(0%); }
    }

    .badges img {
      margin: 4px;
    }

    .section-title {
      font-weight: bold;
      color: var(--text-color);
      font-size: 1.2em;
      margin-top: 32px;
    }

    .box {
      background-color: var(--box-bg);
      padding: 12px 16px;
      border-radius: var(--border-radius);
      margin: 16px 0;
    }

    .screenshots {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 8px;
      margin: 24px 0;
    }

    .screenshots img {
      width: 200px;
      border-radius: 6px;
    }

    .bySide {
      display: flex;
      flex-direction: horizontal;
      justify-content: space-between;
      align-items: center;
    }

    .column {
      width:50%;
    }
  </style>
