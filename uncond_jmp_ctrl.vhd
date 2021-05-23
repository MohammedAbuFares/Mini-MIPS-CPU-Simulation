library ieee;
use ieee.std_logic_1164.all;


-- This component is required to give output of '1' when we have unconditional jump like in J and JR ... So, the mux of PC in IF will take the jump value 


entity jmp_uncon is 

port


(

OpCd     : in std_logic_vector (5 downto 0);
mux_sel  : out std_logic := '0'

);

end jmp_uncon;


architecture behavior of jmp_uncon is


begin 
  
  process (OpCd)  begin
    
    
  if ((OpCd = "000010") or (OpCd = "001000"))   then 
  
   
   mux_sel <= '1';
   
 else 
   
   mux_sel <= '0';
   
 end if;
   
 end process;
 
 
 end behavior;
 
