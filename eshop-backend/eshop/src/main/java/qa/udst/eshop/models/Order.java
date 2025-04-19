package qa.udst.eshop.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Document(collection = "orders")
public class Order {
    @Id
    private String id;
    private String userId;
    private List<OrderItem> items;
    private double total;
    private String status;
    private LocalDateTime createdAt;
    private Address shippingAddress;
    private String paymentMethod;
    private String trackingNumber;
    private String courier;
    private String deliveryStatus; // IN_TRANSIT, DELIVERED, etc.
    private LocalDateTime estimatedDeliveryDate;
    private LocalDateTime deliveredAt;
    private List<TrackingUpdate> trackingHistory;
}
