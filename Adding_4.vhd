library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

--This entity is required to add PC to 4

entity adder is 
  
  port ( 
  
  A : in  STD_LOGIC_VECTOR  (31 downto 0);
  B : out STD_LOGIC_VECTOR  (31 downto 0)
  
  );
            
  end adder;
  
  architecture behavioral of adder is 
    
    begin 
      
      
      B <= A+4;
      
    end behavioral;
    
    
    
