package qa.udst.eshop.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import qa.udst.eshop.models.Product;
import qa.udst.eshop.repositories.ProductRepository;
import qa.udst.eshop.repositories.CategoryRepository;
import java.util.List;

@Service
public class ProductService {
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;

    @Autowired
    public ProductService(ProductRepository productRepository, CategoryRepository categoryRepository) {
        this.productRepository = productRepository;
        this.categoryRepository = categoryRepository;
    }

    public List<Product> getAllProducts() {
        List<Product> products = productRepository.findAll();
        products.forEach(product -> {
            categoryRepository.findById(product.getCategoryId())
                .ifPresent(category -> product.setCategory(category.getName()));
        });
        return products;
    }

    public Product getProductById(String id) {
        return productRepository.findById(id).orElse(null);
    }

    public Product createProduct(Product product) {
        return productRepository.save(product);
    }
}
