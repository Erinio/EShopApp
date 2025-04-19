package qa.udst.eshop.models;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class TrackingUpdate {
    private LocalDateTime timestamp;
    private String status;
    private String location;
    private String description;
}
