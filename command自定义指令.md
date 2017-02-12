#### Xiang Wang @ 2017-02-09 13:49:33


# 基础
* [教程](https://docs.djangoproject.com/en/1.10/howto/custom-management-commands/#accepting-optional-arguments)

```
    from django.core.management.base import BaseCommand, CommandError
    from polls.models import Question as Poll

    class Command(BaseCommand):
        help = 'Closes the specified poll for voting'

        def add_arguments(self, parser):
            parser.add_argument('poll_id', nargs='+', type=int)

        def handle(self, *args, **options):
            for poll_id in options['poll_id']:
                try:
                    poll = Poll.objects.get(pk=poll_id)
                except Poll.DoesNotExist:
                    raise CommandError('Poll "%s" does not exist' % poll_id)

                poll.opened = False
                poll.save()

                self.stdout.write(self.style.SUCCESS('Successfully closed poll "%s"' % poll_id))
```


## 美化输出
`self.stdout.write(self.style.SUCCESS('操作成功'))`  

![格式化输出的样式](./img/command_style.png)
