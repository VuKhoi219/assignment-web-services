package com.example.backend.util;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

import java.security.Key;
import java.util.Date;

public class JwtUtil {

    private static final Key key = Keys.secretKeyFor(SignatureAlgorithm.HS256); // bí mật tạm thời

    public static String generateToken(int id, String username, String role) {
        long expirationMillis = 1000 * 60 * 60 * 2; // 2 tiếng

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