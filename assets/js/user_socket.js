// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"

// And connect to the path in "lib/macik_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/macik_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/macik_web/templates/layout/app.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/macik_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
// Function to handle joining a room

//checkuju guardian token:
let socket = new Socket("/userSocket", { params: {token: window.userToken}})

function joinRoom(roomName) {
  let channel = socket.channel(`room:${roomName}`, {});

  channel.join()
    .receive("ok", resp => {
      channel.push('join', { room: roomName})    
      console.log(`Joined ${roomName} room successfully`, resp);

      channel.on('shout', () => {
        console.info(`A user just shouted in ${roomName} room!`);
      });

      channel.on('leave', () => {
        console.info(`A user left ${roomName} room.`);
      });
    })
    .receive("error", resp => {
      console.log(`Unable to join ${roomName} room`, resp);
    });

  return channel;
}
function leaveRoom(topic){
  const roomName = getRoomName(currentChannel.topic);
  currentChannel.leave(roomName)
}

function getRoomName(topic){
  const topicArray = topic.split(":");
  const roomName = topicArray[1];

  return roomName
}

socket.connect();

let currentChannel = joinRoom("lobby");
console.log(currentChannel)

document.getElementById("joinButton1").addEventListener("click", () => {
  currentChannel.push('leave', { room: getRoomName(currentChannel.topic) })
  leaveRoom(currentChannel.topic);

  currentChannel = joinRoom("room1");
});

document.getElementById("joinButton2").addEventListener("click", () => {
  currentChannel.push('leave', {room: getRoomName(currentChannel.topic)})
  leaveRoom(currentChannel.topic);
  
  currentChannel = joinRoom("room2"); 
});

document.getElementById("leaveButton").addEventListener("click", () => {
  currentChannel.push('leave', { room: getRoomName(currentChannel.topic) })
  leaveRoom(currentChannel.topic);
  
  currentChannel = joinRoom("lobby");
});

export default socket;

