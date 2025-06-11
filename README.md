# Usage
```bash
ghdl -a <filename.vhdl>
ghdl -e <entity>
ghdl -r <entity>
ghdl -r Hello_TB --wave=hello_tb.ghw
gtkwave hello_tb.ghw
```

Run `ghdl -a <filename.vhdl>` to analyze. 
This command creates or updates a file`work-obj93.cf`, which describes the library work. 

Then, run `ghdl -e <entity>` to elaborate. 

Run the simulation with `ghdl -r <entity>`.

To view the waveform use the command:
```bash
ghdl -r Hello_TB --wave=hello_tb.ghw
```

# Script

I have also crated a script for compiling everything, the script runs the above commands.

Usage:
```
./simulate.sh <filename.vhdl> <entity_name> [--wave]
```
`--wave` is an optional parameter.
