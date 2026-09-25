library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity segundopunto is
    port(
        clk_sys    : in  std_logic;
        btn_start  : in  std_logic;
        btn_pause  : in  std_logic;
        btn_reset  : in  std_logic;
        disp_uni   : out std_logic_vector(6 downto 0);
        disp_dec   : out std_logic_vector(6 downto 0);
        disp_min   : out std_logic_vector(7 downto 0)
    );
end entity segundopunto

architecture: rtl of segundopunto is

    component div_frecuencia is
        port(
            clk_in   : in  std_logic;
            sel_modo : in  std_logic_vector(1 downto 0);
            clk_out  : out std_logic
        );
    end component;

    component conv_bcd_seg is
        port(
            bcd_in  : in  std_logic_vector(3 downto 0);
            seg_out : out std_logic_vector(6 downto 0)
        );
    end component;

    component crono_seg_min is
        port(
            clk_p  : in  std_logic;
            rst_n  : in  std_logic;
            bcd_u  : out std_logic_vector(3 downto 0);
            bcd_d  : out std_logic_vector(3 downto 0);
            bcd_m  : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk_lento   : std_logic;
    signal activo       : std_logic := '0';
    signal val_u        : std_logic_vector(3 downto 0);
    signal val_d        : std_logic_vector(3 downto 0);
    signal val_m        : std_logic_vector(3 downto 0);

begin

    u_div: div_frecuencia
        port map(
            clk_in   => clk_sys,
            sel_modo => "00",
            clk_out  => clk_lento
        );

    ctrl: process(clk_sys)
    begin
        if rising_edge(clk_sys) then
            if btn_reset = '0' then
                activo <= '0';
            elsif btn_pause = '0' then
                activo <= '0';
            elsif btn_start = '0' then
                activo <= '1';
            end if;
        end if;
    end process ctrl;

    u_crono: crono_seg_min
        port map(
            clk_p => clk_lento and activo,
            rst_n => btn_reset,
            bcd_u => val_u,
            bcd_d => val_d,
            bcd_m => val_m
        );

    u_seg_u: conv_bcd_seg port map(bcd_in => val_u, seg_out => disp_uni);
    u_seg_d: conv_bcd_seg port map(bcd_in => val_d, seg_out => disp_dec);
    u_seg_m: conv_bcd_seg port map(bcd_in => val_m, seg_out => disp_min(6 downto 0));

    disp_min(7) <= '0';

end architecture rtl;
