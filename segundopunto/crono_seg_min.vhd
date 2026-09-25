library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity crono_seg_min is
    port(
        clk_p  : in  std_logic;
        rst_n  : in  std_logic;
        bcd_u  : out std_logic_vector(3 downto 0);
        bcd_d  : out std_logic_vector(3 downto 0);
        bcd_m  : out std_logic_vector(3 downto 0)
    );
end entity crono_seg_min;

architecture rtl of crono_seg_min is

    signal cu : integer range 0 to 9 := 0;
    signal cd : integer range 0 to 5 := 0;
    signal cm : integer range 0 to 9 := 0;

begin

    p_crono: process(clk_p, rst_n)
    begin
        if rst_n = '0' then
            cu <= 0;
            cd <= 0;
            cm <= 0;

        elsif rising_edge(clk_p) then
            if cu = 9 then
                cu <= 0;

                if cd = 5 then
                    cd <= 0;

                    if cm = 9 then
                        cm <= 0;
                    else
                        cm <= cm + 1;
                    end if;

                else
                    cd <= cd + 1;
                end if;

            else
                cu <= cu + 1;
            end if;
        end if;
    end process p_crono;

    bcd_u <= std_logic_vector(to_unsigned(cu, 4));
    bcd_d <= std_logic_vector(to_unsigned(cd, 4));
    bcd_m <= std_logic_vector(to_unsigned(cm, 4));

end architecture rtl;
