library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dec_7seg is
    port(
        valor : in  std_logic_vector(3 downto 0);
        disp  : out std_logic_vector(6 downto 0)
    );
end entity dec_7seg;

architecture rtl of dec_7seg is
begin
    p_tabla: process(valor)
    begin
        case valor is
            when "0000" => disp <= "1000000";
            when "0001" => disp <= "1111001";
            when "0010" => disp <= "0100100";
            when "0011" => disp <= "0110000";
            when "0100" => disp <= "0011001";
            when "0101" => disp <= "0010010";
            when "0110" => disp <= "0000010";
            when "0111" => disp <= "1111000";
            when "1000" => disp <= "0000000";
            when "1001" => disp <= "0010000";
            when others => disp <= "1111111";
        end case;
    end process p_tabla;
end architecture rtl;
