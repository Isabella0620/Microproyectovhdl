library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity conv_7seg is
    port(
        val_bcd : in  std_logic_vector(3 downto 0);
        seg_out : out std_logic_vector(6 downto 0)
    );
end entity conv_7seg;

architecture rtl of conv_7seg is
begin

    p_conv: process(val_bcd)
    begin
        case val_bcd is
            when "0000" => seg_out <= "1000000";
            when "0001" => seg_out <= "1111001";
            when "0010" => seg_out <= "0100100";
            when "0011" => seg_out <= "0110000";
            when "0100" => seg_out <= "0011001";
            when "0101" => seg_out <= "0010010";
            when "0110" => seg_out <= "0000010";
            when "0111" => seg_out <= "1111000";
            when "1000" => seg_out <= "0000000";
            when "1001" => seg_out <= "0010000";
            when others => seg_out <= "1111111";
        end case;
    end process p_conv;

end architecture rtl;
