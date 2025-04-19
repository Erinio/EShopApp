package qa.udst.eshop.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Data;

@Data
@Document(collection = "addresses")
public class Address {
    @Id
    private String id;
    private String userId;
    private String name;
    private String street;
    private String city;
    private String state;
    private String country;
    private String zipCode;
    private String phone;
    private boolean isDefault;
}
