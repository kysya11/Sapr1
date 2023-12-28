module testbench;

reg [0:0] PCLK;
reg [0:0] PRESET;

reg [0:0] PSEL;
reg [0:0] transfer;
reg [0:0] PWRITE;

reg [31:0] PADDR;
reg [31:0] PDATA;

wire [0:0] PENABLE;
wire [31:0] PRWDATA;
wire [31:0] PRWADDR;

wire [31:0] PRDATA1;
wire [0:0] PREADY;

master m (
    .PCLK(PCLK),
    .PRESET(PRESET),
    .PSEL(PSEL),
    .PREADY(PREADY),
    .transfer(transfer),
    .PWRITE(PWRITE),      
    .PADDR(PADDR),
    .PDATA(PDATA),

    .PENABLE(PENABLE),
    .PRWDATA(PRWDATA),
    .PRWADDR(PRWADDR)
);

slave s (
    .PCLK(PCLK),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PRWDATA(PRWDATA),  // master out, slave in data
    .PRWADDR(PRWADDR),  // master out, slava in addr
    .PRWDATA1(PRDATA1),        // slave out data
    .PREADY(PREADY)        
);

// сначала делаем чтение в мастере,
// потом делаем передачу в слейв, где мы читаем память и изменяем
// в соответствии с заданием


initial begin

    $display("start");
    $dumpfile("testbench.vcd");
    $dumpvars(0,testbench);
    PADDR = 32'b0000_0000_0000_0000_0000_0000_0000_0100;
    PDATA = 0;

    PWRITE = 1'b1;
    
    PCLK = 1'b0;
    PRESET = 0;
    PSEL = 0;
    transfer = 1'b1;

    PRESET = 1;
    #10;

    PRESET = 0;
    PSEL = 1;
    #40;

    PSEL = 0;
    #20;
    
    
    PADDR = 32'b0000_0000_0000_0000_0000_0000_0000_0100;
    PSEL = 1;
    #155;
    PSEL = 0;
	 #5; 
    $finish;
end

always begin
    #5 PCLK = ~PCLK;
end

endmodule