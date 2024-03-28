# 基础
    from django.core.exceptions import ValidationError
    from django.core import validators

# 直接使用
    validators.validate_email("ramwin@qq.com")

# model使用
    def validate_even(value):
        if value %2 != 0:
            raise ValidationError(
                _('%(value)s is not an even number'),
                params= {'value': value},
            )
    class MyModel(models.Model):
        even_field = models.IntegerField(validators=[validate_even])
    a = MyModel(even_field=1)
    a.full_clean()
