package com.yourday.project.backend.service;

import com.yourday.project.backend.entity.User;
import com.yourday.project.backend.interfase.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class RegistrationService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User registerUser(User user) {

        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email is already in use");
        }

        User newUser = new User();

        newUser.setEmail(user.getEmail());
        newUser.setName(user.getName());
        newUser.setPassword(passwordEncoder.encode(user.getPassword()));
        newUser.setPremium(false);
        newUser.setCreated_at(LocalDateTime.now());
        newUser.setUpdated_at(LocalDateTime.now());


        return userRepository.save(newUser);
    }

    public User loginUser(User user) {

        Optional<User> foundUser = userRepository.findByEmail(user.getEmail());

        // Если пользователь не найден, выбросить исключение
        if (foundUser.isEmpty()) {
            throw new IllegalArgumentException("Invalid email or password");
        }

        User existingUser = foundUser.get();

        // Проверить соответствие пароля
        if (!passwordEncoder.matches(user.getPassword(), existingUser.getPassword())) {
            throw new IllegalArgumentException("Invalid email or password");
        }


        return existingUser;
    }
}
