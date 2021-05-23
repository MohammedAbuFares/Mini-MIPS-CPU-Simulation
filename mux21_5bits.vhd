library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--This entity is a mux for destination address and choose between Rt and Rd

entity Dst_mux2_1 is
  
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (4 downto 0);
           B   : in  STD_LOGIC_VECTOR (4 downto 0);
           X   : out STD_LOGIC_VECTOR (4 downto 0));
           
end Dst_mux2_1;


architecture Behavioral of Dst_mux2_1 is
  
begin
  
    X <= A when (SEL = '0') else B;
    
end Behavioral;
