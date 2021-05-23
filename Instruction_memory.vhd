library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ins_m is 
  
--This entity is for Instruction memory storage  

port

(

PC:        in std_logic_vector(31 downto 0);        
Data_out:  out std_logic_vector(31 downto 0) 

); 

end Ins_m;


architecture  behavioral of Ins_m is 

type Im_Arr is array (0 to 2000) of std_logic_vector (7 downto 0);  --CHANGE ARRAY NUMBER 

signal I: Im_Arr := (others=>(others=>'0'));

begin

--                                                                                         Instruction in Binary

I(0)   <= X"84"; I(1)  <= X"01"; I(2)  <= X"00"; I(3)  <= X"08"; --   LH R1,8(R0)       10000100000000010000000000001000
I(4)   <= X"34"; I(5)  <= X"23"; I(6)  <= X"00"; I(7)  <= X"01"; --   ORI R3,R1,1       00110100001000110000000000000001
I(8)   <= X"04"; I(9)  <= X"03"; I(10) <= X"20"; I(11) <= X"80"; --   SLL R4,R3,2       00000100000000110010000010000000
I(12)  <= X"48"; I(13)  <= X"A6"; I(14) <= X"38"; I(15) <= X"00"; --  XNOR R7,R6,R5     01001000101001100011100000000000
I(16)  <= X"34"; I(17)  <= X"68"; I(18) <= X"00"; I(19) <= X"07"; --  ADDUI R8,R3,7     00110100011010000000000000000111
I(20)  <= X"15"; I(21)  <= X"09"; I(22) <= X"00"; I(23) <= X"01"; --  BNE   R8,R9, 1    00010101000010010000000000000001

I(24)  <= X"87"; I(25)  <= X"22"; I(26) <= X"00"; I(27) <= X"0C"; -- R2,14(R25)  WILL BE SKIPPED BECAUSE OF BNE.... BUT IT WILL BE USED AT THE END IN JR TO JUMP TO IT
                                                                  --                     10000111001000100000000000001100

I(28)  <= X"1D"; I(29)  <= X"AC"; I(30) <= X"70"; I(31) <= X"00"; -- NAND  R14, R12,R13    00011101101011000111000000000000
I(32)  <= X"08"; I(33)  <= X"00"; I(34) <= X"00"; I(35) <= X"0B"; -- J 26 bit value is 11  00001000000000000000000000001011

I(36)  <= X"34"; I(37)  <= X"68"; I(38) <= X"00"; I(39) <= X"07"; --ADDUI instruciton FLUSHED AND SKIPPED
I(40)  <= X"34"; I(41)  <= X"23"; I(42) <= X"00"; I(43) <= X"01"; --ORi instruction   SKIPPED 

I(44)  <= X"A1"; I(45)  <= X"6A"; I(46) <= X"00"; I(47) <= X"0B"; -- SB     R10, 11(R11)   10100001011010100000000000001011
I(48)  <= X"C0"; I(49)  <= X"8F"; I(50) <= X"00"; I(51) <= X"06"; -- SUBI   R15, R4, 6     11000000100011110000000000000110
I(52)  <= X"23"; I(53)  <= X"00"; I(54) <= X"00"; I(55) <= X"00"; -- JR     R24, R0, 0     00100011000000000000000000000000


I(56)  <= X"C0"; I(57)  <= X"8F"; I(58) <= X"00"; I(59) <= X"06"; -- SUBI   instruction FLUSHED AND SKIPPED 
I(60)  <= X"34"; I(61)  <= X"23"; I(62) <= X"00"; I(63) <= X"01"; -- ORi    instruction   SKIPPED 
I(64)  <= X"34"; I(65)  <= X"68"; I(66) <= X"00"; I(67) <= X"07"; -- ADDUI intruction SKIPPED 



 


  
  Data_out <= I(to_integer(unsigned(PC))) & I(to_integer(unsigned(PC))+1) & I(to_integer(unsigned(PC)) +  2) & I(to_integer(unsigned(PC)) +3);

end behavioral;
