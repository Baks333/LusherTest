package lushertest.dto;

import lombok.EqualsAndHashCode;
import lombok.Value;


@Value
@EqualsAndHashCode(of = "email")
public class UserBriefInfo {


    String email;

    String fullName;
}
