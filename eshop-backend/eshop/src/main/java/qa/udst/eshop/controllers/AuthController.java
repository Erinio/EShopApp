package qa.udst.eshop.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import qa.udst.eshop.models.User;
import qa.udst.eshop.security.JwtUtils;
import qa.udst.eshop.services.UserService;
import java.util.HashMap;
import java.util.Map;
import org.springframework.dao.IncorrectResultSizeDataAccessException;
import qa.udst.eshop.exceptions.DuplicateUserException;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody User user) {
        try {
            return ResponseEntity.ok(userService.createUser(user));
        } catch (DuplicateUserException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("An error occurred during signup");
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody User loginRequest) {
        try {
            User user = userService.findByUsername(loginRequest.getUsername());
            
            if (user != null && passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
                String token = jwtUtils.generateToken(user.getUsername());
                Map<String, Object> response = new HashMap<>();
                response.put("token", token);
                response.put("user", user);
                return ResponseEntity.ok(response);
            }
            
            return ResponseEntity.badRequest().body("Invalid username or password");
        } catch (IncorrectResultSizeDataAccessException e) {
            return ResponseEntity.badRequest().body("Multiple users found with the same username. Please contact support.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("An error occurred during login");
        }
    }
}
