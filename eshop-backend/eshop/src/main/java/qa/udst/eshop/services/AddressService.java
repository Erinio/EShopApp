package qa.udst.eshop.services;

import org.springframework.stereotype.Service;
import qa.udst.eshop.models.Address;
import qa.udst.eshop.repositories.AddressRepository;
import java.util.List;

@Service
public class AddressService {
    private final AddressRepository addressRepository;

    public AddressService(AddressRepository addressRepository) {
        this.addressRepository = addressRepository;
    }

    public Address addAddress(Address address) {
        if (address.isDefault()) {
            // Remove default flag from other addresses
            addressRepository.findByUserIdAndIsDefaultTrue(address.getUserId())
                .setDefault(false);
        }
        return addressRepository.save(address);
    }

    public List<Address> getUserAddresses(String userId) {
        return addressRepository.findByUserId(userId);
    }

    public Address getDefaultAddress(String userId) {
        return addressRepository.findByUserIdAndIsDefaultTrue(userId);
    }

    public Address getAddressById(String id) {
        return addressRepository.findById(id).orElse(null);
    }

    public Address updateAddress(String id, Address updatedAddress) {
        Address existingAddress = getAddressById(id);
        if (existingAddress == null) {
            return null;
        }
        
        // Verify ownership
        if (!existingAddress.getUserId().equals(updatedAddress.getUserId())) {
            throw new IllegalArgumentException("Address does not belong to user");
        }

        // Keep the existing ID
        updatedAddress.setId(id);
        
        // Handle default address changes
        if (updatedAddress.isDefault() && !existingAddress.isDefault()) {
            // Remove default flag from other addresses
            addressRepository.findByUserIdAndIsDefaultTrue(updatedAddress.getUserId())
                .setDefault(false);
        }

        return addressRepository.save(updatedAddress);
    }

    public boolean deleteAddress(String id, String userId) {
        Address address = getAddressById(id);
        if (address != null && address.getUserId().equals(userId)) {
            addressRepository.deleteById(id);
            return true;
        }
        return false;
    }
}
