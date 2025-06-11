library ieee;
use ieee.std_logic_1164.all;

entity Hello_TB is
end entity;

architecture rtl of Hello_TB is
    signal signal_1_vec : STD_LOGIC_VECTOR (0 to 7) := ((others => '0') );
begin
    process
    begin
        for i in signal_1_vec'range loop
            signal_1_vec(i) <= '1';
            report integer'image(i);
            wait for 10 ns;
        end loop;

        wait;
    end process;
    

end architecture;