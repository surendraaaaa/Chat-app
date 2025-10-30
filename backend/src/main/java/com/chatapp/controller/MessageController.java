package com.chatapp.controller;

import com.chatapp.model.Message;
import com.chatapp.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/messages")
public class MessageController {

    private final MessageService messageService;

    @Autowired
    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    // Save a new message via HTTP POST
    @PostMapping
    public Message sendMessage(@RequestBody Message message) {
        return messageService.save(message);
    }

    // Retrieve all messages via HTTP GET
    @GetMapping
    public List<Message> getMessages() {
        return messageService.getAllMessages();
    }
}

