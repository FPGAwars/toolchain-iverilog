module SB_IO (
	inout  PACKAGE_PIN,
	input  LATCH_INPUT_VALUE,
	input  CLOCK_ENABLE,
	input  INPUT_CLK,
	input  OUTPUT_CLK,
	input  OUTPUT_ENABLE,
	input  D_OUT_0,
	input  D_OUT_1,
	output D_IN_0,
	output D_IN_1
);

endmodule

module SB_DFF (
        input C,
        input D,
        output Q
);

endmodule

module SB_DFFE (
        input C,
        input D,
	input E,
        output Q
);

endmodule

module SB_DFFSR (
        input C,
        input D,
	input R,
        output Q
);

endmodule

module SB_DFFR (
        input C,
        input D,
	input R,
        output Q
);

endmodule

module SB_DFFSS (
        input C,
        input D,
	input S,
        output Q
);

endmodule

module SB_DFFS (
        input C,
        input D,
	input S,
        output Q
);

endmodule

module SB_DFFESR (
        input C,
        input D,
	input R,
	input E,
        output Q
);

endmodule

module SB_DFFER (
	input C,
	input D,
	input R,
	input E,
	output Q
);

endmodule

module SB_DFFESS (
	input C,
	input D,
	input E,
	input S,
	output Q
);

endmodule

module SB_DFFES (
	input C,
	input D,
	input E,
	input S,
	output Q
);

endmodule

module SB_DFFN (
	input C,
	input D,
	output Q
);

endmodule

module SB_DFFNE (
	input C,
	input D,
	input E,
	output Q
);

endmodule

module SB_DFFNSR (
	input C,
	input D,
	input R,
	output Q
);

endmodule

module SB_DFFNR (
	input C,
	input D,
	input R,
	output Q
);

endmodule

module SB_DFFNSS (
	input C,
	input D,
	input S,
	output Q
);

endmodule

module SB_DFFNS (
	input C,
	input D,
	input S,
	output Q
);

endmodule

module SB_DFFNESR (
	input C,
	input D,
	input E,
	input R,
	output Q
);

endmodule

module SB_DFFNER (
	input C,
	input D,
	input E,
	input R,
	output Q
);

endmodule

module SB_DFFNESS (
	input C,
	input D,
	input E,
	input S,
	output Q
);

endmodule

module SB_DFFNES (
	input C,
	input D,
	input E,
	input S,
	output Q
);

endmodule

module SB_CARRY (
	input I0,
	input I1,
	input CI,
	output CO
);

endmodule

module SB_LUT4 (
        input I0,
        input I1,
        input I2,
        input I3,
        output O
);

endmodule
