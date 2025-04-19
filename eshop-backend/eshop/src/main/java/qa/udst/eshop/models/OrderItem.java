package qa.udst.eshop.models;

import lombok.Data;

@Data
public class OrderItem {
    private String productId;
    private int quantity;
    private double price;
    private String productName;
    private String productImage;
}
