package lushertest.dao;

/**
 * Пол (гендерная принадлежность) пользователя.
 * Для удобства манипуляции - в коде сервера - в виде enum.
 * В БД через конвертер {@link GenderTypeConverter} хранится в виде целого числа начиная с 1.
 */
public enum Gender {
    male,
    female
}
