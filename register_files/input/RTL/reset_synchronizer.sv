module reset_synchronizer (
    input  logic clk,
    input  logic chip_arstn,   // chip-level async active-low reset
    output logic rstn          // synchronized active-low reset
);

    logic rst_ff1;
    logic rst_ff2;

    always_ff @(posedge clk or negedge chip_arstn) begin
        if (!chip_arstn) begin
            rst_ff1 <= 1'b0;
            rst_ff2 <= 1'b0;
        end else begin
            rst_ff1 <= 1'b1;
            rst_ff2 <= rst_ff1;
        end
    end

    assign rstn = rst_ff2;

endmodule
