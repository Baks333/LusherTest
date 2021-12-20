package lushertest.dto;

import java.time.Instant;
import java.time.LocalDate;

import lombok.EqualsAndHashCode;
import lombok.Value;
import lushertest.dao.Gender;


@Value
@EqualsAndHashCode
public class UserDetailedInfo {

    Instant created;

    String fullName;

    Gender gender;

    LocalDate birthday;

    String email;

}
