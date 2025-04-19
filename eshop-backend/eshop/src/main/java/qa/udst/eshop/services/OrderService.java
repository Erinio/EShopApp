package qa.udst.eshop.services;

import org.springframework.stereotype.Service;
import qa.udst.eshop.models.Order;
import qa.udst.eshop.models.OrderItem;
import qa.udst.eshop.models.Product;
import qa.udst.eshop.models.TrackingUpdate;
import qa.udst.eshop.models.Cart;
import qa.udst.eshop.models.Address;
import qa.udst.eshop.repositories.OrderRepository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;
import java.util.ArrayList;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final CartService cartService;
    private final AddressService addressService;
    private final ProductService productService; // Add this

    public OrderService(OrderRepository orderRepository, CartService cartService, 
                       AddressService addressService, ProductService productService) {
        this.orderRepository = orderRepository;
        this.cartService = cartService;
        this.addressService = addressService;
        this.productService = productService;
    }

    public Order createOrderFromCart(String userId, String addressId, String paymentMethod) {
        Cart cart = cartService.getCartByUserId(userId);
        Address address = addressService.getAddressById(addressId);
        
        if (address == null || !address.getUserId().equals(userId)) {
            throw new IllegalArgumentException("Invalid address");
        }

        Order order = new Order();
        order.setUserId(userId);
        order.setItems(cart.getItems().stream()
            .map(cartItem -> {
                OrderItem orderItem = new OrderItem();
                orderItem.setProductId(cartItem.getProductId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(cartItem.getPrice());
                return orderItem;
            }).collect(Collectors.toList()));
        order.setTotal(cart.getTotal());
        order.setStatus("PENDING");
        order.setCreatedAt(LocalDateTime.now());
        order.setShippingAddress(address);
        order.setPaymentMethod(paymentMethod);

        Order savedOrder = orderRepository.save(order);
        cartService.saveCart(new Cart()); // Clear the cart
        return savedOrder;
    }

    public List<Order> getUserOrders(String userId) {
        List<Order> orders = orderRepository.findByUserId(userId);
        orders.forEach(order -> {
            order.getItems().forEach(item -> {
                Product product = productService.getProductById(item.getProductId());
                if (product != null) {
                    item.setProductName(product.getName());
                    item.setProductImage(product.getImageUrl());
                }
            });
        });
        return orders;
    }

    public Order getOrder(String orderId) {
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order != null) {
            order.getItems().forEach(item -> {
                Product product = productService.getProductById(item.getProductId());
                if (product != null) {
                    item.setProductName(product.getName());
                    item.setProductImage(product.getImageUrl());
                }
            });
        }
        return order;
    }

    public Order updateOrderStatus(String orderId, String status) {
        Order order = getOrder(orderId);
        if (order != null) {
            order.setStatus(status);
            return orderRepository.save(order);
        }
        return null;
    }

    public Order updateTracking(String orderId, String trackingNumber, String courier) {
        Order order = getOrder(orderId);
        if (order != null) {
            order.setTrackingNumber(trackingNumber);
            order.setCourier(courier);
            return orderRepository.save(order);
        }
        return null;
    }

    public Order addTrackingUpdate(String orderId, TrackingUpdate update) {
        Order order = getOrder(orderId);
        if (order != null) {
            if (order.getTrackingHistory() == null) {
                order.setTrackingHistory(new ArrayList<>());
            }
            update.setTimestamp(LocalDateTime.now());
            order.getTrackingHistory().add(update);
            order.setDeliveryStatus(update.getStatus());
            
            if ("DELIVERED".equals(update.getStatus())) {
                order.setDeliveredAt(LocalDateTime.now());
            }
            
            return orderRepository.save(order);
        }
        return null;
    }
}
