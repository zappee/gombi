# Remal Image: HashiCorp Consul

Login to container:
~~~
sshpass -p password ssh -oStrictHostKeyChecking=no root@consul.hello.com -p 13062
~~~

List of the opened ports on localhost:
~~~
netstat -tulpn | grep LISTEN
~~~

Check if a port is open on a remote machine
~~~
nc -zvw10 consul.hello.com 22
~~~

<a href="https://trackgit.com">
  <img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/lcfhkdub7k2lpj33n2cl" alt="trackgit-views" />
</a>

| consul                                                                                                                                                           | easy rsa |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| Create a Certificate Authority<br/>`consul tls ca create`                                                                                                        |          |
| Create individual Server Certificates<br/>`consul tls cert create -server -ca=consul-agent-ca.pem -dc=dc1 -domain=consul.hello.com -key=consul-agent-ca-key.pem` |          |
|                                                                                                                                                                  |          |

