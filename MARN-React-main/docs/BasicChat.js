// Create Connection
let ChatConnection = new signalR.HubConnectionBuilder()
    .withUrl("https://marn.runasp.net//hubs/chat")        
    .build();


// ----------------------------------
// receive notifications from hub
ChatConnection.on("UserOnline", function (userId) {
    // do something when user is online
    console.log("A user with ID " + userId + " is online now");
});

ChatConnection.on("UserOffline", function (userId) {
    // do something when user is offline
    console.log("A user with ID " + userId + " is offline now");
});

ChatConnection.on("ReceiveMessage", function (Message) {
    // do something when user receives a message as activating a notification or updating the chat window if it is open
    console.log("A user with ID " + Message.SenderId + " sent a message to the user with ID " + Message.ReceiverId);
});

ChatConnection.on("SendMessage", function (Message) {
    // do something when user sends a message as updating the chat window if it is open
    console.log("A user with ID " + Message.SenderId + " sent a message to the user with ID " + Message.ReceiverId);
});


// ----------------------------------
// invoke hub method from client
function InActiveChatWithToHub() {
    // Invoke this method when user opens a chat window with another user to mark the chat as active and stop sending notifications for new messages in that chat
    // get sender id from input field
    let senderId = document.getElementById("senderId").value;
    ChatConnection.send("InActiveChatWith", senderId);
}

function LeaveActiveChatToHub() {
    // Invoke this method when user closes a chat window with another user to mark the chat as inactive and start sending notifications for new messages in that chat
    // get sender id from input field
    let senderId = document.getElementById("senderId").value;
    ChatConnection.send("LeaveActiveChat", senderId);
}


function SendMessageToHub() {
    // get receiver id and message content from input fields
    let receiverId = document.getElementById("receiverId").value;
    let content = document.getElementById("messageContent").value;
    ChatConnection.send("SendMessage", receiverId, content);
}

function MarkChatAsReadToHub() {
    // Invoke this method when user opens a chat window (or any update is received to it) to mark all messages from that chat as read
    // get sender id from input field
    let senderId = document.getElementById("senderId").value;
    ChatConnection.send("MarkChatAsRead", senderId);
}


// ----------------------------------
// start connection and then call hub
function fulfilled() {
    console.log("Connection to ChatHub successful");
}

function rejected(error) {
    console.error(error);
}

ChatConnection
    .start()
    .then(fulfilled, rejected);