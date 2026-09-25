library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity primerpunto is
    port(
        clk_fpga   : in  std_logic;
        rst_btn    : in  std_logic;
        sensor     : in  std_logic;

        hex0       : out std_logic_vector(6 downto 0);
        hex1       : out std_logic_vector(6 downto 0);
        hex2       : out std_logic_vector(6 downto 0);
        hex3       : out std_logic_vector(6 downto 0);

        led_alarma : out std_logic;
        led_feliz  : out std_logic
    );
end entity primerpunto;

architecture rtl of primerpunto is

    component div_clk
        port(
            clk_in   : in  std_logic;
            sel_frec : in  std_logic_vector(1 downto 0);
            clk_out  : out std_logic
        );
    end component;

    component dec_7seg
        port(
            valor : in  std_logic_vector(3 downto 0);
            disp  : out std_logic_vector(6 downto 0)
        );
    end component;

    component temporiz_uno
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
    end component;

    component temporiz_dos
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
    end component;

    signal clk_seg1     : std_logic;

    signal buf_uni1     : std_logic_vector(3 downto 0);
    signal buf_dec1     : std_logic_vector(3 downto 0);

    signal buf_uni2     : std_logic_vector(3 downto 0);
    signal buf_dec2     : std_logic_vector(3 downto 0);
    signal buf_cen2     : std_logic_vector(3 downto 0);

    signal s_alarma     : std_logic;
    signal s_feliz      : std_logic;
    signal s_activo     : std_logic;
    signal s_ocupado    : std_logic;
    signal s_marcha     : std_logic;

    signal sel_uni      : std_logic_vector(3 downto 0);
    signal sel_dec      : std_logic_vector(3 downto 0);
    signal sel_cen      : std_logic_vector(3 downto 0);

    constant APAGADO : std_logic_vector(6 downto 0) := "1111111";

    signal sensor_n : std_logic;
    signal reset_n  : std_logic;

begin

    sensor_n <= not sensor;
    reset_n  <= not rst_btn;

    U_DIV: div_clk
        port map(
            clk_in   => clk_fpga,
            sel_frec => "00",
            clk_out  => clk_seg1
        );

    U_T1: temporiz_uno
        port map(
            clk_sys   => clk_fpga,
            clk_seg   => clk_seg1,
            reset     => reset_n,
            boton     => sensor_n,
            dig_uni   => buf_uni1,
            dig_dec   => buf_dec1,
            sal_alarm => s_alarma,
            sal_ok    => s_feliz,
            sal_activ => s_activo,
            sal_ocup  => s_ocupado
        );

    U_T2: temporiz_dos
        port map(
            clk_seg   => clk_seg1,
            reset     => reset_n,
            disparo   => s_alarma,
            ocupado   => s_ocupado,
            dig_uni   => buf_uni2,
            dig_dec   => buf_dec2,
            dig_cen   => buf_cen2,
            en_marcha => s_marcha
        );

    sel_uni <= buf_uni2 when s_marcha = '1' else buf_uni1;
    sel_dec <= buf_dec2 when s_marcha = '1' else buf_dec1;
    sel_cen <= buf_cen2 when s_marcha = '1' else "0000";

    U_H0: dec_7seg port map(valor => sel_uni, disp => hex0);
    U_H1: dec_7seg port map(valor => sel_dec, disp => hex1);
    U_H2: dec_7seg port map(valor => sel_cen, disp => hex2);
    hex3 <= APAGADO;

    led_alarma <= s_alarma;
    led_feliz  <= s_feliz;

end architecture rtl;
