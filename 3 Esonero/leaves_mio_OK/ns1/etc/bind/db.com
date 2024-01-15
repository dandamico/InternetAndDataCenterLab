$TTL   60000
@               IN      SOA     ns1.com.    root.ns1.com. (
                        2006031201 ; serial
                        28800 ; refresh
                        14400 ; retry
                        3600000 ; expire
                        0 ; negative cache ttl
                        )
@                       IN      NS      ns1.com.
ns1.com.               IN      A       100.0.0.3

site.com.     IN      A       100.0.0.2
