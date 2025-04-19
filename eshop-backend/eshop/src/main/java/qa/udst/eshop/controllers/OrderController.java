package qa.udst.eshop.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import qa.udst.eshop.models.Order;
import qa.udst.eshop.models.TrackingUpdate;
import qa.udst.eshop.services.OrderService;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
public class OrderController {
    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping
    public ResponseEntity<Order> createOrder(@RequestBody Map<String, String> orderRequest) {
        Order order = orderService.createOrderFromCart(
            orderRequest.get("userId"),
            orderRequest.get("shippingAddress"),
            orderRequest.get("paymentMethod")
        );
        return ResponseEntity.ok(order);
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Order>> getUserOrders(@PathVariable String userId) {
        return ResponseEntity.ok(orderService.getUserOrders(userId));
    }

    @GetMapping("/{orderId}")
    public ResponseEntity<Order> getOrder(@PathVariable String orderId) {
        Order order = orderService.getOrder(orderId);
        return order != null ? ResponseEntity.ok(order) : ResponseEntity.notFound().build();
    }

    @PutMapping("/{orderId}/status")
    public ResponseEntity<Order> updateOrderStatus(
            @PathVariable String orderId,
            @RequestBody Map<String, String> statusUpdate) {
        Order updated = orderService.updateOrderStatus(orderId, statusUpdate.get("status"));
        return updated != null ? ResponseEntity.ok(updated) : ResponseEntity.notFound().build();
    }

    @PutMapping("/{orderId}/tracking")
    public ResponseEntity<Order> updateTracking(
            @PathVariable String orderId,
            @RequestBody Map<String, String> trackingInfo) {
        Order updated = orderService.updateTracking(
            orderId,
            trackingInfo.get("trackingNumber"),
            trackingInfo.get("courier")
        );
        return updated != null ? ResponseEntity.ok(updated) : ResponseEntity.notFound().build();
    }

    @PostMapping("/{orderId}/tracking/updates")
    public ResponseEntity<Order> addTrackingUpdate(
            @PathVariable String orderId,
            @RequestBody TrackingUpdate update) {
        Order updated = orderService.addTrackingUpdate(orderId, update);
        return updated != null ? ResponseEntity.ok(updated) : ResponseEntity.notFound().build();
    }
}
