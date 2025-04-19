package qa.udst.eshop.services;

import org.springframework.stereotype.Service;
import qa.udst.eshop.models.Cart;
import qa.udst.eshop.models.CartItem;
import qa.udst.eshop.repositories.CartRepository;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CartService {
    private final CartRepository cartRepository;

    public CartService(CartRepository cartRepository) {
        this.cartRepository = cartRepository;
    }

    @Transactional
    public Cart saveCart(Cart cart) {
        // Delete existing cart if any
        cartRepository.findByUserId(cart.getUserId())
            .ifPresent(existingCart -> cartRepository.deleteByUserId(existingCart.getUserId()));
        
        // Save new cart
        return cartRepository.save(cart);
    }

    @Transactional
    public Cart updateCart(Cart cart) {
        // Calculate total
        double total = cart.getItems().stream()
                .mapToDouble(item -> item.getPrice() * item.getQuantity())
                .sum();
        cart.setTotal(total);
        
        // Save and return updated cart
        return saveCart(cart);
    }

    public Cart getCartByUserId(String userId) {
        return cartRepository.findByUserId(userId)
            .orElse(new Cart());
    }
}
