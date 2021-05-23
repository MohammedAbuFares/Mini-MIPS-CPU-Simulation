library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- This Component is required to make the calculation of J ... we shift the Target value of J instruction by 2 .. and then replace it with the lower 28 bits of the PC
-- So jump_new_address = { PC[31:28] , target, 00 }
-- Target is the [26:0] of the J instruction 


entity J_calc is 
  
  port (
  
  Instruction : in STD_LOGIC_VECTOR (25 downto 0);
  PC_4D       : in STD_LOGIC_VECTOR (31 downto 0); 
  
  J_address   : out STD_LOGIC_VECTOR (31 downto 0)
  
);


end J_calc;


architecture behavioral of J_calc is 

 
  
signal temp,temp2       : unsigned (25  downto 0); 
signal temp3,temp4      : STD_LOGIC_VECTOR (27 downto 0);

begin
  
  
--  temp <= unsigned (Instruction);
  
--  temp2 <= (temp sll 2);                      
  
 -- temp3 <= STD_LOGIC_VECTOR( "00" & temp2);   --000010 00000000000000000000001010
  
  --OR WE CAN USE LINE NUM 45
  
  temp4 <= instruction(25 downto 0) & "00";
  
  
  J_address <= PC_4D (31 downto 28) & temp4;
  
  
end behavioral; 


 
  
  
  
  


    
