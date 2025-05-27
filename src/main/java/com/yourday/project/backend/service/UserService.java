package com.yourday.project.backend.service;
import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;



    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User createUser(User user) {
        return userRepository.save(user);
    }

    public User findByEmail(String userEmail) {

        return userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new IllegalArgumentException("User with email " + userEmail + " not found"));
    }

    public void updateUser(User user, User updatedUser) {
        if (user == null || updatedUser == null) {
            throw new IllegalArgumentException("User objects cannot be null");
        }

        Optional.ofNullable(updatedUser.getEmail())
                .filter(e -> !e.isBlank())
                .ifPresent(user::setEmail);



        Optional.ofNullable(updatedUser.getName())
                .filter(n -> !n.isBlank())
                .ifPresent(user::setName);

        user.setUpdated_at(LocalDateTime.now());
        userRepository.save(user);// Обновляем метку изменения
    }

}

