library ieee;
use ieee.std_logic_1164.all;

--This entity is to generate high signal in EX stage when we have SLL instruction to choose the Sign extended value as operand 1... ALU will pick the SHAMT bits from it

entity shamt is 

port


(

ALU_ctrl : in std_logic_vector (2 downto 0);
mux_sel  : out std_logic := '0'

);

end shamt;


architecture behavior of shamt is


begin 
  
  process (ALU_ctrl)  begin
    
    
  if (ALU_ctrl = "010") then 
  
   
   mux_sel <= '1';
   
 else 
   
   mux_sel <= '0';
   
 end if;
   
 end process;
 
 
 end behavior;
 
 
 
   
   


