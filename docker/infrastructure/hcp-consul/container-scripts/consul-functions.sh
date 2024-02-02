#!/bin/bash -ue
# ******************************************************************************
# Functions that helps to manage HashiCorp Consul.
#
# Since : October, 2023
# Author: Arnold Somogyi <arnold.somogyi@gmail.com>
#
# Copyright (c) 2020-2023 Remal Software and Arnold Somogyi All rights reserved
# ******************************************************************************
. /shared.sh

# ----------------------------------------------------------------------------
# Configure the HashiCorp Consul.
# It generates the Consul configuration file.
# ------------------------------------------------------------------------------
function setup_consul() {
  local template_config_file config_file fqdn
  template_config_file="$CONSUL_CONFIG_TEMPLATE_DIR/consul-template.json"
  config_file="$CONSUL_CONFIG_DIR/consul.json"
  fqdn=$(hostname -f)

  printf "%s | [INFO]  starting HashiCorp Consul...\n" "$(date +"%Y-%b-%d %H:%M:%S")"
  printf "%s | [DEBUG]    config directory: \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_CONFIG_DIR"
  printf "%s | [DEBUG]    config template:  \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$template_config_file"
  printf "%s | [DEBUG]    config file:      \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$config_file"
  printf "%s | [DEBUG]    data directory:   \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_DATA_DIR"
  printf "%s | [DEBUG]    node name:        \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$CONSUL_NODE_NAME"
  printf "%s | [DEBUG]    keystore home:    \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$KEYSTORE_HOME"
  printf "%s | [DEBUG]    fqdn:             \"%s\"\n" "$(date +"%Y-%b-%d %H:%M:%S")" "$fqdn"

  mkdir -p "$CONSUL_CONFIG_DIR"
  cp -f "$template_config_file" "$config_file"
  sed -i "s|\${CONSUL_DATA_DIR}|$CONSUL_DATA_DIR|g" "$config_file"
  sed -i "s|\${CONSUL_NODE_NAME}|$CONSUL_NODE_NAME|g" "$config_file"
  sed -i "s|\${KEYSTORE_HOME}|$KEYSTORE_HOME|g" "$config_file"
  sed -i "s|\${FQDN}|$fqdn|g" "$config_file"
}

