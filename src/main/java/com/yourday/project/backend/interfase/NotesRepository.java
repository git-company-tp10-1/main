package com.yourday.project.backend.interfase;

import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface NotesRepository extends JpaRepository<Notes, String> {
    List<Notes> findByUserId(String userId);


    Optional<Notes> findByUserAndTime(User user, LocalDateTime time);


    List<Notes> findAllByUserAndTimeBetween(User user, LocalDateTime start, LocalDateTime end );
}


