module slave
//#(parameter control_reg_ADDR = 4'h0, // адрес контрольного регистра
//  parameter output_reg_ADDR = 4'h4) // адрес регистра, где хранится значение
(
  input wire PWRITE, // сигнал, выбирающий режим записи или чтения (1 - запись, 0 - чтение)
  input wire PCLK,  // сигнал синхронизации
  input wire PSEL,  // сигнал выбора переферии 
  input wire [31:0] PRWADDR, // Адрес регистра
  input wire [31:0] PRWDATA,  // Данные для записи в регистр
  output reg [31:0] PRWDATA1=0, // Данные, прочитанные из регистра
  input wire PENABLE,   // сигнал разрешения
  output reg PREADY = 0  // сигнал готовности 
);

reg [31:0]count;
reg [31:0]max=31'd15;

always @(posedge PCLK)
begin
if(PRWADDR==32'b0000_0000_0000_0000_0000_0000_0000_0100) begin
        count <= PRWDATA;
		  // Сброс счетчика
        if (count < max) begin
            count <=count + 1;
				PRWDATA1<=count;
        end else if (count == max) begin
            count <= 0; // Сброс счетчика
				PRWDATA1<=count;
			end	
    end
end
   

always @(posedge PCLK) begin
  if(PSEL == 1'b1 && PENABLE == 1'b0 && PWRITE == 1'b0) begin 
    PREADY = 0; 
  end
    
  else if(PSEL == 1'b1 && PENABLE == 1'b1 && PWRITE == 1'b0) begin 
    PREADY = 1;
  end

  else if(PSEL == 1'b1 && PENABLE == 1'b0 && PWRITE == 1'b1) begin 
    PREADY = 0; 
  end

  else if(PSEL == 1'b1 && PENABLE == 1'b1 && PWRITE == 1'b1) begin 
    PREADY = 1;
  end

  else begin
    PREADY = 0;
  end

  
end
endmodule