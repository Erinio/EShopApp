package qa.udst.eshop.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import qa.udst.eshop.models.Cart;
import java.util.Optional;

public interface CartRepository extends MongoRepository<Cart, String> {
    Optional<Cart> findByUserId(String userId);
    void deleteByUserId(String userId);
}
