package qa.udst.eshop.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import qa.udst.eshop.models.Address;
import java.util.List;

public interface AddressRepository extends MongoRepository<Address, String> {
    List<Address> findByUserId(String userId);
    Address findByUserIdAndIsDefaultTrue(String userId);
}
