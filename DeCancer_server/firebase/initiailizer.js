import firebase from "firebase/app";
// If you are using v7 or any earlier version of the JS SDK, you should import firebase using namespace import
// import * as firebase from "firebase/app"

// If you enabled Analytics in your project, add the Firebase SDK for Analytics
import "firebase/analytics";

// Add the Firebase products that you want to use
import "firebase/auth";
import "firebase/firestore";

// TODO: Replace the following with your app's Firebase project configuration
// For Firebase JavaScript SDK v7.20.0 and later, `measurementId` is an optional field
const firebaseConfig = {
    apiKey: "AIzaSyA_VYuVU-bIJA1CVQgSIWnmqTzShH1inxU",
    authDomain: "decancer-7d19a.firebaseapp.com",
    projectId: "decancer-7d19a",
    storageBucket: "decancer-7d19a.appspot.com",
    messagingSenderId: "169109542769",
    appId: "1:169109542769:web:ea397241f03b00fa92c8d0",
    measurementId: "G-X2KQ4GR7R0"
  };
  
  // Initialize Firebase
  firebase.initializeApp(firebaseConfig);