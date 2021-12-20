package lushertest.dto;

import java.time.Instant;
import java.util.HashSet;
import java.util.Set;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Представление записи о результате одного теста. DTO.
 */
@Getter
@RequiredArgsConstructor
public class TestResult {

    /**
     * метка времени сохранения результата
     */
    private final Instant created;

    /**
     * набор текстовых расшифровок результата теста
     */
    Set<String> descriptions = new HashSet<>();
}
