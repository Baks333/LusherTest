package lushertest.service;

import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

import lushertest.dao.Gender;

import static lushertest.service.TestResultService.*;

/**
 * Сервис для проверки корректности различных данных.
 */
@Service
public class DataValidatorService {

    private static final int MIN_PASSWORD_LENGTH = 3;


    public Optional<String> validateStringValue(@Nullable final String value) {
        // всё ок, если непустое значение после убирания лишних пробелов в начале и конце строки
        if (value == null)
            return Optional.empty();

        final String result = value.trim();
        if (result.isEmpty())
            return Optional.empty();

        return Optional.of(result);
    }


    public boolean passwordValid(@Nullable final String value) {
        return value != null && value.length() >= MIN_PASSWORD_LENGTH;
    }


    public Optional<String> validateEmail(@Nullable final String email) {

        return validateStringValue(email);
    }

    public Optional<Gender> validateGender(@Nullable final Gender value) {

        return Optional.ofNullable(value);
    }

    public Optional<LocalDate> validateBirthday(@Nullable final LocalDate value) {

        return Optional.ofNullable(value);
    }


    public boolean testResultValid(@Nullable final String testResult) {

        if (testResult == null || testResult.length() != COLORS_COUNT)
            return false;

        final Set<Character> foundChars = new HashSet<>();

        for (int i = 0; i < COLORS_COUNT; i++) {
            char c = testResult.charAt(i);

            // все знаки во входной строке результата должны быть цифрами от MIN_CHAR (обычно - '1') до кол-ва цветов
            if (c < MIN_CHAR || c >= (MIN_CHAR + COLORS_COUNT))
                return false;


            if (foundChars.contains(c))
                return false;

            foundChars.add(c);
        }

        return true;
    }

}
