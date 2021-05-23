library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--This is the control unit in the ID  

entity ctrl_unit is

  
    Port ( 
    
    OpCd :      in STD_LOGIC_vector(5 downto 0);
    fnc  :      in STD_LOGIC_vector(5 downto 0);
    
    
    Reg_wr_D   :   out STD_LOGIC:='0';
    Mem2reg_D  :   out STD_LOGIC:='0';
    Mem_wr_D   :   out STD_LOGIC:='0';
    ALU_src_D  :   out STD_LOGIC:='0';
    Reg_dis_D  :   out STD_LOGIC:='0';    
    Brnch_D    :   out STD_LOGIC:='0';
    Jmp_D      :   out STD_LOGIC_VECTOR (1 downto 0):="00";
    
    ALU_ctrl_D :   out STD_LOGIC_VECTOR (2 downto 0):="000" 
    
    );
    
    
end ctrl_unit;

architecture behavioral of ctrl_unit is
  
  
  

begin 
  
  process(fnc,OpCd) is begin

  
    --ADDui 
    
  if (OpCd = "001101") AND (fnc = "000111")   then 
  
  
  
  Reg_wr_D    <= '1';
  Mem2reg_D   <= '0';
  Mem_wr_D    <= '0';
  ALU_src_D   <= '1';
  Reg_dis_D   <= '0';
  Brnch_D     <= '0';
  Jmp_D       <= "00";
  
  ALU_ctrl_D  <= "000";
  
  
  -- Instruction LH
        
       elsif(OpCd = "100001") AND ((fnc = "001000") or (fnc ="001100")) then
       
       
        Reg_wr_D    <= '1';
        Mem2reg_D   <= '1';
        Mem_wr_D    <= '0';
        ALU_src_D   <= '1';
        Reg_dis_D   <= '0';
        Brnch_D     <= '0';
        Jmp_D       <= "00";
        
        ALU_ctrl_D  <= "000";
        
  --Instruction ORi
  
        
        elsif(OpCd = "001101") then
               
               
         Reg_wr_D    <= '1';
         Mem2reg_D   <= '0';
         Mem_wr_D    <= '0';
         ALU_src_D   <= '1';
         Reg_dis_D   <= '0';
         Brnch_D     <= '0';
         Jmp_D       <= "00";
            
         ALU_ctrl_D  <= "001";
         
    --Instruction SSL   
         
         elsif(OpCd = "000001")  then
                       
                       
                 Reg_wr_D    <= '1';
                 Mem2reg_D   <= '0';
                 Mem_wr_D    <= '0';
                 ALU_src_D   <= '0';
                 Reg_dis_D   <= '1';
                 Brnch_D     <= '0';
                 Jmp_D       <= "00";
                    
                 ALU_ctrl_D  <= "010";
    
    --Instruction XNOR 
      
          elsif(OpCd = "010010")  then
                             
                             
                       Reg_wr_D    <= '1';
                       Mem2reg_D   <= '0';
                       Mem_wr_D    <= '0';
                       ALU_src_D   <= '0';
                       Reg_dis_D   <= '1';
                       Brnch_D     <= '0';
                       Jmp_D       <= "00";
                          
                       ALU_ctrl_D  <= "011";
                       
                       
      --Instruction BNE 
                             
           elsif(OpCd = "000101")  then
                                                    
                                                    
                        Reg_wr_D    <= '0';
                        Mem2reg_D   <= '0';
                        Mem_wr_D    <= '0';
                        ALU_src_D   <= '0';
                        Reg_dis_D   <= '0';
                        Brnch_D     <= '1';
                        Jmp_D       <= "01";
                        
                                                 
                       ALU_ctrl_D  <= "000";
                       
         -- Instruction NAND    
         
                   
         elsif (OpCd = "000111") then 
           
                        Reg_wr_D    <= '1';
                        Mem2reg_D   <= '0';
                        Mem_wr_D    <= '0';
                        ALU_src_D   <= '0';
                        Reg_dis_D   <= '1';
                        Brnch_D     <= '0';
                        Jmp_D       <= "00";
                                                            
                        ALU_ctrl_D  <= "100";     
                        
                        
          -- Instruction J  
          
          elsif (OpCd = "000010") then 
                     
                                  Reg_wr_D    <= '0';
                                  Mem2reg_D   <= '0';
                                  Mem_wr_D    <= '0';
                                  ALU_src_D   <= '0';
                                  Reg_dis_D   <= '0';
                                  Brnch_D     <= '0';
                                  Jmp_D       <= "10";
                                                                      
                                  ALU_ctrl_D  <= "100";   
                                  
          -- Instruction SB  
                                            
           elsif (OpCd = "101000") then 
                                                       
                            Reg_wr_D    <= '0';
                            Mem2reg_D   <= '0';
                            Mem_wr_D    <= '1';
                            ALU_src_D   <= '1';
                            Reg_dis_D   <= '0';
                            Brnch_D     <= '0';
                            Jmp_D       <= "00";
                                                                                                        
                           ALU_ctrl_D  <= "000";                        
                
                
            -- Instruction SUBi
            
                                  
            elsif  (OpCd = "110000" ) then 
                                      
                            Reg_wr_D    <= '1';
                            Mem2reg_D   <= '0';
                            Mem_wr_D    <= '0';
                            ALU_src_D   <= '1';
                            Reg_dis_D   <= '0';
                            Brnch_D     <= '0';
                            Jmp_D       <= "00";
                                            
                            ALU_ctrl_D  <= "101";  
                            
                            
                            
             -- Instruction JR
                                    
                                                          
            elsif  (OpCd = "001000" ) then 
                                                              
                            Reg_wr_D    <= '0';
                            Mem2reg_D   <= '0';
                            Mem_wr_D    <= '0';
                            ALU_src_D   <= '0';
                            Reg_dis_D   <= '0';
                            Brnch_D     <= '0';
                            Jmp_D       <= "00";
                                                                    
                            ALU_ctrl_D  <= "000";                
                            
                            
                                                         
                                                
  
  
  
  elsif  (OpCd = "000000") and (fnc = "000000") then 
    
          Reg_wr_D    <= '0';
          Mem2reg_D   <= '0';
          Mem_wr_D    <= '0';
          ALU_src_D   <= '0';
          Reg_dis_D   <= '0';
          Brnch_D     <= '0';
          Jmp_D       <= "01";
          
          ALU_ctrl_D  <= "000";
  
  end if;
  
end process;

end behavioral;