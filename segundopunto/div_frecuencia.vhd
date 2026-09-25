library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity div_frecuencia is
    port(
        clk_in   : in  std_logic;
        sel_modo : in  std_logic_vector(1 downto 0);
        clk_out  : out std_logic
    );
end entity div_frecuencia;

architecture rtl of div_frecuencia is

    signal cont      : integer := 0;
    signal tope      : integer := 50000000;
    signal clk_tmp   : std_logic := '0';

begin

    tope <= 50000000 when sel_modo = "00" else
            25000000 when sel_modo = "01" else
            12500000 when sel_modo = "10" else
            6250000;

    p_div: process(clk_in)
    begin
        if rising_edge(clk_in) then
            if cont >= tope then
                cont    <= 0;
                clk_tmp <= not clk_tmp;
            else
                cont <= cont + 1;
            end if;
        end if;
    end process p_div;

    clk_out <= clk_tmp;

end architecture rtl;
