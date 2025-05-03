package com.yourday.project.backend.interfase;

import com.yourday.project.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository  extends JpaRepository<User, UUID> {
    Optional<User> findByEmail(String email);

    @Override
    Optional<User> findById(UUID uuid);
}
