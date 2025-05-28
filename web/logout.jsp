<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Invalidate the current session
    session.invalidate();
    
    // Redirect to index page
    response.sendRedirect("index.jsp");
%>

<script type="module">
  import { initializeApp } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-app.js";
  import { getAnalytics } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-analytics.js";
  import { getAuth, signOut } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-auth.js";

  // Your web app's Firebase configuration
  const firebaseConfig = {
    apiKey: "AIzaSyCfYaFJQsmu4Qt4YthfsCYpkAE6iyyGhBg",
    authDomain: "webapplication1-4bebd.firebaseapp.com",
    projectId: "webapplication1-4bebd",
    storageBucket: "webapplication1-4bebd.firebasestorage.app",
    messagingSenderId: "561789365143",
    appId: "1:561789365143:web:f1add524dc4b8859fd32d2",
    measurementId: "G-27LM5PPDNJ"
  };

  // Initialize Firebase
  const app = initializeApp(firebaseConfig);
  const analytics = getAnalytics(app);
  const auth = getAuth(app);

  // Sign out from Firebase Auth
  signOut(auth).catch((error) => {
    // Optionally handle sign out error
    console.error('Firebase sign out failed:', error.message);
  });
</script>