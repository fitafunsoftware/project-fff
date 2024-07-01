# LocalServerDiscovery
A group of nodes meant to help with finding servers on a local network.

## LocalServerBraodcaster
Node meant to broadcast server info to any clients searching. Despite the name, the server listens
for new connections and sends packets to connections that ask for server info.

## LocalServerDiscoverer
Node meant to discover servers on the local network. Despite the name, the client broadcasts a
search packet which receives a response from any LocalServerBroadcasters that receive it.
