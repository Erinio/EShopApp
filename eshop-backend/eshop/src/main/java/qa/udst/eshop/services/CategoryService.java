package qa.udst.eshop.services;

import org.springframework.stereotype.Service;
import qa.udst.eshop.models.Category;
import qa.udst.eshop.repositories.CategoryRepository;
import java.util.List;

@Service
public class CategoryService {
    private final CategoryRepository categoryRepository;

    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    public Category createCategory(Category category) {
        return categoryRepository.save(category);
    }

    public Category findById(String id) {
        return categoryRepository.findById(id).orElse(null);
    }
}
