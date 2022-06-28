**Xiang Wang @ 2018-11-16 17:33:22**


**使用django的测试工具**
### Introduction
### Writting and running tests [官网](https://docs.djangoproject.com/en/2.0/topics/testing/overview/#running-tests)
* Writing tests

```
from django.test import TestCase
from myapp.models import Animal

class AnimalTestCase(TestCase):
    def setUp(self):
        Animal.objects.create(name="lion", sound="roar")
        Animal.objects.create(name="cat", sound="meow")

    def test_animals_can_speak(self):
        """Animals that can speak are correctly identified"""
        lion = Animal.objects.get(name="lion")
        cat = Animal.objects.get(name="cat")
        self.assertEqual(lion.speak(), 'The lion says "roar"')
        self.assertEqual(cat.speak(), 'The cat says "meow"')
```

### Included testing tools [官网](https://docs.djangoproject.com/en/2.1/topics/testing/tools/)
#### The test client
* example

```
>>> from django.test import Client
>>> c = client()
>>> response = c.post('/login/', {'username': 'john', 'password': 'smith'})
>>> response.status_code
200
>>> response = c.get('/customer/details')
>>> response.content
>>> b'<!DOCTYPE html...'
```

#### TestCase
* assertNumQueries

    ```
    with self.assertNumQueries(2):  # 可以用在验证Prefetch是否实现
        Person.objects.create(name="Alice")
        Person.objects.create(name="Bob")
    with self.assertNumQueries(2):  # 可以用在验证Prefetch是否实现
        client.get("/customer/?page=1")
    ```


### Advanced topics
