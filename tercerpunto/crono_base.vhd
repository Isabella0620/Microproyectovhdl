library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tercerpunto is
    port(
        clk_p : in  std_logic;
        rst_n : in  std_logic;
        s_uni : out std_logic_vector(3 downto 0);
        s_dec : out std_logic_vector(3 downto 0);
        s_min : out std_logic_vector(3 downto 0)
    );
end entity tercerpunto;

architecture rtl of tercerpunto is

    signal ru : integer range 0 to 9 := 0;
    signal rd : integer range 0 to 5 := 0;
    signal rm : integer range 0 to 9 := 0;

begin

    p_cuenta: process(clk_p, rst_n)
    begin
        if rst_n = '0' then
            ru <= 0;
            rd <= 0;
            rm <= 0;

        elsif rising_edge(clk_p) then

            if ru = 9 then
                ru <= 0;

                if rd = 5 then
                    rd <= 0;

                    if rm = 9 then
                        rm <= 0;
                    else
                        rm <= rm + 1;
                    end if;

                else
                    rd <= rd + 1;
                end if;

            else
                ru <= ru + 1;
            end if;

        end if;
    end process p_cuenta;

    s_uni <= std_logic_vector(to_unsigned(ru, 4));
    s_dec <= std_logic_vector(to_unsigned(rd, 4));
    s_min <= std_logic_vector(to_unsigned(rm, 4));

end architecture rtl;
