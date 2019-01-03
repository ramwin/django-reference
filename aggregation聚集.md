**Xiang Wang @ 2018-11-27 14:22:07**

### aggregation
* models
    ```
    from django.db import models

    class Author(models.Model):  # 作者
        name = models.CharField(max_length=100)
        age = models.IntegerField()

    class Publisher(models.Model):  # 出版商
        name = models.CharField(max_length=300)

    class Book(models.Model):  # 几个作者一起出一本书, 在一个出版商卖
        name = models.CharField(max_length=300)
        pages = models.IntegerField()
        price = models.DecimalField(max_digits=10, decimal_places=2)
        rating = models.FloatField()
        authors = models.ManyToManyField(Author)
        publisher = models.ForeignKey(Publisher, on_delete=models.CASCADE)
        pubdate = models.DateField()

    class Store(models.Model):  # 一个卖各种书的书店
        name = models.CharField(max_length=300)
        books = models.ManyToManyField(Book)
    ```

#### Cheat Sheet
    ```
    from django.db.models import Avg
    Book.objects.all().aggregate(Avg('price'))
    above_5 = Count('book', filter=Q(book__rating__gt=5))
    below_5 = Count('book', filter=Q(book__rating__lte=5))
    pubs = Publisher.objects.annotate(below_5=below_5).annotate(above_5=above_5)
    pubs[0].above_5
    ```

#### Generating aggregates over a QuerySet
#### Generating aggregates for each item in a QuerySet
* Combining multiple aggregations

#### Joins and aggregates

#### Aggregations and other QuerySet clauses
