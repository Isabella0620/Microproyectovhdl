library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temporiz_uno is
    port(
        clk_sys   : in  std_logic;
        clk_seg   : in  std_logic;
        reset     : in  std_logic;
        boton     : in  std_logic;
        dig_uni   : out std_logic_vector(3 downto 0);
        dig_dec   : out std_logic_vector(3 downto 0);
        sal_alarm : out std_logic;
        sal_ok    : out std_logic;
        sal_activ : out std_logic;
        sal_ocup  : out std_logic
    );
end entity temporiz_uno;

architecture rtl of temporiz_uno is

    type t_fase is (F_ESPERA, F_CUENTA, F_ALARM, F_OK);
    signal fase_actual : t_fase := F_ESPERA;

    signal q_uni : integer range 0 to 9 := 0;
    signal q_dec : integer range 0 to 3 := 0;

    signal db1    : std_logic := '0';
    signal db2    : std_logic := '0';

    signal inhibir : integer range 0 to 15 := 0;

    signal presente : std_logic := '0';

begin

    p_deteccion: process(clk_sys)
    begin
        if rising_edge(clk_sys) then
            if reset = '1' then
                db1      <= '0';
                db2      <= '0';
                presente <= '0';
                inhibir  <= 15;
            else
                db1 <= boton;
                db2 <= db1;

                if inhibir > 0 then
                    inhibir <= inhibir - 1;
                end if;

                if db1 = '1' and db2 = '0' and inhibir = 0 then
                    presente <= not presente;
                end if;
            end if;
        end if;
    end process p_deteccion;

    p_fsm: process(clk_seg)
    begin
        if rising_edge(clk_seg) then
            if reset = '1' then
                fase_actual <= F_ESPERA;
                q_uni       <= 0;
                q_dec       <= 0;
                sal_alarm   <= '0';
                sal_ok      <= '0';
                sal_activ   <= '0';

            else
                case fase_actual is

                    when F_ESPERA =>
                        sal_alarm <= '0';
                        sal_ok    <= '0';
                        sal_activ <= '0';
                        q_uni     <= 0;
                        q_dec     <= 0;
                        if presente = '1' then
                            fase_actual <= F_CUENTA;
                            sal_activ   <= '1';
                        end if;

                    when F_CUENTA =>
                        sal_activ <= '1';
                        sal_alarm <= '0';
                        sal_ok    <= '0';

                        if presente = '0' then
                            fase_actual <= F_OK;

                        elsif q_dec = 3 and q_uni = 5 then
                            fase_actual <= F_ALARM;

                        else
                            if q_uni = 9 then
                                q_uni <= 0;
                                q_dec <= q_dec + 1;
                            else
                                q_uni <= q_uni + 1;
                            end if;
                        end if;

                    when F_ALARM =>
                        sal_alarm <= '1';
                        sal_ok    <= '0';
                        sal_activ <= '0';
                        if presente = '0' then
                            fase_actual <= F_ESPERA;
                        end if;

                    when F_OK =>
                        sal_alarm <= '0';
                        sal_ok    <= '1';
                        sal_activ <= '0';
                        fase_actual <= F_ESPERA;

                    when others =>
                        fase_actual <= F_ESPERA;

                end case;
            end if;
        end if;
    end process p_fsm;

    dig_uni  <= std_logic_vector(to_unsigned(q_uni, 4));
    dig_dec  <= std_logic_vector(to_unsigned(q_dec, 4));
    sal_ocup <= presente;

end architecture rtl;
