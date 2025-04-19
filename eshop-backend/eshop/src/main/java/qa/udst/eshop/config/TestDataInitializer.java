package qa.udst.eshop.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import qa.udst.eshop.models.Product;
import qa.udst.eshop.models.User;
import qa.udst.eshop.models.Category;
import qa.udst.eshop.services.ProductService;
import qa.udst.eshop.services.UserService;
import qa.udst.eshop.services.CategoryService;
import qa.udst.eshop.models.*;
import qa.udst.eshop.services.*;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.ArrayList;

@Configuration
public class TestDataInitializer {

    @Bean
    @Profile("!prod")
    CommandLineRunner initDatabase(
            UserService userService, 
            ProductService productService, 
            CategoryService categoryService,
            AddressService addressService,
            CartService cartService,
            OrderService orderService) {
        return args -> {
            // Check if data already exists
            if (userService.findByUsername("admin") == null) {
                // Create test admin user
                User admin = new User();
                admin.setUsername("admin");
                admin.setEmail("admin@example.com");
                admin.setPassword("admin123");
                admin.setRole("ADMIN");
                userService.createUser(admin);

                // Create test regular user
                User user = new User();
                user.setUsername("user");
                user.setEmail("user@example.com");
                user.setPassword("user123");
                user.setRole("USER");
                User savedUser = userService.createUser(user);

                // Create test addresses with actual user ID
                Address homeAddress = new Address();
                homeAddress.setUserId(savedUser.getId());
                homeAddress.setName("Home");
                homeAddress.setStreet("123 Main St");
                homeAddress.setCity("Doha");
                homeAddress.setState("Doha");
                homeAddress.setCountry("Qatar");
                homeAddress.setZipCode("12345");
                homeAddress.setPhone("+974 1234 5678");
                homeAddress.setDefault(true);
                addressService.addAddress(homeAddress);

                Address workAddress = new Address();
                workAddress.setUserId(savedUser.getId());
                workAddress.setName("Work");
                workAddress.setStreet("456 Business Ave");
                workAddress.setCity("Doha");
                workAddress.setState("Doha");
                workAddress.setCountry("Qatar");
                workAddress.setZipCode("12346");
                workAddress.setPhone("+974 9876 5432");
                workAddress.setDefault(false);
                addressService.addAddress(workAddress);

                // Create categories and products first
                Product iphone = null;
                if (productService.getAllProducts().isEmpty()) {
                    // Create categories
                    Category electronics = createCategory("Electronics", "Mobile phones, Notebooks, Smart watches and accessories");
                    Category sports = createCategory("Sports", "");
                    Category books = createCategory("Books", "");
                    Category clothing = createCategory("Clothing", "");
                    Category home = createCategory("Home", "");

                    // Save categories first
                    categoryService.createCategory(home);
                    categoryService.createCategory(electronics);
                    categoryService.createCategory(sports);
                    categoryService.createCategory(books);
                    categoryService.createCategory(clothing);

                    // Create products array
                    Product[] products = {
                        // Store iPhone reference for cart/order
                        iphone = createProduct("iPhone 13 Pro", "6.1-inch Super Retina XDR display with ProMotion, A15 Bionic chip, Pro camera system", 999.99, 10, 
                            "https://www.apple.com/newsroom/images/product/iphone/geo/Apple_iPhone-13-Pro_iPhone-13-Pro-Max_GEO_09142021_inline.jpg.large.jpg", 
                            electronics.getId()),
                        createProduct("MacBook Air", "Apple M1 chip, 13.3-inch Retina display, 8GB RAM, 256GB SSD", 1299.99, 15, 
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxxf9KSspquSN0P2oj88kIo1cBm-vRWGXM5g&s", electronics.getId()),
                        createProduct("Nike Air Max", "Comfortable running shoes with Air cushioning", 129.99, 20, 
                            "https://xcdn.next.co.uk/common/items/default/default/itemimages/3_4Ratio/product/lge/A69343s.jpg?im=Resize,width=750", sports.getId()),
                        createProduct("The Great Gatsby", "The Great Gatsby is a novel by American writer F. Scott Fitzgerald. Set in the Jazz Age on Long Island, near New York City, the novel depicts first-person narrator Nick Carraway's interactions with mysterious millionaire Jay Gatsby and Gatsby's obsession to reunite with his former lover, Daisy Buchanan.", 9.99, 10,
                            "https://m.media-amazon.com/images/M/MV5BMTkxNTk1ODcxNl5BMl5BanBnXkFtZTcwMDI1OTMzOQ@@._V1_.jpg", books.getId()),
                        createProduct("Leather Jacket", "A leather jacket is a jacket-length coat that is usually worn on top of other apparel or item of clothing, and made from the tanned hide of various animals. The leather material is typically dyed black, or various shades of brown, but a wide range of colors is possible.", 199.99, 5,
                            "https://images-cdn.ubuy.qa/6540c7e498a72815b453244b-decrum-hooded-leather-jacket-men.jpg", clothing.getId()),
                        createProduct("T-shirt", "A comfortable cotton t-shirt available in various colors.", 19.99, 50,
                            "https://threadheads.com.au/cdn/shop/files/HideThePainHarold-CustomDesign-Mockup_2e627725-7d34-43d5-ac86-f5c66a684cf6--Edited.jpg?v=1733879198&width=2048", clothing.getId()),
                        createProduct("Smart TV", "A Smart TV with 4K resolution and streaming capabilities.", 799.99, 8,
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQxjSMuPk3XKOt5E5mshLjPnhxYZnF3dNiMDQ&s", electronics.getId()),
                        createProduct("Coffee Table", "A coffee table is a low table designed to be placed in a sitting area for convenient support of beverages, remote controls, magazines, books, decorative objects, and other small items.", 99.99, 10,
                            "https://sfycdn.speedsize.com/19bba31a-6c36-4510-aa4c-90e87768362d/https://www.williamwoodmirrors.co.uk/cdn/shop/files/Angelo_Rectangular_Concrete_Coffee_Table_Large_ac51f604-a398-4e74-82b5-c61594e0f6de_1800x.jpg?v=1718782173", home.getId()),
                        createProduct("Airpods Pro 2", "AirPods Pro deliver Active Noise Cancellation, Transparency mode, and spatial audio — in a customizable fit.", 249.99, 15,
                            "https://www.tccq.com/image/cache/catalog/1900180/Apple-Airpods-Pro-2nd-generation-with-MagSafe-Charging-Case-Lighting-MQD83-in-Qatar-600x600.jpg", electronics.getId()),
                        createProduct("Samsung Galaxy S21", "The Samsung Galaxy S21 is a series of Android-based smartphones designed, developed, marketed, and manufactured by Samsung Electronics as part of its Galaxy S series.", 799.99, 10,
                            "https://static.alaneesqatar.qa/2021/01/s21-256-grey-2.png", electronics.getId())
                    };

                    // Save all products
                    Arrays.stream(products).forEach(productService::createProduct);
                }

                // Create cart and order only if we have products
                if (iphone != null) {
                    // Create test cart with actual product
                    Cart userCart = new Cart();
                    userCart.setUserId(savedUser.getId());
                    userCart.setItems(new ArrayList<>());
                    
                    CartItem cartItem = new CartItem();
                    cartItem.setProductId(iphone.getId());  // Use actual product ID
                    cartItem.setQuantity(2);
                    cartItem.setPrice(iphone.getPrice());   // Use actual product price
                    userCart.getItems().add(cartItem);
                    cartService.saveCart(userCart);

                    // Create test order with actual product
                    if (orderService.getUserOrders(savedUser.getId()).isEmpty()) {
                        Address userAddress = addressService.getDefaultAddress(savedUser.getId());
                        Order order = new Order();
                        order.setUserId(savedUser.getId());
                        order.setShippingAddress(userAddress);
                        order.setStatus("DELIVERED");
                        order.setCreatedAt(LocalDateTime.now().minusDays(7));
                        order.setPaymentMethod("CREDIT_CARD");
                        order.setTotal(999.99);
                        
                        OrderItem orderItem = new OrderItem();
                        orderItem.setProductId(iphone.getId());    // Use actual product ID
                        orderItem.setQuantity(1);
                        orderItem.setPrice(iphone.getPrice());     // Use actual product price
                        orderItem.setProductName(iphone.getName()); // Use actual product name
                        order.setItems(Arrays.asList(orderItem));

                        // Add tracking information
                        order.setTrackingNumber("QR123456789");
                        order.setCourier("Qatar Post");
                        order.setDeliveryStatus("DELIVERED");
                        order.setDeliveredAt(LocalDateTime.now().minusDays(1));

                        TrackingUpdate update1 = new TrackingUpdate();
                        update1.setStatus("IN_TRANSIT");
                        update1.setLocation("Doha Hub");
                        update1.setDescription("Package has arrived at sorting facility");
                        update1.setTimestamp(LocalDateTime.now().minusDays(3));

                        TrackingUpdate update2 = new TrackingUpdate();
                        update2.setStatus("DELIVERED");
                        update2.setLocation("Destination");
                        update2.setDescription("Package has been delivered");
                        update2.setTimestamp(LocalDateTime.now().minusDays(1));

                        order.setTrackingHistory(Arrays.asList(update1, update2));
                        orderService.createOrderFromCart(savedUser.getId(), userAddress.getId(), "CREDIT_CARD");
                    }
                }
            } else {
                System.out.println("Users already exist in the database");
            }
        };
    }

    private Category createCategory(String name, String description) {
        Category category = new Category();
        category.setName(name);
        category.setDescription(description);
        return category;
    }

    private Product createProduct(String name, String description, double price, int stock, String imageUrl, String categoryId) {
        Product product = new Product();
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setStock(stock);
        product.setImageUrl(imageUrl);
        product.setCategoryId(categoryId);
        return product;
    }
}
