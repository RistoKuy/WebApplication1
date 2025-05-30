<%@page contentType="text/html" pageEncoding="UTF-8"%>
<script type="module">
  // Firebase Configuration and Utilities
  import { initializeApp } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-analytics.js";
  import { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut, EmailAuthProvider, reauthenticateWithCredential, updatePassword } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-auth.js";
  import { getDatabase, ref, set, get, child } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-database.js";

  // Firebase configuration
  const firebaseConfig = {
    apiKey: "AIzaSyCfYaFJQsmu4Qt4YthfsCYpkAE6iyyGhBg",
    authDomain: "webapplication1-4bebd.firebaseapp.com",
    projectId: "webapplication1-4bebd",
    databaseURL: "https://webapplication1-4bebd-default-rtdb.asia-southeast1.firebasedatabase.app",
    storageBucket: "webapplication1-4bebd.firebasestorage.app",
    messagingSenderId: "561789365143",
    appId: "1:561789365143:web:f1add524dc4b8859fd32d2",
    measurementId: "G-27LM5PPDNJ"
  };

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
  const auth = getAuth(app);
  const database = getDatabase(app);

  // Make Firebase services available globally
  window.firebaseApp = app;
  window.firebaseAuth = auth;
  window.firebaseDatabase = database;
  window.firebaseAnalytics = analytics;

  // Firebase utility functions
  window.FirebaseUtils = {    // Login function
    async login(email, password) {
      try {
        const userCredential = await signInWithEmailAndPassword(auth, email, password);
        // Set session on server for user
        await fetch('firebase_session.jsp', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: 'email=' + encodeURIComponent(email) + '&firebase_uid=' + encodeURIComponent(userCredential.user.uid)
        });
        return { success: true, user: userCredential.user };
      } catch (error) {
        return { success: false, error: error.message };
      }
    },

    // Register function
    async register(email, password, nama) {
      try {
        const userCredential = await createUserWithEmailAndPassword(auth, email, password);
        const user = userCredential.user;
        
        // Save user data to Firebase Database
        await set(ref(database, 'users/' + user.uid), {
          nama: nama,
          email: email,
          createdAt: new Date().toISOString()
        });
        
        return { success: true, user: user };
      } catch (error) {
        return { success: false, error: error.message };
      }
    },

    // Logout function
    async logout() {
      try {
        await signOut(auth);
        return { success: true };
      } catch (error) {
        return { success: false, error: error.message };
      }
    },

    // Change password function
    async changePassword(currentPassword, newPassword) {
      try {
        const user = auth.currentUser;
        if (!user) {
          throw new Error('No user is currently signed in');
        }

        // Re-authenticate user
        const credential = EmailAuthProvider.credential(user.email, currentPassword);
        await reauthenticateWithCredential(user, credential);
        
        // Update password
        await updatePassword(user, newPassword);
        
        return { success: true };
      } catch (error) {
        return { success: false, error: error.message };
      }
    },

    // Get current user
    getCurrentUser() {
      return auth.currentUser;
    },

    // Check if user is logged in
    isLoggedIn() {
      return auth.currentUser !== null;
    },

    // Get user data from database
    async getUserData(uid) {
      try {
        const snapshot = await get(child(ref(database), `users/${uid}`));
        if (snapshot.exists()) {
          return { success: true, data: snapshot.val() };
        } else {
          return { success: false, error: 'No user data found' };
        }
      } catch (error) {
        return { success: false, error: error.message };
      }
    },

    // Update user data in database
    async updateUserData(uid, data) {
      try {
        await set(ref(database, 'users/' + uid), {
          ...data,
          updatedAt: new Date().toISOString()
        });
        return { success: true };
      } catch (error) {
        return { success: false, error: error.message };
      }
    },

    // Wait for authentication state to be ready
    waitForAuth() {
      return new Promise((resolve) => {
        const unsubscribe = auth.onAuthStateChanged((user) => {
          unsubscribe();
          resolve(user);
        });
      });
    }
  };

  // Authentication state observer
  auth.onAuthStateChanged((user) => {
    if (user) {
      console.log('User is signed in:', user.email);
      // Dispatch custom event for other parts of the application
      window.dispatchEvent(new CustomEvent('firebaseUserSignedIn', { detail: user }));
    } else {
      console.log('User is signed out');
      // Dispatch custom event for other parts of the application
      window.dispatchEvent(new CustomEvent('firebaseUserSignedOut'));
    }
  });

  console.log('Firebase initialized successfully');
  
  // Dispatch custom event to indicate Firebase is ready
  window.dispatchEvent(new CustomEvent('firebaseReady'));
</script>