# ----------------------------------------------------------------------------
# Start HashiCorp Consul.
# ------------------------------------------------------------------------------
function start_consul() {
  #consul agent -config-dir "$CONSUL_CONFIG_DIR"
  # result:
  # ==> Failed to load cert/key pair: tls: failed to parse private key

  # consul \
  #   agent \
  #   -server \
  #   -ui \
  #   -bootstrap \
  ####   -advertise=127.0.0.1 \
  #   -bind=127.0.0.1 \
  #   -node="$CONSUL_NODE_NAME" \
  #   -config-dir="$CONSUL_CONFIG_DIR" \
  #   -data-dir="$CONSUL_DATA_DIR" \
  #   &

  # openssl pkey -in consul.remal.com.key -out plain.key

# agent: [core][Channel #1 SubChannel #5] grpc: addrConn.createTransport failed to connect to {Addr: "dc1-127.0.0.1:8300", ServerName: "agent-one", }. Err: connection error: desc = "transport: Error while dialing: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"


# config file
#   "enable_syslog": true,


2024-02-02T17:22:45.553Z [INFO]  agent.leader: stopped routine: routine="CA root expiration metric"
2024-02-02T17:22:45.553Z [INFO]  agent.leader: stopped routine: routine="CA signing expiration metric"
2024-02-02T17:22:45.553Z [INFO]  agent.server.autopilot: reconciliation now disabled
2024-02-02T17:22:45.553Z [WARN]  agent.server.serf.wan: serf: Shutdown without a Leave
2024-02-02T17:22:45.554Z [INFO]  agent.router.manager: shutting down
2024-02-02T17:22:45.554Z [INFO]  agent.router.manager: shutting down
2024-02-02T17:22:45.554Z [INFO]  agent: consul server down
2024-02-02T17:22:45.554Z [INFO]  agent: shutdown complete
2024-02-02T17:22:45.554Z [INFO]  agent: Stopping server: protocol=DNS address=0.0.0.0:8600 network=tcp
2024-02-02T17:22:45.554Z [INFO]  agent: Stopping server: protocol=DNS address=0.0.0.0:8600 network=udp
2024-02-02T17:22:45.554Z [INFO]  agent: Stopping server: address=[::]:8501 network=tcp protocol=https
2024-02-02T17:22:45.554Z [INFO]  agent: Waiting for endpoints to shut down
2024-02-02T17:22:45.554Z [INFO]  agent: Endpoints down
2024-02-02T17:22:45.554Z [INFO]  agent: Exit code: code=1
consul-1.17:0.0.1-remal:[root@consul.hello.com]# rmc
-bash: rmc: command not found
consul-1.17:0.0.1-remal:[root@consul.hello.com]# Connection to localhost closed by remote host.
Connection to localhost closed.
[s4dad\somoarn@a-njuy1pr7h8jx gombi]$ sshpass -p password ssh -oStrictHostKeyChecking=no root@localhost -p 13062
Welcome to Remal docker container!

consul-1.17:0.0.1-remal:[root@consul.hello.com]# consul agent -server -ui -bootstrap -bind=127.0.0.1 -node="$CONSUL_NODE_NAME" -config-dir="$CONSUL_CONFIG_DIR" -data-dir="$CONSUL_DATA_DIR"
==> Starting Consul agent...
               Version: '1.17.2'
            Build Date: '2024-01-22 16:55:18 +0000 UTC'
               Node ID: '2d1343bf-b48c-d938-8e37-e1a4eb1d9ec0'
             Node name: 'agent-one'
            Datacenter: 'dc1' (Segment: '<all>')
                Server: true (Bootstrap: true)
           Client Addr: [0.0.0.0] (HTTP: -1, HTTPS: 8501, gRPC: -1, gRPC-TLS: 8503, DNS: 8600)
          Cluster Addr: 127.0.0.1 (LAN: 8301, WAN: 8302)
     Gossip Encryption: true
      Auto-Encrypt-TLS: false
           ACL Enabled: false
     Reporting Enabled: false
    ACL Default Policy: allow
             HTTPS TLS: Verify Incoming: true, Verify Outgoing: true, Min Version: TLSv1_2
              gRPC TLS: Verify Incoming: true, Min Version: TLSv1_2
      Internal RPC TLS: Verify Incoming: true, Verify Outgoing: true (Verify Hostname: true), Min Version: TLSv1_2

==> Log data will now stream in as it occurs:

2024-02-02T17:38:58.433Z [WARN]  agent: bootstrap = true: do not enable unless necessary
2024-02-02T17:38:58.490Z [DEBUG] agent.grpc.balancer: switching server: target=consul://dc1.2d1343bf-b48c-d938-8e37-e1a4eb1d9ec0/server.dc1 from=<none> to=<none>
2024-02-02T17:38:58.501Z [WARN]  agent.auto_config: bootstrap = true: do not enable unless necessary
2024-02-02T17:38:58.526Z [INFO]  agent.server.raft: initial configuration: index=1 servers="[{Suffrage:Voter ID:2d1343bf-b48c-d938-8e37-e1a4eb1d9ec0 Address:127.0.0.1:8300}]"
2024-02-02T17:38:58.526Z [INFO]  agent.server.raft: entering follower state: follower="Node at 127.0.0.1:8300 [Follower]" leader-address= leader-id=
2024-02-02T17:38:58.527Z [INFO]  agent.server.serf.wan: serf: EventMemberJoin: agent-one.dc1 127.0.0.1
2024-02-02T17:38:58.528Z [INFO]  agent.server.serf.lan: serf: EventMemberJoin: agent-one 127.0.0.1
2024-02-02T17:38:58.528Z [INFO]  agent.router: Initializing LAN area manager
2024-02-02T17:38:58.528Z [DEBUG] agent.grpc.balancer: switching server: target=consul://dc1.2d1343bf-b48c-d938-8e37-e1a4eb1d9ec0/server.dc1 from=<none> to=dc1-127.0.0.1:8300
2024-02-02T17:38:58.529Z [INFO]  agent.server: Handled event for server in area: event=member-join server=agent-one.dc1 area=wan
2024-02-02T17:38:58.530Z [INFO]  agent.server: Adding LAN server: server="agent-one (Addr: tcp/127.0.0.1:8300) (DC: dc1)"
2024-02-02T17:38:58.533Z [INFO]  agent.server.autopilot: reconciliation now disabled
2024-02-02T17:38:58.540Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:38851 error="remote error: tls: bad certificate"
2024-02-02T17:38:58.540Z [WARN]  agent: [core][Channel #1 SubChannel #5] grpc: addrConn.createTransport failed to connect to {Addr: "dc1-127.0.0.1:8300", ServerName: "agent-one", }. Err: connection error: desc = "transport: Error while dialing: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:38:58.542Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:38:58.542Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:58817 error="remote error: tls: bad certificate"
2024-02-02T17:38:59.534Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:38:59.534Z [ERROR] agent.server.autopilot: Error when computing next state: error="context deadline exceeded"
2024-02-02T17:38:59.534Z [DEBUG] agent.server.autopilot: autopilot is now running
2024-02-02T17:38:59.534Z [INFO]  agent.server.cert-manager: initialized server certificate management
2024-02-02T17:38:59.534Z [DEBUG] agent.hcp_manager: HCP manager starting
2024-02-02T17:38:59.534Z [DEBUG] agent.server.autopilot: state update routine is now running
2024-02-02T17:38:59.535Z [INFO]  agent: Started DNS server: address=0.0.0.0:8600 network=tcp
2024-02-02T17:38:59.535Z [INFO]  agent: Started DNS server: address=0.0.0.0:8600 network=udp
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/demo/v2/album/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/mesh/v2beta1/computedproxyconfiguration/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/catalog/v2beta1/healthstatus/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/demo/v1/recordlabel/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/mesh/v2beta1/proxyconfiguration/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/mesh/v2beta1/tcproute/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/catalog/v2beta1/node/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/tenancy/v1alpha1/namespace/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/demo/v1/executive/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/demo/v1/concept/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/mesh/v2beta1/computedroutes/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/catalog/v2beta1/failoverpolicy/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/auth/v2beta1/trafficpermissions/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/demo/v1/album/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/mesh/v2beta1/destinations/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/demo/v2/artist/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/mesh/v2beta1/computedexplicitdestinations/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/mesh/v2beta1/proxystatetemplate/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/mesh/v2beta1/grpcroute/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/mesh/v2beta1/destinationpolicy/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/catalog/v2beta1/workload/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/catalog/v2beta1/service/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/auth/v2beta1/computedtrafficpermissions/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/internal/v1/tombstone/
2024-02-02T17:38:59.535Z [INFO]  agent.http: Registered resource endpoint: endpoint=/demo/v1/artist/
2024-02-02T17:38:59.536Z [INFO]  agent.http: Registered resource endpoint: endpoint=/catalog/v2beta1/serviceendpoints/
2024-02-02T17:38:59.536Z [INFO]  agent.http: Registered resource endpoint: endpoint=/auth/v2beta1/workloadidentity/
2024-02-02T17:38:59.536Z [INFO]  agent.http: Registered resource endpoint: endpoint=/mesh/v2beta1/httproute/
2024-02-02T17:38:59.536Z [INFO]  agent: Starting server: address=[::]:8501 network=tcp protocol=https
2024-02-02T17:38:59.536Z [INFO]  agent: Started gRPC listeners: port_name=grpc_tls address=[::]:8503 network=tcp
2024-02-02T17:38:59.536Z [INFO]  agent: started state syncer
2024-02-02T17:38:59.536Z [INFO]  agent: Consul agent running!
2024-02-02T17:39:00.535Z [DEBUG] agent.server.cert-manager: CA has not finished initializing
2024-02-02T17:39:01.535Z [DEBUG] agent.server.cert-manager: CA has not finished initializing
2024-02-02T17:39:01.555Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:01.555Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:34139 error="remote error: tls: bad certificate"
2024-02-02T17:39:02.536Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:02.536Z [DEBUG] agent.server.cert-manager: CA has not finished initializing
2024-02-02T17:39:03.536Z [DEBUG] agent.server.cert-manager: CA has not finished initializing
2024-02-02T17:39:03.542Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:35807 error="remote error: tls: bad certificate"
2024-02-02T17:39:03.542Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:04.302Z [WARN]  agent.server.raft: heartbeat timeout reached, starting election: last-leader-addr= last-leader-id=
2024-02-02T17:39:04.302Z [INFO]  agent.server.raft: entering candidate state: node="Node at 127.0.0.1:8300 [Candidate]" term=2
2024-02-02T17:39:04.304Z [DEBUG] agent.server.raft: voting for self: term=2 id=2d1343bf-b48c-d938-8e37-e1a4eb1d9ec0
2024-02-02T17:39:04.307Z [DEBUG] agent.server.raft: calculated votes needed: needed=1 term=2
2024-02-02T17:39:04.307Z [DEBUG] agent.server.raft: vote granted: from=2d1343bf-b48c-d938-8e37-e1a4eb1d9ec0 term=2 tally=1
2024-02-02T17:39:04.307Z [INFO]  agent.server.raft: election won: term=2 tally=1
2024-02-02T17:39:04.307Z [INFO]  agent.server.raft: entering leader state: leader="Node at 127.0.0.1:8300 [Leader]"
2024-02-02T17:39:04.307Z [DEBUG] agent.hcp_manager: HCP triggering status update
2024-02-02T17:39:04.307Z [INFO]  agent.server: cluster leadership acquired
2024-02-02T17:39:04.307Z [DEBUG] agent.controller-runtime: controller running: managed_type=internal.v1.Tombstone
2024-02-02T17:39:04.308Z [INFO]  agent.server: New leader elected: payload=agent-one
2024-02-02T17:39:04.312Z [INFO]  agent.server.autopilot: reconciliation now enabled
2024-02-02T17:39:04.312Z [INFO]  agent.leader: started routine: routine="federation state anti-entropy"
2024-02-02T17:39:04.312Z [INFO]  agent.leader: started routine: routine="federation state pruning"
2024-02-02T17:39:04.312Z [INFO]  agent.leader: started routine: routine="streaming peering resources"
2024-02-02T17:39:04.312Z [INFO]  agent.leader: started routine: routine="metrics for streaming peering resources"
2024-02-02T17:39:04.312Z [INFO]  agent.leader: started routine: routine="peering deferred deletion"
2024-02-02T17:39:04.319Z [DEBUG] connect.ca.consul: consul CA provider configured: id=fb:50:9b:45:1a:65:15:c1:68:57:73:5f:da:cd:b8:0d:0f:e2:26:eb:68:66:43:11:85:9d:67:a9:7a:56:9c:b9 is_primary=true
2024-02-02T17:39:04.338Z [INFO]  connect.ca: updated root certificates from primary datacenter
2024-02-02T17:39:04.338Z [INFO]  connect.ca: initialized primary datacenter CA with provider: provider=consul
2024-02-02T17:39:04.338Z [INFO]  agent.leader: started routine: routine="intermediate cert renew watch"
2024-02-02T17:39:04.338Z [INFO]  agent.leader: started routine: routine="CA root pruning"
2024-02-02T17:39:04.338Z [INFO]  agent.leader: started routine: routine="CA root expiration metric"
2024-02-02T17:39:04.338Z [INFO]  agent.leader: started routine: routine="CA signing expiration metric"
2024-02-02T17:39:04.338Z [INFO]  agent.leader: started routine: routine="virtual IP version check"
2024-02-02T17:39:04.338Z [INFO]  agent.leader: started routine: routine="config entry controllers"
2024-02-02T17:39:04.340Z [DEBUG] agent.server: successfully established leadership: duration=29.961336ms
2024-02-02T17:39:04.341Z [INFO]  agent.server: member joined, marking health alive: member=agent-one partition=default
2024-02-02T17:39:04.349Z [DEBUG] agent.server.xds_capacity_controller: updating drain rate limit: rate_limit=1
2024-02-02T17:39:04.349Z [INFO]  agent.leader: stopping routine: routine="virtual IP version check"
2024-02-02T17:39:04.349Z [INFO]  agent.leader: stopped routine: routine="virtual IP version check"
2024-02-02T17:39:04.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:04.536Z [DEBUG] agent.server.cert-manager: CA config watch fired - updating auto TLS server name: name=server.dc1.peering.26caaf09-81c8-e316-dfc3-52e357ef7431.consul
2024-02-02T17:39:04.754Z [INFO]  agent.server: federation state anti-entropy synced
2024-02-02T17:39:04.783Z [DEBUG] agent.server.cert-manager: got cache update event: correlationID=leaf error=<nil>
2024-02-02T17:39:04.783Z [DEBUG] agent.server.cert-manager: leaf certificate watch fired - updating auto TLS certificate: uri=spiffe://26caaf09-81c8-e316-dfc3-52e357ef7431.consul/agent/server/dc/dc1
2024-02-02T17:39:05.543Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:47979 error="remote error: tls: bad certificate"
2024-02-02T17:39:05.543Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:06.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:06.908Z [DEBUG] agent: Skipping remote check since it is managed automatically: check=serfHealth
2024-02-02T17:39:06.910Z [INFO]  agent: Synced node info
2024-02-02T17:39:06.910Z [DEBUG] agent: Node info in sync
2024-02-02T17:39:07.544Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:07.544Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:59287 error="remote error: tls: bad certificate"
2024-02-02T17:39:08.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:08.750Z [DEBUG] agent: Skipping remote check since it is managed automatically: check=serfHealth
2024-02-02T17:39:08.750Z [DEBUG] agent: Node info in sync
2024-02-02T17:39:09.541Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:38385 error="remote error: tls: bad certificate"
2024-02-02T17:39:09.541Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:10.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:11.543Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:11.543Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:35475 error="remote error: tls: bad certificate"
2024-02-02T17:39:12.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:13.544Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:36803 error="remote error: tls: bad certificate"
2024-02-02T17:39:13.544Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:14.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:15.543Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:45213 error="remote error: tls: bad certificate"
2024-02-02T17:39:15.543Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:16.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:17.542Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:41683 error="remote error: tls: bad certificate"
2024-02-02T17:39:17.542Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:18.536Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:19.543Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:48761 error="remote error: tls: bad certificate"
2024-02-02T17:39:19.543Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:20.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:21.543Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:33231 error="remote error: tls: bad certificate"
2024-02-02T17:39:21.543Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:22.536Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:23.542Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:36349 error="remote error: tls: bad certificate"
2024-02-02T17:39:23.542Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:24.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:25.542Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:39699 error="remote error: tls: bad certificate"
2024-02-02T17:39:25.542Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:26.536Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:27.549Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:38905 error="remote error: tls: bad certificate"
2024-02-02T17:39:27.549Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:28.536Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:29.542Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:47795 error="remote error: tls: bad certificate"
2024-02-02T17:39:29.543Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:30.534Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:31.542Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:60277 error="remote error: tls: bad certificate"
2024-02-02T17:39:31.542Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:32.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:33.547Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:33.547Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:48803 error="remote error: tls: bad certificate"
2024-02-02T17:39:34.536Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:35.550Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:35.550Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:40209 error="remote error: tls: bad certificate"
2024-02-02T17:39:36.535Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:37.548Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:37.548Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:32935 error="remote error: tls: bad certificate"
2024-02-02T17:39:38.537Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:39.542Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:34285 error="remote error: tls: bad certificate"
2024-02-02T17:39:39.542Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:40.536Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:41.550Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
2024-02-02T17:39:41.550Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:49141 error="remote error: tls: bad certificate"
2024-02-02T17:39:42.536Z [WARN]  agent: error getting server health from server: server=agent-one error="context deadline exceeded"
2024-02-02T17:39:43.541Z [ERROR] agent.server.rpc: failed to read byte: conn=from=127.0.0.1:58865 error="remote error: tls: bad certificate"
2024-02-02T17:39:43.541Z [WARN]  agent: error getting server health from server: server=agent-one error="rpc error getting client: failed to get conn: tls: failed to verify certificate: x509: certificate is valid for consul.hello.com, not server.dc1.consul"
^C2024-02-02T17:39:43.958Z [INFO]  agent: Caught: signal=interrupt
2024-02-02T17:39:43.958Z [INFO]  agent: Graceful shutdown disabled. Exiting
2024-02-02T17:39:43.958Z [INFO]  agent: Requesting shutdown
2024-02-02T17:39:43.958Z [INFO]  agent.server: shutting down server
2024-02-02T17:39:43.958Z [INFO]  agent.leader: stopping routine: routine="CA root pruning"
2024-02-02T17:39:43.958Z [INFO]  agent.leader: stopping routine: routine="CA signing expiration metric"
2024-02-02T17:39:43.958Z [INFO]  agent.leader: stopping routine: routine="config entry controllers"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="federation state anti-entropy"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="intermediate cert renew watch"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="metrics for streaming peering resources"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="peering deferred deletion"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="CA root expiration metric"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="federation state pruning"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="streaming peering resources"
2024-02-02T17:39:43.959Z [WARN]  agent.server.serf.lan: serf: Shutdown without a Leave
2024-02-02T17:39:43.959Z [DEBUG] agent.server.usage_metrics: usage metrics reporter shutting down
2024-02-02T17:39:43.959Z [ERROR] agent.server: error performing anti-entropy sync of federation state: error="context canceled"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopped routine: routine="federation state anti-entropy"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="peering deferred deletion"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="federation state pruning"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="streaming peering resources"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="metrics for streaming peering resources"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="intermediate cert renew watch"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="CA root pruning"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="CA root expiration metric"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="CA signing expiration metric"
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopping routine: routine="config entry controllers"
2024-02-02T17:39:43.959Z [INFO]  agent.server.autopilot: reconciliation now disabled
2024-02-02T17:39:43.959Z [WARN]  agent: error getting server health from server: server=agent-one error="context canceled"
2024-02-02T17:39:43.959Z [ERROR] agent.server.autopilot: Error when computing next state: error="context canceled"
2024-02-02T17:39:43.959Z [DEBUG] agent.server.autopilot: state update routine is now stopped
2024-02-02T17:39:43.959Z [INFO]  agent.leader: stopped routine: routine="CA root pruning"
2024-02-02T17:39:43.960Z [INFO]  agent.leader: stopped routine: routine="intermediate cert renew watch"
2024-02-02T17:39:43.960Z [INFO]  agent.server.peering_metrics: stopping peering metrics
2024-02-02T17:39:43.960Z [INFO]  agent.leader: stopped routine: routine="streaming peering resources"
2024-02-02T17:39:43.960Z [INFO]  agent.leader: stopped routine: routine="config entry controllers"
2024-02-02T17:39:43.960Z [INFO]  agent.leader: stopped routine: routine="CA signing expiration metric"
2024-02-02T17:39:43.960Z [INFO]  agent.leader: stopped routine: routine="CA root expiration metric"
2024-02-02T17:39:43.960Z [INFO]  agent.leader: stopped routine: routine="federation state pruning"
2024-02-02T17:39:43.960Z [WARN]  agent.controller-runtime: error received from watch: managed_type=internal.v1.Tombstone error="rpc error: code = Canceled desc = context canceled"
2024-02-02T17:39:43.960Z [DEBUG] agent.controller-runtime: controller stopping: managed_type=internal.v1.Tombstone
2024-02-02T17:39:43.960Z [DEBUG] agent.server.autopilot: autopilot is now stopped
2024-02-02T17:39:43.960Z [INFO]  agent.leader: stopped routine: routine="peering deferred deletion"
2024-02-02T17:39:43.960Z [INFO]  agent.leader: stopped routine: routine="metrics for streaming peering resources"
2024-02-02T17:39:43.961Z [WARN]  agent.server.serf.wan: serf: Shutdown without a Leave
2024-02-02T17:39:43.961Z [INFO]  agent.router.manager: shutting down
2024-02-02T17:39:43.961Z [INFO]  agent.router.manager: shutting down
2024-02-02T17:39:43.961Z [INFO]  agent: consul server down
2024-02-02T17:39:43.961Z [INFO]  agent: shutdown complete
2024-02-02T17:39:43.961Z [INFO]  agent: Stopping server: protocol=DNS address=0.0.0.0:8600 network=tcp
2024-02-02T17:39:43.961Z [DEBUG] agent.server.cert-manager: context canceled
2024-02-02T17:39:43.961Z [INFO]  agent: Stopping server: protocol=DNS address=0.0.0.0:8600 network=udp
2024-02-02T17:39:43.962Z [INFO]  agent: Stopping server: address=[::]:8501 network=tcp protocol=https
2024-02-02T17:39:43.962Z [INFO]  agent: Waiting for endpoints to shut down
2024-02-02T17:39:43.962Z [INFO]  agent: Endpoints down
2024-02-02T17:39:43.962Z [INFO]  agent: Exit code: code=1


  while [ "$(consul members 2>/dev/null | awk "/$CONSUL_NODE_NAME/ && /alive/" | wc -l)" -ne 1 ]; do
    echo "consul is not running, waiting..."
    sleep 0.5
  done

  printf "%s | [INFO]  HashiCorp Consul has been started\n" "$(date +"%Y-%b-%d %H:%M:%S")"
}
