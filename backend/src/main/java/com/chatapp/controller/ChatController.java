package com.chatapp.controller;

import com.chatapp.model.Message;
import com.chatapp.repository.MessageRepository;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class ChatController {

    private final MessageRepository messageRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public ChatController(MessageRepository messageRepository, SimpMessagingTemplate messagingTemplate) {
        this.messageRepository = messageRepository;
        this.messagingTemplate = messagingTemplate;
    }

    @MessageMapping("/chat")
    public void handleMessage(Message message) {
        // Save the incoming message to the database
        Message savedMessage = messageRepository.save(message);

        // Broadcast the saved message to all connected clients
        messagingTemplate.convertAndSend("/topic/messages", savedMessage);
    }
}

