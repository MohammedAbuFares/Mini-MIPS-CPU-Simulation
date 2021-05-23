library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--This entity is a mux to choose between two 32 bits data

entity mux2_1 is
  
    port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (31 downto 0);
           B   : in  STD_LOGIC_VECTOR (31 downto 0);
           X   : out STD_LOGIC_VECTOR (31 downto 0));
end mux2_1;

architecture Behavioral of mux2_1 is
  
begin
  
    X <= A when (SEL = '0') else B;
    
end Behavioral;
