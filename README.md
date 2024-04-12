# Processor
## NAME (NETID)
ag559

## Description of Design
I implemented all of my own custom modules to build this processor. These are the instructions it is capable of performing: add, sub, and, or, sll, sra, mul, div, sw, lw, j, bne, jal, jr, blt, bex, setx

## Bypassing
Bypassing was implemented for ALU inputs, A and B, and memory.

## Stalling
Stalls occur based on when lw happens and hazards.

## Optimizations
My multiplier uses 16, rather than 17, cycles, making the processor more efficient.

## Bugs
Not passing sort potentially due to stalling at the wrong time for lw. 
