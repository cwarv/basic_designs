module fsm2(
    input logic clk,
    input logic resetn,
    input logic coin,
    input logic cancel,
    input logic selection,
    input logic received,
    output logic flash,
    output logic drink,
    output logic change
);


typedef enum logic [1:0] {IDLE, CREDIT, DISPENSE} state_t;

state_t state_q, n_state;
logic count_tokens;
wire n_flash, n_drink, n_change;

always_ff @( posedge clk ) begin : PRESENT_STATE
    if(!resetn) begin
        state_q <= IDLE;
        flash <= 0;
        drink <= 0;
        change <= 0;
    end
    else begin
        state_q <= n_state;
        flash <= n_flash;
        drink <= n_drink;
        change <= n_change;
    end
end

always_comb begin : NEXT_STATE
    n_state=state_q;
    n_flash='X;
    n_drink='X;
    n_change='X;
    case(state_q)
        IDLE:
            if (coin) begin
                n_state=CREDIT;
                n_flash = 0;
                n_drink = 0;
                n_change = 0;
            end
        CREDIT:
            if (cancel) begin
                n_state=IDLE;
                n_flash = 1;

            end else if (selection) begin
                n_state=DISPENSE;
                n_drink = 1;

            end
        DISPENSE:
            if (coin) begin
                n_state=CREDIT;
                n_change=0;

            end else if (received) begin
                n_state=IDLE;
                n_change=1;
            end
	endcase
end


endmodule