**Xiang Wang @ 2018-05-21 16:53:05**

# Menu
* [django](./README.md)
    * the model layer
        * [Making Queries Official Documents](./makeing_queries.md); [My History Document](./queries.md)
        * [QuerySet method reference]() [My History Document](./queries.md)
        * [Lookup expressions](lookup_expressions.md)

# [When Querysets Are Evaluated](https://docs.djangoproject.com/en/2.0/ref/models/querysets/#when-querysets-are-evaluated)

# [QuerySet API](https://docs.djangoproject.com/en/2.0/ref/models/querysets/#queryset-api)

## Methods that return new Querysets 返回Queryset的方法
* defer
`Entry.objects.defer("body")`: only access the body field when you use the `body` field to optimize the performance

## Methods that do not return Querysets 不返回Queryset的方法
`get, create, get_or_create`

## [Field lookups 查询field的方法](https://docs.djangoproject.com/en/2.1/ref/models/querysets/#field-lookups)
* exact
* iexact
* contains
* icontains
* startswith
* date:  
When `USE_TZ` is True, fields are converted to the current time zone before filtering.  
`Entry.objects.filter(pub_date__date=datetime.date(2005, 1, 1))`  
But the date is filtered by the date of server timezone. What if you want to filter the date create by customer living in other timezone district? I find the only way is to use time range.

## [Query Expressions 查询语句](https://docs.djangoproject.com/en/2.0/ref/models/expressions/)
* Example  
	```python
	from django.db.models import Count, F, Value
	from django.db.models.functions import Length, Upper

	# Find companies that have more employees than chairs. 找到职工比凳子多的公司
	# F 把表的某个值当作判断
	Company.objects.filter(num_employees__gt=F('num_chairs'))

	# Find companies that have at least twice as many employees
	# as chairs. Both the querysets below are equivalent.
	# 找到员工数比椅子两倍还多的公司
	Company.objects.filter(num_employees__gt=F('num_chairs') * 2)
	Company.objects.filter(
		num_employees__gt=F('num_chairs') + F('num_chairs'))

	# How many chairs are needed for each company to seat all employees?
	# 添加每个公司还需要多少椅子的信息
	>>> company = Company.objects.filter(
	...    num_employees__gt=F('num_chairs')).annotate(
	...    chairs_needed=F('num_employees') - F('num_chairs')).first()
	>>> company.num_employees
	120
	>>> company.num_chairs
	50
	>>> company.chairs_needed
	70

	# Create a new company using expressions.
	>>> company = Company.objects.create(name='Google', ticker=Upper(Value('goog')))
	# Be sure to refresh it if you need to access the field.
	>>> company.refresh_from_db()
	>>> company.ticker
	'GOOG'

	# Annotate models with an aggregated value. Both forms
	# below are equivalent.
	Company.objects.annotate(num_products=Count('products'))
	Company.objects.annotate(num_products=Count(F('products')))

	# Aggregates can contain complex computations also
	Company.objects.annotate(num_offerings=Count(F('products') + F('services')))

	# Expressions can also be used in order_by()
	Company.objects.order_by(Length('name').asc())
	Company.objects.order_by(Length('name').desc())
	```
* [ ] Build-in Expressions
