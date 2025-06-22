package com.example.backend.util;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;

public class CheckRole {
    public boolean checkRole(String token,String role) {
        try{
            System.out.println("vào đây");
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(JwtUtil.getKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

            String userRole = claims.get("role", String.class);
            System.out.println("userRole: "+userRole);
            return role.equals(userRole);
        } catch (Exception e) {
            System.out.println(e);
            return false;
        }
    }

}
