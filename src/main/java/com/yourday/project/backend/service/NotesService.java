package com.yourday.project.backend.service;

import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.NotesRepository;
import com.yourday.project.backend.interfase.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class NotesService {

    private final NotesRepository noteRepository;
    private final UserRepository userRepository;;


    public NotesService(NotesRepository noteRepository, UserRepository userRepository) {
        this.noteRepository = noteRepository;
        this.userRepository = userRepository;
    }

    public List<Notes> getNotesByUserId(String userId) {
        return noteRepository.findByUserId(userId);
    }

    public Notes saveNotes(Notes notes, UUID userID) {

        User user = userRepository.findById(userID)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        notes.setUser(user);


        return noteRepository.save(notes);
    }
}

