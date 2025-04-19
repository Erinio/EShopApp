package qa.udst.eshop.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Transient;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Data
@Document(collection = "products")
public class Product {
    @Id
    private String id;
    private String name;
    private String description;
    private double price;
    private int stock;
    private String imageUrl;
    @JsonIgnore
    private String categoryId;
    @Transient
    private String category;
}
