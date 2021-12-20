package lushertest.dao.base;

import java.util.Arrays;

import javax.persistence.AttributeConverter;

/**
 * Универсальный класс для преобразования любого типа enum в целое (от 1) и обратно
 * для хранения enum в БД в виде целого числа.
 * @param <E> класс enum
 */
public abstract class EnumToIdConverter<E extends Enum<E>> implements AttributeConverter<E, Long> {

    private final Class<E> clazz;

    public EnumToIdConverter(Class<E> clazz) {
        this.clazz = clazz;
    }

    @Override
    public Long convertToDatabaseColumn(E e) {
        return e == null ? 0 : (long) (e.ordinal() + 1);
    }

    @Override
    public E convertToEntityAttribute(Long id) {
        if (id == null)
            throw new IllegalArgumentException();

        return Arrays.stream(clazz.getEnumConstants())
                .filter(e -> id.equals((long) (e.ordinal() + 1)))
                .findAny()
                .orElseThrow(UnsupportedOperationException::new);
    }
}
