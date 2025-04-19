package qa.udst.eshop.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import qa.udst.eshop.models.User;
import java.util.Optional;

public interface UserRepository extends MongoRepository<User, String> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
}
