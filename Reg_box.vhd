library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

--This entity is the register file that holds operands 


entity reg_box is
  
  
  port (
    
    
      Clock   : in std_logic;
      En_WB   : in std_logic := '0';  
      Operand1: in std_logic_vector(4 downto 0) := (others => '0');
      Operand2: in std_logic_vector(4 downto 0) := (others => '0');
      WB_DST  : in std_logic_vector(4 downto 0) := (others => '0'); 
      WB_DATA : in std_logic_vector(31 downto 0) := (others => '0');
      
      Output_oper1: out std_logic_vector(31 downto 0) := (others => '0');
      Output_oper2: out std_logic_vector(31 downto 0) := (others => '0')
      
    );
    
  end reg_box;
  
  --Begin Architecture
  
architecture behavior of reg_box is
    
type Registers is array(0 to 31) of std_logic_vector(31 downto 0);
  
signal   Reg: Registers := (others => (others => '0'));
    
    
    
   begin
     
     Output_oper1 <= Reg(to_integer(unsigned(Operand1)));
     Output_oper2 <= Reg(to_integer(unsigned(Operand2)));
           
      process(Clock) is
        
      begin
        
              
                 Reg(5) <= X"00000003";  -- Decimal 3    00000000000000000000000000000011
                 Reg(6) <= X"00000015";  -- Decimal 21   00000000000000000000000000010101
                                         -- XNOR 3,21    11111111111111111111111111101001
                
                 
                 Reg(12) <= X"0000001E";  -- Decimal 30  00000000000000000000000000011110
                 Reg(13) <= X"00000028";  -- Decimal 40  00000000000000000000000000101000
                                          -- NAND 30,40  11111111111111111111111111110111
                                          
                 Reg(10) <= X"00000107"; -- Decimal of 263                         
                 Reg(11) <= X"00000001";
                 
                 Reg(24) <= X"00000018"; --Decimal of 24
                                   
                 
       
                     
        if (rising_edge(Clock)) then  
        if (En_WB = '1') then 
           
          Reg(to_integer(unsigned(WB_DST))) <= WB_DATA;
          
        end if;
        end if;
        
      end process;
      
    
  
      
      
    end behavior;
