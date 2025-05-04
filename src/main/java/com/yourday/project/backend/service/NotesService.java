package com.yourday.project.backend.service;

import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.interfase.NotesRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotesService {

    private final NotesRepository noteRepository;


    public NotesService(NotesRepository noteRepository) {
        this.noteRepository = noteRepository;
    }

    public List<Notes> getNotesByUserId(String userId) {
        return noteRepository.findByUserId(userId);
    }
}

