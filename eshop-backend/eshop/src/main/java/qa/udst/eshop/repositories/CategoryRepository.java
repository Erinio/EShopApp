package qa.udst.eshop.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import qa.udst.eshop.models.Category;

public interface CategoryRepository extends MongoRepository<Category, String> {
    Category findByName(String name);
}
