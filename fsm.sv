module fsm (
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


typdef enum logic [1:0] {IDLE, CREDIT, DISPENSE} state_t;

state_t state_q, n_state;
logic count_tokens;
wire n_flash, n_drink, n_change;

always_ff @( posedge clk ) begin : PRESENT_STATE
    if(!resetn) begin
        state <= 0;
        flash <= 1;
        change <= 0;
    end
    else begin
        state <= n_state;
    end
end

always_comb begin : NEXT_STATE
    n_state=XX;
    case(state)
    IDLE:
        if (coin) begin
            n_state=CREDIT;
        end
    CREDIT:
        if (cancel) begin
            n_state=IDLE;
        end else if (selection) begin
            n_state=DISPENSE;
        end
    DISPENSE:
        if (coin) begin
            n_state=CREDIT;
        end 
        if (received) begin
            n_state=IDLE;
        end
end

always_comb begin : NEXT_OUTPUT
        n_flash=X;
        n_drink=X;
        n_change=X;
        case(state)
        IDLE:
            if (coin) begin
                n_flash = 0;
                n_drink = 0;
                n_change = 0;
            end
        CREDIT:
            if (cancel) begin
                n_flash = 1;
            end else if (selection) begin
                n_drink = 1;
            end

        DISPENSE:
            if (coin) begin
                n_change=0;
            end 
            if (received) begin
                n_change=1;
            end
end

always_ff @( posedge clk ) begin : OUTPUT_REG
        if(!resetn) begin
            flash <= 0;
            drink <= 0;
            change <= 0;
        end else 
            flash <= n_flash;
            drink <= n_drink;
            change <= n_change;
end


    
end

endmodule