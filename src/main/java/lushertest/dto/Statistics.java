package lushertest.dto;

import java.time.Instant;
import java.util.HashSet;
import java.util.Set;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Представление статистики по одной паре результата. DTO.
 */
@Getter
@AllArgsConstructor
public class Statistics {

    /**
     * пара цветов в её текстовом представлении по Люшеру (4 знака вида +8+1)
     */
    private final String pair;

    /**
     * количество таких пар в БД
     */
    private final Long count;
}
