import React, { useState, useEffect, useRef } from "react";
import SockJS from "sockjs-client";
import { Client } from "@stomp/stompjs";
import "./App.css";

function App() {
  const [username, setUsername] = useState("");
  const [connected, setConnected] = useState(false);
  const [messages, setMessages] = useState([]);
  const [msg, setMsg] = useState("");

  const stompClientRef = useRef(null);

  const connect = () => {
    if (!username.trim()) {
      alert("Enter a username first");
      return;
    }

    const client = new Client({
      brokerURL: undefined, // disable native WebSocket
      webSocketFactory: () => new SockJS(process.env.REACT_APP_BACKEND_URL + "/ws-chat")
,
      reconnectDelay: 3000,
      debug: (str) => console.log("STOMP DEBUG:", str),
    });

    client.onConnect = () => {
      console.log("✅ Connected to WebSocket server");
      setConnected(true);

      client.subscribe("/topic/messages", (message) => {
        const payload = JSON.parse(message.body);
        setMessages((prev) => [...prev, payload]);
      });
    };

    client.onWebSocketError = (err) => {
      console.error("WebSocket error:", err);
    };

    client.onStompError = (frame) => {
      console.error("STOMP error:", frame.headers["message"]);
    };

    client.activate();
    stompClientRef.current = client;
  };

  const sendMessage = () => {
    if (stompClientRef.current && msg.trim()) {
      stompClientRef.current.publish({
        destination: "/app/chat",
        body: JSON.stringify({
          sender: username,
          content: msg,
        }),
      });
      setMsg("");
    }
  };

  useEffect(() => {
    return () => {
      if (stompClientRef.current) stompClientRef.current.deactivate();
    };
  }, []);

  return (
    <div className="container">
      {!connected ? (
        <div className="login">
          <input
            placeholder="Enter username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
          <button onClick={connect}>Connect</button>
        </div>
      ) : (
        <div className="chat">
          <div className="messages">
            {messages.map((m, idx) => (
              <p key={idx}>
                <strong>{m.sender}: </strong>
                {m.content}
              </p>
            ))}
          </div>

          <input
            placeholder="Message"
            value={msg}
            onChange={(e) => setMsg(e.target.value)}
          />
          <button onClick={sendMessage}>Send</button>
        </div>
      )}
    </div>
  );
}

export default App;
