### Goal:

Create something similar to network weathermap, with the ability to trace path to certain device.

#### Flow:

- create device
- add physical interfaces
- add virtual aggregator interfaces with physical interface members
- add i2i map (link between two interfaces)
- all interfaces inside device are linked together (switch)
- later add vlans with interface membership

#### Notes:

- by default every device is multipoint
- there can be devices connected together with more than one phy interface, but with different vlans
- when tracing user must choose start dev and end dev;
- tracing from end dev to start dev will show current route;
- tracing from start dev to end dev will show all possible routes;
  
