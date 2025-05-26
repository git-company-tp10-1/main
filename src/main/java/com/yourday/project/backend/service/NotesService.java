package com.yourday.project.backend.service;

import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.NotesRepository;
import com.yourday.project.backend.interfase.UserRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ConcurrentModificationException;
import java.util.List;

@Service
public class NotesService {

    private final NotesRepository noteRepository;



    public NotesService(NotesRepository noteRepository, UserRepository userRepository) {
        this.noteRepository = noteRepository;
    }

    public List<Notes> getNotesByUserId(String userId) {
        return noteRepository.findByUserId(userId);
    }

    public void saveNotes(Notes notes, User user) {
        notes.setUser(user);
        noteRepository.save(notes);
    }

    public Notes updateNotes(Notes notes, User user) {

        if (notes == null || user == null || notes.getTime() == null) {
            throw new IllegalArgumentException("Notes, User, and Time cannot be null");
        }


        Notes existingNote = noteRepository.findByUserAndTime(user, notes.getTime())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Note not found for user " + user.getId() + " at time " + notes.getTime()
                ));

        existingNote.setTitle(notes.getTitle());
        existingNote.setContent(notes.getContent());
        existingNote.setUpdatedAt(LocalDateTime.now());


        return noteRepository.save(existingNote);
    }

    public void deleteNotes(Notes notes, User user) {

        if (notes == null || user == null || notes.getTime() == null) {
            throw new IllegalArgumentException("Notes, User, and Time cannot be null");
        }


        Notes existingNote = noteRepository.findByUserAndTime(user, notes.getTime())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Note not found for user " + user.getId() + " at time " + notes.getTime()
                ));


        noteRepository.delete(existingNote);
    }



    public List<Notes> getNotesForDate(LocalDate date, User user) {

        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.atTime(LocalTime.MAX);
        return noteRepository.findAllByUserAndTimeBetween(user, startOfDay, endOfDay);
    }
}

