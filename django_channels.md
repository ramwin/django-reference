# django_channels
websocket框架

## 用户登录

## 原理
1. zadd `asgi:group:<room_name>`
保存了一个room监听的websocket的客户端

2. zadd `asgispecific.<clientid>!`
保存了每个websocket客户端应该收到的消息

## 手动添加到某个频道
```
from channels_layers import get_channel_layer
get_channel_layer().group_add(<groupname>, channel_name)
```

## 把用户加入全体用户监听频道
```
class Consumer:
    def connect:
        self.channel_layer.group_add("all_user", self.channel_name)

    def disconnect:
        self.channel_layer.group_discard("all_user", self.channel_name)
```
