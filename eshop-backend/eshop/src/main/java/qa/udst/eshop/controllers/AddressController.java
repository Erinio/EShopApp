package qa.udst.eshop.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import qa.udst.eshop.models.Address;
import qa.udst.eshop.services.AddressService;
import java.util.List;

@RestController
@RequestMapping("/api/addresses")
public class AddressController {
    private final AddressService addressService;

    public AddressController(AddressService addressService) {
        this.addressService = addressService;
    }

    @PostMapping
    public ResponseEntity<Address> addAddress(@RequestBody Address address) {
        return ResponseEntity.ok(addressService.addAddress(address));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Address>> getUserAddresses(@PathVariable String userId) {
        return ResponseEntity.ok(addressService.getUserAddresses(userId));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Address> updateAddress(
            @PathVariable String id,
            @RequestBody Address address) {
        try {
            Address updated = addressService.updateAddress(id, address);
            if (updated != null) {
                return ResponseEntity.ok(updated);
            }
            return ResponseEntity.notFound().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteAddress(
            @PathVariable String id,
            @RequestParam String userId) {
                //System.out.println("Deleting address, " + id + " userId, " + userId);
        if (addressService.deleteAddress(id, userId)) {
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }
}
