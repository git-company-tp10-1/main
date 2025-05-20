package com.yourday.project.backend.security;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.yourday.project.backend.entity.User;
import org.springframework.stereotype.Component;
import java.util.Date;




@Component
public class JwtUtil {

        private static final String SECRET_KEY = "YourSecretKey";
        private static final long EXPIRATION_TIME = 1000 * 60 * 60 * 10; // 10 часов

        public String generateToken(User user) {
            return JWT.create()
                    .withSubject(user.getEmail())
                    .withClaim("id", user.getId().toString())
                    .withIssuedAt(new Date())
                    .withExpiresAt(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                    .sign(Algorithm.HMAC256(SECRET_KEY));
        }

    public boolean validateToken(String token) {
        try {
            JWT.require(Algorithm.HMAC256(SECRET_KEY)).build().verify(token);
            return true;
        } catch (JWTVerificationException e) {
            return false;
        }
    }

    public String extractEmail(String token) {
        return JWT.decode(token).getSubject();
    }
}
