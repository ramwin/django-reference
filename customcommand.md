# customcommand

[官网][custom_command]

## 案例
mkdir -p app/management/commands/
```
from django.core.management.base import BaseCommand, CommandError
from polls.models import Question as Poll

class Command(BaseCommand):
    help = 'Closes the specified poll for voting'

    def add_arguments(self, parser):
        """
        add_argument以后，不管传不传, kwargs里都有这个。值可能是None
        """
        parser.add_argument('poll_id', nargs='+', type=int)
        parser.add_argument('-max', type=int, default=150, help="一次性推送允许的最多人数")  #  带有默认值的参数. 可以传可以不传
        parser.add_argument("-n", "--no-act", action="store_true", help="只是看看，不进行操作")  # store_true以后不会有None, 要么True要么False

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

## [手动调用][call_command]
call_command会把命令保存在一个字典里，然后用importlib去调用。所以
1. 不会导致重新遍历文件
2. 不会导致重新import
```
from django.core.management import call_command
call_command(命令名字)
```


## 美化输出
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

## 源码分析
* [ ] 继续查看Loader的原理  

```
python3 manage.py sqlmigrate testapp 0002

# core/management/__init__.py
argv = ['manage.py', 'sqlmigrate', 'testapp', '0002']
def execute_from_command_line(argv=None):
    """Run a ManagementUtility."""
    utility = ManagementUtility(argv)
    utility.execute()

# core/management/__init__.py
class ManagementUtility:
    def execute(self):
        subcommand = self.argv[1]
            self.fetch_command(subcommand).run_from_argv(self.argv)

    def fetch_command(self, subcommand):
        commands = get_commands()
        app_name = commands[subcommand]
        # django.core.sqlmigrate
        klass = load_command_class(app_name, subcommand)
        return klass
fetch_command就是返回的Command了

# core/managements/command/sqlmigrate.py
class Command(BaseCommand):
    def run_from_argv(self, argv):
        self.execute(*args, **cmd_options)
    def execute(self):
        self.handle()
    def handle(self, *args, **options):
        plan = [(loader.graph.nodes[target], options['backwards'])]
        # plan:  [(<Migration testapp.0002_auto_20200422_1247>, False)]
        sql_statements = executor.collect_sql(plan)  # 这句最关键
        # sql_statements:
        ['--',
         '-- Alter field name on mymodel',
         '--',
         'CREATE TABLE "new__testapp_mymodel" ("id" integer NOT NULL PRIMARY KEY '
         'AUTOINCREMENT, "name" varchar(32) NOT NULL UNIQUE);',
         'INSERT INTO "new__testapp_mymodel" ("id", "name") SELECT "id", "name" FROM '
         '"testapp_mymodel";',
         'DROP TABLE "testapp_mymodel";',
         'ALTER TABLE "new__testapp_mymodel" RENAME TO "testapp_mymodel";',
         'CREATE UNIQUE INDEX "testapp_mymodel_name_ba5e2bd2_uniq" ON '
         '"testapp_mymodel" ("name");',
         '--',
         '-- Alter unique_together for mymodel (0 constraint(s))',
         '--',
         'DROP INDEX "__unnamed_constraint_1__";'
        ]
        if not sql_statements and options['verbosity'] >= 1:
            self.stderr.write('No operations found.')
        return '\n'.join(sql_statements)

# db/migrations/executor.py
class MigrationExecutor
    def collect_sql(self, plan):
        for migration, backwards in plan:
            with self.connection.schema_editor(collect_sql=True, atomic=migration.atomic) as schema_editor:
                if state is None:
                    state = self.load.project_state(...)
                if not backwards:
                    state = migration.apply(state, schema_editor, collect_sql=True)


# db/backends/base/base.py

def schema_editor(self, *args, **kwargs):
    return self.SchemaEditorClass(self, *args, **kwargs)

# db/backwards/base/schema.py

# db/migrations/migration.py
def apply(self, project_state, schema_editor, collect_sql=False):
    for operation in self.operations:
          
```


[custom_command]: https://docs.djangoproject.com/en/4.2/howto/custom-management-commands/
[call_command]: https://docs.djangoproject.com/en/4.2/ref/django-admin/#running-management-commands-from-your-code
