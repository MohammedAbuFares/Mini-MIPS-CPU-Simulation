 library ieee;
 use ieee.std_logic_1164.all;
 --use ieee.numeric_std.all;
 use IEEE.STD_LOGIC_SIGNED.ALL;
 
 --This entity is to take 2's compliment if we have ALU result ending with 1.. because without this.. when we convert to integer to be used in data memory, it will show 
 -- a negative value, and we cannot have negative number for the array 
 
 entity twos_comp is 
   
   port 
   
   (
   
   ALU_resultM : in std_logic_vector (31 downto 0) := (others => '0'); 
   output      : out std_logic_vector (31 downto 0) := (others => '0')
   
   );
   
   
 end twos_comp;
 
 
 architecture behavior of twos_comp is 
 
 
 signal loaded  : std_logic_vector(31 downto 0);
 
 
 begin 
 
 
 
 process(ALU_resultM,loaded) is 
   
   begin 
     
     if (ALU_resultM(31) = '1') then 
       
       loaded <= not(ALU_resultM) + 1;
       
       output <=loaded;
       
     else 
       
       output <= ALU_resultM;
       
       
     end if;
   end process;
     
   end behavior; 
   
   
   
