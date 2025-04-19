package qa.udst.eshop.models;

import lombok.Data;

@Data
public class CartItem {
    private String productId;
    private int quantity;
    private double price;
}
