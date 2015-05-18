
# ctng

In this directory are two different flavours of _.config_ file for creating cross-compilers for the 
Raspberry Pi or devices with the same CPU/SoC.

* armv6 is the original Raspberry Pi
* armv7 is the newer version 2 RPI

Install crosstool-ng and place the _.config_ file from the correct directory for your use and run:

	ct-ng build

To build your cross-compiler.

The path for the compiler is set to:
	/opt/toolchains/<cpu-type>

Where <cpu-type> is either _armv6_ or _armv7_.

The cross-compiler can then be used in conjunction with the _kcc_ script to build a kernel.

Of course the cross-compilers can also be used to compile other code.


