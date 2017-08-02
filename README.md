## Introduction

Easily provision 3 DSE Cassandra nodes with Opscenter across 4 VMs using Ansible with Vagrant & Virtualbox. Provisioning possible no Windows host too (ansible playbooks run from controller linux virtual host).

## Prerequisites

Make sure all of these are up-to-date.

* [Virtualbox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/downloads)
* [Ansible](http://docs.ansible.com/intro_installation.html)

## Provisioning

Clone the project: ```git clone <...>```

In the project directory enter: ```vagrant up```

Your cluster will be ready shortly depending on your internet connection. The initial boot takes some time as Ansible has to download, install and configure DataStax Enterprise across each VM. Subsequent reboots are fast.

DSE and Opscenter will be automatically configured and started once installed. They will also be automatically started each time the VMs are booted.

Nodes will be running on: ```192.168.50.21```, ```192.168.50.22```, ```192.168.50.23```

Opscenter will be running on: ```192.168.50.33:8888```

Select manage existing cluster and install agents automatically, then enter ```vagrant``` for both the username and password.

SSH into a node with: ```vagrant ssh <nodename>```

CQLSH example ```cqlsh 192.168.50.21```

Shutdown the VMs: ```vagrant halt```

Resume VMs: ```vagrant up```

Destroy the VMs (requires re-provisioning): ```vagrant destroy```

Vagrants plugins and additions:

```bash
vagrant plugin list
vagrant-guest_ansible (0.0.3)
vagrant-share (1.1.9, system)
vagrant-vbguest (0.14.2)
```
Load data schema:

```cqlsh -f /vagrant/cassandra-bulkload-example/schema.cql   192.168.50.21 9042```

Prepare and load custom data:

```wget https://query1.finance.yahoo.com/v7/finance/download/AAPL?period1=345416400&period2=1499806800&interval=1d&events=history&crumb=eyvNS4FSdMB```

```wget https://query1.finance.yahoo.com/v7/finance/download/GOOG?period1=1092862800&period2=1499806800&interval=1d&events=history&crumb=eyvNS4FSdMB```

```pip install panda```

Python code:

```python
import pandas as pd
import os

os.listdir()
# ['AAPL.csv', 'GOOG.csv']

file = 'AAPL.csv'
df = pd.read_csv(file)
df.insert(0, 'ticker' ,'AAPL')
# df["Date"] = df["Date"] + " 00:00:00-05:00"
df.to_csv(file, index = False)

file = 'GOOG.csv' 
df = pd.read_csv(file)
df.insert(0, 'ticker', 'GOOG')
# df["Date"] = df["Date"] + " 00:00:00-05:00"
df.to_csv(file, index = False)
```

```bash
cqlsh 192.168.50.21 9042
cqlsh:quote> COPY historical_prices FROM '../AAPL.csv' WITH DATETIMEFORMAT='%Y-%m-%d';
cqlsh:quote> COPY historical_prices FROM '../GOOG.csv' WITH DATETIMEFORMAT='%Y-%m-%d';
```

Stress tests:

```cassandra-stress write -node 192.168.50.21```

```cassandra-stress write n=200000 -pop seq=1..200000 -rate threads=200 -node 192.168.50.23```

```cassandra-stress mixed n=200000 -pop seq=1..200000 -rate threads=200 -node 192.168.50.23```

```bash
cassandra-stress write n=500000 -pop seq=1..500000 -rate threads=500 -node 192.168.50.21
cassandra-stress read  n=500000 -pop seq=1..500000 -rate threads=500 -node 192.168.50.21

cassandra-stress write n=500000 -pop seq=1..500000 -rate threads=500 -node 192.168.50.22 
cassandra-stress read  n=500000 -pop seq=1..500000 -rate threads=500 -node 192.168.50.22

cassandra-stress write n=500000 -pop seq=1..500000 -rate threads=500 -node 192.168.50.23
cassandra-stress read  n=500000 -pop seq=1..500000 -rate threads=500 -node 192.168.50.23
```

```bash
nodetool tpstats
Pool Name                         Active   Pending      Completed   Blocked  All time blocked
...
Native-Transport-Requests              0         0        4957375         0               673
...
```

Using socat for JMX port exposing:

```bash
root@node1:~# apt install socat
Reading package lists... Done
Building dependency tree       
Reading state information... Done
socat is already the newest version (1.7.3.1-1).
0 upgraded, 0 newly installed, 0 to remove and 37 not upgraded.
root@node1:~# socat TCP-LISTEN:7199,fork TCP:192.168.50.22:5555
2017/07/20 09:46:43 socat[29520] E bind(5, {AF=2 0.0.0.0:7199}, 16): Address already in use
root@node1:~# socat TCP-LISTEN:5555,fork TCP:127.0.0.1:7199
```

Using jmxterm for JMX testing:

```bash
wget https://sourceforge.net/projects/cyclops-group/files/jmxterm/1.0-alpha-4/jmxterm-1.0-alpha-4-uber.jar/download
mv download jmxterm.jar
java -jar jmxterm.jar 
Welcome to JMX terminal. Type "help" for available commands.
$>open 192.168.50.21:5555
#Connection to 192.168.50.21:5555 is opened
$>beans
...
```


