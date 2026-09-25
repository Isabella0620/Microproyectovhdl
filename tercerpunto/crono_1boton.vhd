library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity crono_1boton is
    port(
        clk_50m  : in  std_logic;
        boton    : in  std_logic;
        seg_uni  : out std_logic_vector(6 downto 0);
        seg_dec  : out std_logic_vector(6 downto 0);
        seg_min  : out std_logic_vector(7 downto 0)
    );
end entity crono_1boton;

architecture rtl of crono_1boton is

    component divisor_frec is
        port(
            clk_ref  : in  std_logic;
            modo_sel : in  std_logic_vector(1 downto 0);
            clk_div  : out std_logic
        );
    end component;

    component conv_7seg is
        port(
            val_bcd : in  std_logic_vector(3 downto 0);
            seg_out : out std_logic_vector(6 downto 0)
        );
    end component;

    component crono_base is
        port(
            clk_p : in  std_logic;
            rst_n : in  std_logic;
            s_uni : out std_logic_vector(3 downto 0);
            s_dec : out std_logic_vector(3 downto 0);
            s_min : out std_logic_vector(3 downto 0)
        );
    end component;

    constant LIM_RESET : integer := 100_000_000;

    signal clk_seg1     : std_logic;

    signal en_cuenta     : std_logic := '0';
    signal rst_cnt       : std_logic := '1';

    signal val_u : std_logic_vector(3 downto 0);
    signal val_d : std_logic_vector(3 downto 0);
    signal val_m : std_logic_vector(3 downto 0);

    signal sync0      : std_logic := '1';
    signal sync1      : std_logic := '1';
    signal btn_ant     : std_logic := '1';

    signal cnt_hold      : integer range 0 to 100_000_001 := 0;

    signal reset_hecho : std_logic := '0';

begin

    u_div: divisor_frec
        port map(
            clk_ref  => clk_50m,
            modo_sel => "00",
            clk_div  => clk_seg1
        );

    p_control: process(clk_50m)
    begin
        if rising_edge(clk_50m) then

            sync0 <= boton;
            sync1 <= sync0;

            rst_cnt <= '1';

            if sync1 = '0' then

                if cnt_hold < LIM_RESET then
                    cnt_hold <= cnt_hold + 1;
                end if;

                if cnt_hold >= LIM_RESET and reset_hecho = '0' then
                    rst_cnt     <= '0';
                    en_cuenta   <= '0';
                    reset_hecho <= '1';
                end if;

            else
                if btn_ant = '0' and reset_hecho = '0' then
                    en_cuenta <= not en_cuenta;
                end if;

                cnt_hold    <= 0;
                reset_hecho <= '0';
            end if;

            btn_ant <= sync1;

        end if;
    end process p_control;

    u_crono: crono_base
        port map(
            clk_p => clk_seg1 and en_cuenta,
            rst_n => rst_cnt,
            s_uni => val_u,
            s_dec => val_d,
            s_min => val_m
        );

    u_seg_u: conv_7seg port map(val_bcd => val_u, seg_out => seg_uni);
    u_seg_d: conv_7seg port map(val_bcd => val_d, seg_out => seg_dec);
    u_seg_m: conv_7seg port map(val_bcd => val_m, seg_out => seg_min(6 downto 0));

    seg_min(7) <= '0';

end architecture rtl;
