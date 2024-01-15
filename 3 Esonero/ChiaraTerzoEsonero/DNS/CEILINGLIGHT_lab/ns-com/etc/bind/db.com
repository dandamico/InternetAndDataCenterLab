@                    IN SOA ns-com.com. root.ns-com.com. 2006031201 28800 14400 3600000 0

@                    IN NS ns-com
ns-com               IN  A 1.1.0.2

eyesbook             IN NS ns-eyesbook.eyesbook
ns-eyesbook.eyesbook IN  A 1.0.0.3
