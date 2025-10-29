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
    const socket = new SockJS("http://chat-backend:5000/ws-chat");
    const client = new Client({
      webSocketFactory: () => socket,
      reconnectDelay: 5000,
    });

    client.onConnect = () => {
      setConnected(true);
      client.subscribe("/topic/messages", (message) => {
        setMessages((prev) => [...prev, JSON.parse(message.body)]);
      });
    };

    client.onStompError = (frame) => {
      console.error("Broker error:", frame.headers["message"]);
    };

    stompClientRef.current = client;
    client.activate();
  };

  const sendMessage = () => {
    if (stompClientRef.current && msg.trim()) {
      stompClientRef.current.publish({
        destination: "/app/chat",
        body: JSON.stringify({ sender: username, content: msg }),
      });
      setMsg("");
    }
  };

  useEffect(() => {
    return () => {
      if (stompClientRef.current) {
        stompClientRef.current.deactivate();
      }
    };
  }, []);

  return (
    <div className="container">
      {!connected ? (
        <div className="login">
          <input
            placeholder="Username"
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
                <strong>{m.sender}:</strong> {m.content}
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
