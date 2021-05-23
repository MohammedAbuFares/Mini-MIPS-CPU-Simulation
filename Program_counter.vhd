library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--This entity is the PC to hold next PC and release it when required.. it will release when EN signal is high and on falling edge

entity Program_c is
  
port (
  
    Clock  : in std_logic;
    En     : in std_logic := '1';
    PC_in  : in std_logic_vector(31 downto 0)  :=  (others => '0');
    PC_out : out std_logic_vector(31 downto 0) :=  (others => '0')
);

end Program_c;

-- Begin Architecture

architecture behavioral of Program_c is
  
  
  
begin
  

  
  process(Clock)
    
    begin
      
      if (falling_edge(Clock) and En ='1') then
        
        PC_out <= PC_in;
        
      end if;
      
    end process;  
  
end behavioral;
