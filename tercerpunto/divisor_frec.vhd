library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divisor_frec is
    port(
        clk_ref  : in  std_logic;
        modo_sel : in  std_logic_vector(1 downto 0);
        clk_div  : out std_logic
    );
end entity divisor_frec;

architecture rtl of divisor_frec is

    signal cont_int : integer := 0;
    signal tope_cnt : integer := 25000000;
    signal clk_aux  : std_logic := '0';

begin

    tope_cnt <= 25000000 when modo_sel = "00" else
                12500000 when modo_sel = "01" else
                 6250000 when modo_sel = "10" else
                 3125000;

    p_div: process(clk_ref)
    begin
        if rising_edge(clk_ref) then
            if cont_int >= tope_cnt then
                cont_int <= 0;
                clk_aux  <= not clk_aux;
            else
                cont_int <= cont_int + 1;
            end if;
        end if;
    end process p_div;

    clk_div <= clk_aux;

end architecture rtl;
