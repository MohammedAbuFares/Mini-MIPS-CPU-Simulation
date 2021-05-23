library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

--This entity is for shifting left by 2 bits

entity shifter is
  
port (    
  
  X  : in  std_logic_vector(31 downto 0);
  Y  : out std_logic_vector(31 downto 0)
  
  );
  
end shifter;

--Begin Architecture

architecture behavioral of shifter is

begin

  Y <= X(29 downto 0) & "00";
  


end behavioral;