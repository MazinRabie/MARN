// Create Connection
let ChatConnection = new signalR.HubConnectionBuilder()
    .withUrl("https://marn.runasp.net//hubs/notification")        
    .build();


// ----------------------------------
// receive notifications from hub
ChatConnection.on("ReceiveNotification", function (notification) {
    // do something when a notification is received
    console.log("A notification for user with ID " + notification.userId + " has been received");
});

ChatConnection.on("AllNotificationsMarkedAsRead", function () {
    // do something when all notifications are marked as read
    console.log("All notifications have been marked as read");
});

ChatConnection.on("NotificationMarkedAsRead", function (notificationId) {
    // do something when a notification is marked as read
    console.log("A notification with ID " + notificationId + " has been marked as read");
});


// ----------------------------------
// invoke hub method from client
function MarkAllNotificationsAsReadToHub() {
    // Invoke this method when user clicks on "Mark all as read" button to mark all notifications as read
    ChatConnection.send("MarkAllNotificationsAsRead");
}

function MarkNotificationAsReadToHub(notificationId) {
    // Invoke this method when user clicks on "Mark as read" button for a specific notification to mark it as read
    ChatConnection.send("MarkNotificationAsRead", notificationId);
}


// ----------------------------------
// start connection and then call hub
function fulfilled() {
    console.log("Connection to NotificationHub successful");
}

function rejected(error) {
    console.error(error);
}

ChatConnection
    .start()
    .then(fulfilled, rejected);