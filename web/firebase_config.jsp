<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="util.EnvConfig"%>
<script type="module">
  // Firebase Configuration and Utilities
  import { initializeApp } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-analytics.js";
  import { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, signOut, EmailAuthProvider, reauthenticateWithCredential, updatePassword, GoogleAuthProvider, signInWithPopup, signInWithRedirect, getRedirectResult } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-auth.js";  import { getDatabase, ref, set, get, child } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-database.js";

  // Firebase configuration from environment variables
  const firebaseConfig = {
    apiKey: "<%= EnvConfig.getFirebaseApiKey() %>",
    authDomain: "<%= EnvConfig.getFirebaseAuthDomain() %>",
    projectId: "<%= EnvConfig.getFirebaseProjectId() %>",
    // Remove databaseURL if not using Realtime Database
    // databaseURL: "<%= EnvConfig.getFirebaseDatabaseUrl() %>",
    storageBucket: "<%= EnvConfig.getFirebaseStorageBucket() %>",
    messagingSenderId: "<%= EnvConfig.getFirebaseMessagingSenderId() %>",
    appId: "<%= EnvConfig.getFirebaseAppId() %>",
    measurementId: "<%= EnvConfig.getFirebaseMeasurementId() %>"
  };
  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
  const auth = getAuth(app);
  // Comment out database initialization if not using Realtime Database
  // const database = getDatabase(app);

  // Make Firebase services available globally
  window.firebaseApp = app;
  window.firebaseAuth = auth;
  // window.firebaseDatabase = database;
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
    },    // Register function
    async register(email, password, nama) {
      try {
        const userCredential = await createUserWithEmailAndPassword(auth, email, password);
        const user = userCredential.user;
        
        // Note: Database functionality removed - using only Firebase Auth
        // If you need to store user data, consider using Firestore instead
        
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
    },    // Get user data from database
    async getUserData(uid) {
      try {
        // Database functionality removed - using only Firebase Auth
        // Return user data from Firebase Auth instead
        const user = auth.currentUser;
        if (user && user.uid === uid) {
          return { 
            success: true, 
            data: {
              email: user.email,
              uid: user.uid,
              displayName: user.displayName,
              createdAt: user.metadata.creationTime
            }
          };
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
        // Database functionality removed - using only Firebase Auth
        // Note: Firebase Auth has limited profile update capabilities
        console.log('Update user data called but database functionality is disabled');
        return { success: true };
      } catch (error) {
        return { success: false, error: error.message };
      }
    },// Wait for authentication state to be ready
    waitForAuth() {
      return new Promise((resolve) => {
        const unsubscribe = auth.onAuthStateChanged((user) => {
          unsubscribe();
          resolve(user);
        });
      });
    },    // Google login function
    async loginWithGoogle() {
      try {
        console.log('Starting Google login...');
        const provider = new GoogleAuthProvider();
        provider.addScope('email');
        provider.addScope('profile');
        
        let result;
        let user;
        
        try {
          // Try popup first
          console.log('Attempting popup login...');
          result = await signInWithPopup(auth, provider);
          user = result.user;
        } catch (popupError) {
          console.log('Popup failed, trying redirect...', popupError.message);
          
          // If popup fails (blocked), try redirect
          if (popupError.code === 'auth/popup-blocked' || popupError.code === 'auth/popup-closed-by-user') {
            console.log('Using redirect method...');
            await signInWithRedirect(auth, provider);
            // This will cause a page redirect, so we return here
            return { success: true, redirect: true };
          } else {
            throw popupError;
          }
        }
        
        console.log('Google login successful:', user.email);
        
        // Check if user data exists in database
        const userData = await this.getUserData(user.uid);
        
        if (!userData.success) {
          console.log('Creating new user data...');
          // User doesn't exist, create new user data
          await set(ref(database, 'users/' + user.uid), {
            nama: user.displayName || user.email.split('@')[0],
            email: user.email,
            createdAt: new Date().toISOString(),
            loginMethod: 'google'
          });
        }
        
        // Set session on server for user
        console.log('Setting server session...');
        const sessionResponse = await fetch('firebase_session.jsp', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          body: 'email=' + encodeURIComponent(user.email) + '&firebase_uid=' + encodeURIComponent(user.uid)
        });
        
        if (!sessionResponse.ok) {
          console.error('Failed to set server session');
          throw new Error('Failed to set server session');
        } else {
          console.log('Server session set successfully');
        }
        
        return { success: true, user: user };
      } catch (error) {
        console.error('Google login error:', error);
        return { success: false, error: error.message };
      }
    },

    // Check for redirect result (for when using redirect method)
    async checkRedirectResult() {
      try {
        const result = await getRedirectResult(auth);
        if (result) {
          const user = result.user;
          console.log('Redirect login successful:', user.email);
          
          // Check if user data exists in database
          const userData = await this.getUserData(user.uid);
          
          if (!userData.success) {
            console.log('Creating new user data...');
            // User doesn't exist, create new user data
            await set(ref(database, 'users/' + user.uid), {
              nama: user.displayName || user.email.split('@')[0],
              email: user.email,
              createdAt: new Date().toISOString(),
              loginMethod: 'google'
            });
          }
          
          // Set session on server for user
          console.log('Setting server session...');
          const sessionResponse = await fetch('firebase_session.jsp', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'email=' + encodeURIComponent(user.email) + '&firebase_uid=' + encodeURIComponent(user.uid)
          });
          
          if (sessionResponse.ok) {
            console.log('Server session set successfully');
            // Redirect to main page
            window.location.href = 'main.jsp';
          } else {
            console.error('Failed to set server session');
          }
        }
      } catch (error) {
        console.error('Redirect result error:', error);
      }
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
  
  // Check for redirect result on page load
  window.FirebaseUtils.checkRedirectResult();
  
  // Dispatch custom event to indicate Firebase is ready
  window.dispatchEvent(new CustomEvent('firebaseReady'));
</script>