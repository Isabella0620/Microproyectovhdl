library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temporiz_dos is
    port(
        clk_seg  : in  std_logic;
        reset    : in  std_logic;
        disparo  : in  std_logic;
        ocupado  : in  std_logic;
        dig_uni  : out std_logic_vector(3 downto 0);
        dig_dec  : out std_logic_vector(3 downto 0);
        dig_cen  : out std_logic_vector(3 downto 0);
        en_marcha: out std_logic
    );
end entity temporiz_dos;

architecture rtl of temporiz_dos is

    type t_fase is (F_ESPERA, F_INICIO, F_CUENTA, F_FIN);
    signal fase_actual : t_fase := F_ESPERA;

    signal q_uni : integer range 0 to 9 := 0;
    signal q_dec : integer range 0 to 9 := 0;
    signal q_cen : integer range 0 to 9 := 0;

begin

    p_fsm: process(clk_seg)
    begin
        if rising_edge(clk_seg) then
            if reset = '1' then
                fase_actual <= F_ESPERA;
                q_uni       <= 0;
                q_dec       <= 0;
                q_cen       <= 0;
                en_marcha   <= '0';

            else
                case fase_actual is

                    when F_ESPERA =>
                        en_marcha <= '0';
                        q_uni     <= 0;
                        q_dec     <= 0;
                        q_cen     <= 0;
                        if disparo = '1' and ocupado = '1' then
                            fase_actual <= F_INICIO;
                        end if;

                    when F_INICIO =>
                        en_marcha   <= '1';
                        fase_actual <= F_CUENTA;

                    when F_CUENTA =>
                        en_marcha <= '1';

                        if ocupado = '0' then
                            fase_actual <= F_FIN;

                        else
                            if q_uni = 9 then
                                q_uni <= 0;
                                if q_dec = 9 then
                                    q_dec <= 0;
                                    if q_cen < 9 then
                                        q_cen <= q_cen + 1;
                                    end if;
                                else
                                    q_dec <= q_dec + 1;
                                end if;
                            else
                                q_uni <= q_uni + 1;
                            end if;
                        end if;

                    when F_FIN =>
                        en_marcha <= '0';
                        if disparo = '0' then
                            fase_actual <= F_ESPERA;
                        end if;

                    when others =>
                        fase_actual <= F_ESPERA;

                end case;
            end if;
        end if;
    end process p_fsm;

    dig_uni <= std_logic_vector(to_unsigned(q_uni, 4));
    dig_dec <= std_logic_vector(to_unsigned(q_dec, 4));
    dig_cen <= std_logic_vector(to_unsigned(q_cen, 4));

end architecture rtl;
