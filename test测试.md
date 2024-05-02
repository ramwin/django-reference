# Writting and running tests [官网][run test]

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

# Included testing tools [官网][test tools]
## The test client
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

## TestCase
### [overriding settings](https://docs.djangoproject.com/en/4.1/topics/testing/tools/#overriding-settings)
```python
from django.test import TestCase, override_settings

class LoginTestCase(TestCase):
    with self.settings(LOGIN_URL='/other/login/'):
        ...

    with self.modify_settings(MIDDLEWARE={
        "append": "插入的",
        "prepend": "前面插入的",
        "remove": [...], # 删除的
    }):
        ...
    @override_settings(LOGIN_URL="")
    def test_login(self):
        ...
```
### assertNumQueries

```
with self.assertNumQueries(2):  # 可以用在验证Prefetch是否实现
    Person.objects.create(name="Alice")
    Person.objects.create(name="Bob")
with self.assertNumQueries(2):  # 可以用在验证Prefetch是否实现
    client.get("/customer/?page=1")
```

### fixtures

[官网](https://docs.djangoproject.com/en/5.0/topics/testing/tools/#fixture-loading)

fixture的保存也会触发所有的signal

```python
class MyTest(TestCase):
    fixtures = ["students.json", "lesson.json.gz"]
```

# Advanced topics

[run test]: https://docs.djangoproject.com/en/5.0/topics/testing/overview/#running-tests
[test tools]: https://docs.djangoproject.com/en/5.0/topics/testing/tools/
