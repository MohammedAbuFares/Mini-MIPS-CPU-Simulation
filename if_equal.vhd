library ieee;
use ieee.std_logic_1164.all;


--This entity is to compared operands and generate high signal if they are NOT equal 
entity if_equal is 
  
  port ( 
  
  A : in STD_LOGIC_VECTOR (31 downto 0);
  B : in STD_LOGIC_VECTOR (31 downto 0);
  C : out STD_logic);
            
  end if_equal;
  
  architecture behavioral of if_equal is 
  
  begin 
    
  process (A,B) begin
      
    if (A /= B) then 
    
    C <= '1';
    
  else 
  
  C <= '0';
  
end if;
end process;
end behavioral;
 
       
       
       