G91 ;Relative positioning
G1 E-2 Z0.2 F2400 ;Retract and raise Z
G1 E2 Z0.2 F2400 ; Refill and raise Z
M104 S0 ;Turn-off hotend for tip shaping
G4 P8000 ; Pause for cool down, to try to stretch
G1 E-10 Z1.0 F4000 ; Retract a substantial amount
G4 P8000 ; Pause for milliseconds to allow tip to cool.
G1 E-10 F4000 ; Break tip

G1 X5 Y5 F3000 ;Wipe out
G1 Z10 ;Raise Z more



G90 ;Absolute positioning

G1 X0 Y{machine_depth} ;Present print
M106 S0 ;Turn-off fan
M104 S0 ;Turn-off hotend
M140 S0 ;Turn-off bed

M84 X Y E ;Disable all steppers but Z