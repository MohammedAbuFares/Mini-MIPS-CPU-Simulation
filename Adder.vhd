library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

--This entity is required to add two 32 bits operands for branch address calculation 

entity adderD is 
  
  port ( 
  
  A : in  STD_LOGIC_VECTOR  (31 downto 0);
  B : in  STD_LOGIC_VECTOR  (31 downto 0);
  C : out STD_LOGIC_VECTOR  (31 downto 0)
  
  );
            
  end adderD;
  
  architecture behavioral of adderD is 
    
    begin 
      
      
      C <= A+B;
      
    end behavioral;
    
