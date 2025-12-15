 importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
 importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

 // Initialize Firebase
 firebase.initializeApp({
   apiKey: "AIzaSyBUrj4vodFE5spdc1S_DcBGk-vGQ7UCDQc",
   authDomain: "vendor-app-c249d.firebaseapp.com",
   projectId: "vendor-app-c249d",
   storageBucket: "vendor-app-c249d.appspot.com",
   messagingSenderId: "85528175451",
   appId: "1:85528175451:web:f2aadad828af267152307e",
   measurementId: "G-36XC5F20Y3"
 });

 const messaging = firebase.messaging();

 // Background message handler
 messaging.onBackgroundMessage((payload) => {
   console.log('[firebase-messaging-sw.js] Received background message', payload);

   // Customize notification here
   const notificationTitle = payload.notification?.title || 'New Notification';
   const notificationOptions = {
     body: payload.notification?.body || 'You have a new message',
     icon: '/icons/Icon-192.png',
     badge: '/icons/badge.png',
     data: payload.data,
     vibrate: [200, 100, 200],
     tag: 'vendor-app-notification'
   };

   return self.registration.showNotification(notificationTitle, notificationOptions);
 });

 // Notification click handler
 self.addEventListener('notificationclick', (event) => {
   event.notification.close();

   // Handle navigation based on notification data
   const urlToOpen = new URL(event.notification.data?.click_action || '/', self.location.origin).href;

   event.waitUntil(
     clients.matchAll({
       type: 'window',
       includeUncontrolled: true
     }).then((clientList) => {
       // Check if app is already open
       for (const client of clientList) {
         if (client.url === urlToOpen && 'focus' in client) {
           return client.focus();
         }
       }

       // Open new window if app isn't open
       if (clients.openWindow) {
         return clients.openWindow(urlToOpen);
       }
     })
   );
 });