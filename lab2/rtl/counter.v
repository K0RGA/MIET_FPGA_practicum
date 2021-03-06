`timescale 1ns / 1ps

module counter(
  input         clk100_i,
  input         rstn_i,
  input  [13:0] sw_i,
  input  [1:0]  key_i,
  output [9:0]  ledr_o,
  output [6:0]  hex1_o,
  output [6:0]  hex0_o);
  
reg  [7:0] counter;
reg  [9:0] q;

wire bt_down;

button_debounce bt0(
  .btn_i   ( !key_i[0]  ),
  .ondn_o  ( bt_down    ),
  .rst_i   ( key_i[1]   ),
  .clk_i   ( clk100_i   )
);

always @( posedge clk100_i or negedge key_i[1] ) begin				
  if( !key_i[1] ) begin
    q       <= 10'b0;
    counter <= 8'd0;
  end
  else
    if( bt_down ) begin
      q       <= sw_i[9:0];
      counter <= counter + sw_i[13:10];
    end
end

//assign ledr_o = q;
assign ledr_o = ( ( q | ( q - 1 ) ) + 1 ) & q;

dec_hex dec1
( .in  ( counter[7:4] ),
  .out ( hex0_o       ));

dec_hex dec0
( .in  ( counter[3:0] ),
  .out ( hex1_o       ));

endmodule