package lushertest.dao;

import javax.persistence.Converter;

import lushertest.dao.base.EnumToIdConverter;

/**
 * Класс для преобразования пола пользователя {@link Gender} в целое (от 1) и обратно
 * для хранения значения пола в БД в виде целого числа.
 */
@Converter(autoApply = true)
public class GenderTypeConverter extends EnumToIdConverter<Gender> {

    public GenderTypeConverter() {
        super(Gender.class);
    }
}
