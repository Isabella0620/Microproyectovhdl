library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity div_clk is
    port(
        clk_in   : in  std_logic;
        sel_frec : in  std_logic_vector(1 downto 0);
        clk_out  : out std_logic
    );
end entity div_clk;

architecture rtl of div_clk is
    signal cont     : integer := 0;
    signal umbral   : integer := 25000000;
    signal clk_gen  : std_logic := '0';
begin
    umbral <= 25000000 when sel_frec = "00" else
              12500000 when sel_frec = "01" else
              6250000  when sel_frec = "10" else
              3125000;

    p_div: process(clk_in)
    begin
        if rising_edge(clk_in) then
            if cont >= umbral then
                cont    <= 0;
                clk_gen <= not clk_gen;
            else
                cont <= cont + 1;
            end if;
        end if;
    end process p_div;

    clk_out <= clk_gen;
end architecture rtl;
