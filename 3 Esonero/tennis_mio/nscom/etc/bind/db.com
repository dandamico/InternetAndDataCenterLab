$TTL   60000
@               IN      SOA     nscom.com.    root.nscom.com. (
                        2006031201 ; serial
                        28800 ; refresh
                        14400 ; retry
                        3600000 ; expire
                        0 ; negative cache ttl
                        )
@                       IN      NS      nscom.com.
nscom.com.               IN      A       20.1.0.3

web.com.     IN      A       2.2.0.2
