package com.chatapp.websocket;

import com.chatapp.model.Message;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class ChatController {
    @MessageMapping("/chat")
    @SendTo("/topic/messages")
    public Message send(Message message) { return message; }
}
