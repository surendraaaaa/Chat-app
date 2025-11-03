package com.chatapp.service;

import com.chatapp.model.Message;
import com.chatapp.repository.MessageRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class MessageService {
    private final MessageRepository messageRepository;
    public MessageService(MessageRepository messageRepository) { this.messageRepository = messageRepository; }

    public Message save(Message message) { return messageRepository.save(message); }
    public List<Message> getAllMessages() { return messageRepository.findAll(); }
}
