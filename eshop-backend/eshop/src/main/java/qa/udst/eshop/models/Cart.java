package qa.udst.eshop.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;
import lombok.Data;
import java.util.List;

@Data
@Document(collection = "carts")
public class Cart {
    @Id
    private String id;
    
    @Indexed(unique = true)
    private String userId;
    
    private List<CartItem> items;
    private double total;
}
