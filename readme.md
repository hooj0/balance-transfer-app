# 区块链超级账本交易客户端应用

利用`Java`对接`NodeJS`的区块链接口，完成界面版本的交易场景流程。

```shell
$ cd /opt/gopath/src/github.com/hyperledger/
$ git clone https://github.com/hyperledger/fabric-samples.git

$ cd fabric-samples/balance-transfer/
```

- 启动 `docker` 服务容器编排

```
$ docker-compose -f artifacts/docker-compose.yaml up
```

- 安装`fabric-client`和`fabric-ca-client`节点模块

```
# 模块 安装当前目录下
$ npm install 
```

- 在`PORT 4000`上启动节点应用程序

```
$ PORT=4000 node app
```

[NodeJS端API参考](https://github.com/hooj0/notes/blob/master/blockchain/hyperledger/hyperledger%20fabric%20%E6%BC%94%E7%A4%BA%20Node.js%20SDK%20API.md)

官方文档和示例代码：https://github.com/hyperledger/fabric-samples/tree/release-1.2/balance-transfer

