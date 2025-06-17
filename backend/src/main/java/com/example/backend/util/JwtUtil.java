package com.example.backend.util;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;

public class JwtUtil {

    private static final String SECRET_KEY = "very-long-secret-key-for-hs512-encryption-should-be-64bytes-minimum-size";
    private static final SecretKey key = Keys.hmacShaKeyFor(SECRET_KEY.getBytes(StandardCharsets.UTF_8));
    public static String generateToken(int id, String username, String role) {
        long expirationMillis = 1000 * 60 * 60 * 24; // 2 tiếng

        return Jwts.builder()
                .claim("id", id)
                .claim("username", username)
                .claim("role", role)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationMillis))
                .signWith(key)
                .compact();
    }

    public static Key getKey() {
        return key;
    }
}