library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--This entity is to complete the 16 bits from instruction to 32 bits


entity sign_ext is 
  
  
    port ( 
    
    A : in std_logic_vector(15 downto 0);
    B : out std_logic_vector(31 downto 0));
    
end sign_ext;

architecture behavioral of sign_ext is 

begin
  
    process (A)
      
begin
    
    
    B(15 downto 0) <= A;
    B(31 downto 16) <= (31 downto 16 => A(15));
    
end process;   
  
end behavioral;
