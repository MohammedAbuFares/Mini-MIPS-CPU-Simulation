library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


--This mux will select the PCSrc.. So one input is for conditional instruction (BNE) and other for unconditional instruction (J and JR)


entity PCSrc_mux is
  
  
  
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC;
           B   : in  STD_LOGIC;
           X   : out STD_LOGIC
           
           );
           
end PCSrc_mux;


architecture Behavioral of PCSrc_mux is
  
begin
  
    X <= A when (SEL = '0') else B;
    
end Behavioral;
