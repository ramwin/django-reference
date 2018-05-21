**Xiang Wang @ 2018-05-21 16:53:05**

# Menu
* [django](./README.md)
    * the model layer
        * [Making Queries Official Documents](./makeing_queries.md); [My History Document](./queries.md)
        * [QuerySet method reference]() [My History Document](./queries.md)
        * [Lookup expressions](lookup_expressions.md)

# [When Querysets Are Evaluated](https://docs.djangoproject.com/en/2.0/ref/models/querysets/#when-querysets-are-evaluated)
# [QuerySet API](https://docs.djangoproject.com/en/2.0/ref/models/querysets/#queryset-api)
## Methods that return new Querysets
## Methods that do not return Querysets
## [Field lookups](https://docs.djangoproject.com/en/2.1/ref/models/querysets/#field-lookups)
* date:  
When `USE_TZ` is True, fields are converted to the current time zone before filtering.  
`Entry.objects.filter(pub_date__date=datetime.date(2005, 1, 1))`  
But the date is filtered by the date of server timezone. What if you want to filter the date create by customer living in other timezone district? I find the only way is to use time range.
