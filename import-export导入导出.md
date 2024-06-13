# django-import-export 导入导出功能

[官网](https://django-import-export.readthedocs.io/en/latest/)
[github](https://github.com/django-import-export/django-import-export)

## Resource
* 源码剖析
  ```
  def import_date():
      import_data_inner
  def import_data_inner
      instance_loader = instance_loaders.ModelInstanceLoader
      instance_loader = self._meta.instance_loader_class(self, dataset)
      row_result = self.import_row(
          row, instance_loader, ...
      )
  def import_row(self, row):
      self.before_import(row, **kwargs)
      instance, new = self.get_or_init_instance(instance_loader, row)
      self.import_obj(instance, row, dry_run)
      self.save_instance(instance, using_transactions, dry_run)
      self.save_m2m(instance, row, using_transactions, dry_run)
  def get_or_init_instance(self, instance_loader, row):
      instance = self.get_instance(instance_loader, row)
      if instance:
          return (instance, False)
      else:
          return (self.init_instance(row), True)
  def init_instance(self, row)
      return self._meta.model()  # ModelResource
      raise NotImplementedError()
  def import_obj(self, obj, data, dry_run):
      for field:
          self.import_field(field, obj, data)
  def import_field(self, field, obj, data, is_m2m=False):
      if field.attribute and field.column_name in data:
          field.save(obj, data, is_m2m)  # 看下面的Field.save
  def save_instance(self, instance, using_transactions=True, dry_run=False):
      self.before_save_instance(instance, using_transactions, dry_unr)
      if not using_transactions and dry_run:
          # we don't have transactions and we want to do a dry_run
          pass
      else:
          instance.save()
      self.after_save_instance(instance, using_transactions, dry_run)
  ```
* `Resource.get_instance`
只有在`get_instance`以后,才会用field的clean方法获取object
  ```
  def get_instance(self, instance_loader, row):
      import_id_fields = [
          self.fields[f] for f in self.get_import_id_fields()
      ]
      for field in import_id_fields:
          if field.column_name not in row:
              return
      return instance_loader.get_instance(row)
  ```

## [Field](https://django-import-export.readthedocs.io/en/stable/api_fields.html)
* 因为源码里是用`__`来split的,注意
  ```
  from import_export.fields import Field
  class Field:
      def clean(self, data):
          """
          Translates the value stored in the imported datasource to an
          appropriate Python object and returns it.
          """
          try:
              value = data[self.column_name]
          except KeyError:
              raise KeyError("Column '%s' not found in dataset. Available "
                             "columns are: %s" % (self.column_name, list(data)))

          # If ValueError is raised here, import_obj() will handle it
          value = self.widget.clean(value, row=data)

          if value in self.empty_values and self.default != NOT_PROVIDED:
              if callable(self.default):
                  return self.default()
              return self.default

          return value
      def save(self, obj, data, is_m2m=False):
          if not self.readonly:
              attrs = self.attribute.split("__")
              for attr in attrs[:-1]:
                  obj = getattr(obj, attr, None)
              cleaned = self.clean(data)
              if cleaned is not None or self.saves_null_values:
                  if not is_m2m:
                      setattr(obj, attrs[-1], cleaned)
                  else:
                      getattr(obj, attrs[-1]).set(cleaned)
      def export(self, obj):
          value = self.get_value(obj)
          if value is None:
              return ""
          return self.widget.render(value, obj)
      def get_value(self, obj):
          attrs = self.attribute.splic("__")
          value = obj
          for attr in attrs:
              value = getattr(value, attr, None)
          return value
  ```

## ModelInstanceLoader
* 源码剖析
  ```
  def get_instance(self, row):  # 用来修改数据的
      for key in self.resource.get_import_id_fields():
          field = self.resource.fields[key]
          params[field.attribute] = field.clean(row)
  ```

