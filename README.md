# playbook 使用文档
## 概要
该playbook分为三个role，分别为puppetserver，puppetdb，amq
对用的play文件分别为.puppetservers.yml, amq.yml, dbservers.yml
清单文件为production和stage两个文件，对应测试和生产环境（可以按需调整）

## 部署结构图
该playbook的部署结构为，单数据中心有两台puppetserver做多活集群，两台activemq做mq集群，两台puppetdb做集群，共六台服务器,具体请见puppet的应用部署架构
		
    	puppetserver1----> puppetdb01,puppetdb02
host---->		 			----> amq1|amq2
	puppetserver2----> puppetdb01,puppetdb02

## 安装puppet-server集群的具体步骤
### 1. 修改变量文件，设置对应的变量
该playbook的相关变量信息存放在 group_vars和host_vars两个目录下，请查找对应变量，按需设置具体对应值

### 2. 运行playbook，安装puppetserver集群
执行如下命令:

```
ansible-playbook -i stage|production puppetservers.yml [--tags "puppetserver"]   # 这条命令执行 puppetserver的部署
```

### 3. 运行playbook，安装puppetdb集群
执行如下命令：

```
ansible-playbook -i stage|production dbservers.yml [--tags "puppetdb"]  #执行puppetdb软件包的安装和配置

ansible-playbook -i stage|production puppetservers.yml --tags "puppetdb_validate"  #在puppetservers上激活puppetdb
```

### 4. 运行playbook，安装activemq
```
ansible-playbook -i stage|production amq.yml [--tags "amq"]  #在puppetservers上激活puppetdb
```

### 5. 运行playbook，配置mco-client
```
ansible-playbook -i stage|production puppetservers.yml --tags "mco_cli"  #在puppetservers上激活puppetdb
```

