Inside this folder firebase_emulator/

npm install -g firebase-tools
firebase init

// Select to start Realtime Databases, Firestore, Storage, Emulators 
// Add select yes to the Emulator UI

firebase init emulators

// Select these emulators for the emulator:
// - Authentication
// - Functions
// - Firestore
// - Databases
// - Storage


firebase emulators:start

// It will start 2 java applications, but in the terminal it should appear an box with ip address to the Emulator UI
// If it doesnt and instead does this:
// Error: Cannot start the Storage emulator without rules file specified in firebase.json: run 'firebase init' and set up your Storage configuration
// Then simply run 'firebase init' again and double install Storage again