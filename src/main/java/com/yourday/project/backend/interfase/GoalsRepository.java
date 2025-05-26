package com.yourday.project.backend.interfase;

import com.yourday.project.backend.entity.Goals;
import com.yourday.project.backend.entity.Notes;
import com.yourday.project.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;


public interface GoalsRepository extends JpaRepository<Goals, String> {

    Optional<Goals> findByUserAndContent(User user, String content);
}
