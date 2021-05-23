library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

--This entity is to control hazards in MIPS

entity Hazard_ctrl is
  
    Port ( 
      
      
      ----------------------------INPUT 
      
       Brnch_D     :  in std_logic:= '0' ; 
       Rs_D,Rt_D   :  in std_logic_vector (4 downto 0):= (others=>'0') ;
       
       Reg_wr_E    :  in std_logic:= '0' ;
       Mem2reg_E   :  in std_logic:= '0' ;
       Rs_E,Rt_E   :  in std_logic_vector (4 downto 0):= (others=>'0');
       Write_Reg_E :  in std_logic_vector (4 downto 0):= (others=>'0');
       
       Reg_wr_M    :  in std_logic:= '0';
       Write_Reg_M :  in std_logic_vector (4 downto 0) := (others=>'0');
       
       Reg_wr_W    :  in std_logic:= '0';
       Write_Reg_W :  in std_logic_vector (4 downto 0) := (others=>'0') ;
       
       Mem2reg_M   :  in std_logic:= '0';
       
       
       ---------------------------OUTPUT 
   
       Stall_PC: out std_logic:= '1' ;
       Stall_IF: out std_logic:= '1' ;
       Reset_E : out  std_logic:= '0';
       
       Fwd_AD  : out std_logic:='0';
       Fwd_BD  : out std_logic:='0';
       Fwd_AE  : out std_logic_vector (1 downto 0) := (others=>'0') ;
       Fwd_BE  : out std_logic_vector (1 downto 0) := (others=>'0') 
       
     );
       
end Hazard_ctrl;





architecture behavrior of  Hazard_ctrl is 


begin 
  
  
  process(Brnch_D, Rs_D,Rt_D, Reg_wr_E, Mem2reg_E,  Rs_E, Rt_E, Write_Reg_E,Reg_wr_W,Write_Reg_W,Reg_wr_M,Write_Reg_M)  ----TRY HERE
    
    
    begin
    
    
    --Stall for load 
    
    if  ((Mem2reg_E = '1') AND ((Write_Reg_E = Rs_D) OR (Write_Reg_E = Rt_D))) then
                
               Stall_PC <= '0';
               Stall_IF <= '0';
               Reset_E  <= '1';
                
             else
               
               Stall_PC <= '1';
               Stall_IF <= '1';
               Reset_E  <= '0';
               
            end if; 
            
          --Forwarding from WB to EX  
            
    if(Reg_wr_W = '1')  AND (Write_Reg_W = Rs_E) then
    
                  Fwd_AE <= "01";
                  
                else
                  
                  Fwd_AE <= "00";
                  
                 end if;	
                  
    if (Reg_wr_W = '1') AND (Write_Reg_W = Rt_E) then
                
                 Fwd_BE <= "01";
                  
               else 
                  
                  Fwd_BE <= "00";
                
                  
                  end if;	
                  
   
                
      --Forwarding from Mem to EX 
      
      
      if ((Reg_wr_M = '1')  AND (Write_Reg_M = Rs_E)) then 
          
                        Fwd_AE <= "01";
                        
                       end if;	
                        
      if ((Reg_wr_M = '1') AND  (Write_Reg_M = Rt_E)) then
          
          
                      
                        Fwd_BE <= "10";
             
                     end if;	
          
    --Stall for Branch 
    
    if  ((Brnch_D = '1') AND ((Write_Reg_E = Rs_D) OR (Write_Reg_E = Rt_D))) then
                    
                   Stall_PC <= '0';
                   Stall_IF <= '0';
                   Reset_E  <= '1';
                           
                end if;  
                
                
       --Forward from MEM to ID 
       
       if ((Reg_wr_M = '1')  AND  (Write_Reg_M = Rs_D))   then
           
                        Fwd_AD <= '1';
                        
                 else 
                 
                        Fwd_AD <= '0';
 
           
         end if;          
                         
        if ((Reg_wr_M = '1') AND (Write_Reg_M = Rt_D)) then  
                         
                         Fwd_BD <=  '1';
                             
                       else
                         
                         Fwd_BD <= '0';
                                   
                end if;       
         
              
     end process;       
              
     end behavrior;             
        
   
