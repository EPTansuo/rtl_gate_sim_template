
module series(
	input wire [2:0] in,
	output wire out
);

// detect 101
assign out = (in[2] & (~in[1]) & in[0]);

endmodule

