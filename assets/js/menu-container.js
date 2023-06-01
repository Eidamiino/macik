let channel = socket.channel('room:lobby');

channel.join()
    .receive('ok', resp => {
        console.info("Joined the lobby");
    });