# Remal Image: HashiCorp Vault

Login to container:
```
sshpass -p password ssh -oStrictHostKeyChecking=no root@vault.hello.com -p 13042
```

Processing the audit log:
```
tail -f /var/log/vault-audit.log | while read -r line; do
    echo "$line"
    echo "$line" | jq '.request.path'
    echo "$line" | jq '.request.data.data | keys[]'
    echo "$line" | jq '.response.data.data | keys[]'
done
```

<a href="https://trackgit.com">
  <img src="https://us-central1-trackgit-analytics.cloudfunctions.net/token/ping/lcfhkdub7k2lpj33n2cl" alt="trackgit-views" />
</a>
