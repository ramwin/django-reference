**Xiang Wang @ 2017-02-09 13:49:33**

[官网](https://docs.djangoproject.com/en/2.2/howto/custom-management-commands/)

#### 案例
mkdir -p app/management/commands/
```
from django.core.management.base import BaseCommand, CommandError
from polls.models import Question as Poll

class Command(BaseCommand):
    help = 'Closes the specified poll for voting'

    def add_arguments(self, parser):
        parser.add_argument('poll_id', nargs='+', type=int)
        parser.add_argument('-max', type=int, default=150, help="一次性推送允许的最多人数")  #  带有默认值的参数. 可以传可以不传
        parser.add_argument("-n", "--no-act", action="store_true", help="只是看看，不进行操作")

    def handle(self, *args, **options):
        if options.get("no_act"):
            print("我只看看，不操作")
            return

        assert isInstance(options["max"], int)
        for poll_id in options['poll_id']:
            try:
                poll = Poll.objects.get(pk=poll_id)
            except Poll.DoesNotExist:
                raise CommandError('Poll "%s" does not exist' % poll_id)

            poll.opened = False
            poll.save()

            self.stdout.write(self.style.SUCCESS('Successfully closed poll "%s"' % poll_id))
```


#### 美化输出
自定义指令里使用:  
`self.stdout.write(self.style.SUCCESS('operate success'))`  
view里面使用:  
```
from django.core.management.base import OutputWrapper
from django.core.management.color import color_style
out = OutputWrapper(sys.stdout)
style = color_style()
out.write(style.SUCCESS(serializer.data))
```
各个样式:  
![the style of output](./img/command_style.png)
