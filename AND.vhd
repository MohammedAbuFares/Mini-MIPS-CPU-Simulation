library IEEE;
use IEEE.std_logic_1164.all;

-- AND gate used in ID to AND BranchD with the result from if_equal

entity and_gate is

    port(A : in std_logic;      
         B : in std_logic;      
         C : out std_logic);    

end and_gate;



architecture behavior of and_gate is

 begin
    
    C <= A AND B;

end behavior; 
