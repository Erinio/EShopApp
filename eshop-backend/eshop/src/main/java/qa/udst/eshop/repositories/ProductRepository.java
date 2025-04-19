package qa.udst.eshop.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import qa.udst.eshop.models.Product;

public interface ProductRepository extends MongoRepository<Product, String> {
}
