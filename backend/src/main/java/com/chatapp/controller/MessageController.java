package com.chatapp.controller;

import com.chatapp.model.Message;
import com.chatapp.service.MessageService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/messages")
public class MessageController {
    private final MessageService messageService;
    public MessageController(MessageService messageService) { this.messageService = messageService; }

    @PostMapping
    public Message sendMessage(@RequestBody Message message) { return messageService.save(message); }

    @GetMapping
    public List<Message> getMessages() { return messageService.getAllMessages(); }
}






