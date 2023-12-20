module APB_master_tb;

reg PCLK = 0;                   // сигнал синхронизации
reg PWRITE_MASTER = 0;          // сигнал, выбирающий режим записи или чтения (1 - запись, 0 - чтение)
wire PSEL;                      // сигнал выбора переферии 
reg [31:0] PADDR_MASTER = 0;    // Адрес регистра
reg [31:0] PWDATA_MASTER = 0;   // Данные для записи в регистр
wire [31:0] PRDATA_MASTER;       // Данные, прочитанные из слейва
wire PENABLE;                    // сигнал разрешения, формирующийся в мастер APB
reg PRESET = 0;                   // сигнал сброса
wire PREADY;                      // сигнал готовности (флаг того, что всё сделано успешно)
wire [31:0] PADDR;                // адрес, который мы будем передавать в слейв
wire [31:0] PWDATA;               // данные, которые будут передаваться в слейв,
wire [31:0] PRDATA ;              // данные, прочтённые с слейва
wire PWRITE;                      // сигнал записи или чтения на вход слейва

APB_slave s (
    .PWRITE(PWRITE),
    .PSEL(PSEL),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PENABLE(PENABLE),
    .PREADY(PREADY),
    .PCLK(PCLK)
);

APB_master m(
    .PCLK(PCLK),
    .PWRITE_MASTER(PWRITE_MASTER),
    .PSEL(PSEL),
    .PADDR_MASTER(PADDR_MASTER),
    .PWDATA_MASTER(PWDATA_MASTER),
    .PRDATA_MASTER(PRDATA_MASTER),
    .PENABLE(PENABLE),
    .PRESET(PRESET),
    .PREADY(PREADY),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PWRITE(PWRITE)
);



always #200 PCLK = ~PCLK; // генерация входного сигнала Pclk

initial begin
//ЗАПИСЬ
PCLK = 0;
PWRITE_MASTER = 1;         // выбираем запись
PWDATA_MASTER = 4;         // в данные для записи записываем 4
PADDR_MASTER = 0;           // выбираем адрес регистра number_in_group
@(posedge PCLK);
@(posedge PCLK);

PWRITE_MASTER = 1;         // выбираем запись
PWDATA_MASTER = 32'h2112023; // в данные для записи записываем 21.12.2023
PADDR_MASTER = 4;           // выбираем адрес регистра date
@(posedge PCLK);
@(posedge PCLK);

PWRITE_MASTER = 1;         // выбираем запись
PWDATA_MASTER = 32'h178190; // в данные для записи записываем первые 4 буквы фамилии в аски коде
PADDR_MASTER = 8;           // выбираем адрес регистра surname
@(posedge PCLK);
@(posedge PCLK);

PWRITE_MASTER = 1;            // выбираем запись
PWDATA_MASTER = 32'h186129;  // в данные для записи записываем первые 4 буквы имени в аски коде
PADDR_MASTER = 4'hC;           // выбираем адрес регистра name
@(posedge PCLK);
@(posedge PCLK);


//ЧТЕНИЕ
PWRITE_MASTER = 0;            // выбираем чтение
PADDR_MASTER = 0;           // выбираем адрес регистра номера в группе
@(posedge PCLK);
@(posedge PCLK);


PWRITE_MASTER = 0;            // выбираем чтение
PADDR_MASTER = 4;          // выбираем адрес регистра date
@(posedge PCLK);
@(posedge PCLK);

PWRITE_MASTER = 0;            // выбираем чтение
PADDR_MASTER = 8;            // выбираем адрес регистра surname
@(posedge PCLK);
@(posedge PCLK);

PWRITE_MASTER = 0;            // выбираем чтение
PADDR_MASTER = 4'hC;           // выбираем адрес регистра name
@(posedge PCLK);
@(posedge PCLK);




 #500 $finish; // Заканчиваем симуляцию
end

endmodule