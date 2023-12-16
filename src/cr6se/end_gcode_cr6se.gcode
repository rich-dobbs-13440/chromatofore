G91; Relative positioning
G1 E-2 Z0.2 F2400; Retract and raise Z
G1 E2 Z1 F2400; Refill and raise Z
M104 S20; Increase hotend temperature by 20°C to reduce viscosity
G4 P15000; Pause for 15 seconds, to allow hot end to get to new temperature
G1 E4 Z1 F4000; extrude a squirt of molten material.
G1 E-80 F4000; Retract as fast as possible, with the idea that a void will cause the remain material in the melt zone to neck in.

G1 X5 Y5 F3000; Wipe out
G1 Z10; Raise Z more

G90; Absolute positioning

G1 X0 Y{machine_depth}; Present print
M106 S0; Turn-off fan
M104 S0; Turn-off hotend
M140 S0; Turn-off bed

M84 X Y E ; Disable all steppers but Z