module datapath_tb;
  reg clk;
  reg reset;
  // señales de entrada
  reg [1:0] RegSrcD;
  reg RegWriteW;
  reg [1:0] ImmSrcD;
  reg ALUSrcE;
  reg [2:0] ALUControlE;
  reg MemtoRegW;
  reg PCSrcW;
  //  señales de salida
  wire [3:0] ALUFlags;
  wire [31:0] PCF;
  wire [31:0] ALUResultM;
  wire [31:0] WriteDataM;
  wire [31:12] InstrControl;
  wire [31:0] ReadDataM;

  // Instancia el módulo datapath
  datapath dut (
    .clk(clk),
    .reset(reset),
    .RegSrcD(RegSrcD),
    .RegWriteW(RegWriteW),
    .ImmSrcD(ImmSrcD),
    .ALUSrcE(ALUSrcE),
    .ALUControlE(ALUControlE),
    .MemtoRegW(MemtoRegW),
    .PCSrcW(PCSrcW),
    .ALUFlags(ALUFlags),
    .PCF(PCF),
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .InstrControl(InstrControl),
    .ReadDataM(ReadDataM)
  );

  always #5 clk = ~clk;

  // Inicializa las señales
  initial begin
    clk = 0;
    reset = 0;
    // Inicializa el resto de las señales de entrada aquí

    #10 reset = 1;
    #10 reset = 0;

    // Ejemplo de instrucciones de prueba
    // ADD R1, R2, R3
    RegSrcD = 2'b00; // R2 y R3 como fuentes de datos
    RegWriteW = 1; // Habilitar escritura en registro de destino
    ALUSrcE = 0; // Fuente B es registro R3
    ALUControlE = 3'b000; // Suma
    MemtoRegW = 0; // No cargar dato de memoria al registro de destino
    PCSrcW = 0; // PC siguiente

    // Espera un ciclo para estabilizar las salidas
    #5;
    // Verifica los resultados esperados
    if (ALUFlags !== 4'b0000 || PCF !== 32'h00000008 || ALUResultM !== (R2 + R3) || WriteDataM !== (R2 + R3) || InstrControl !== 20'h000) begin
      $display("Error en ADD");
      $finish;
    end

    // OR R4, R5, R6
    RegSrcD = 2'b01; // R5 y R6 como fuentes de datos
    ALUControlE = 3'b010; // OR
    // Resto de las señales se mantienen igual

    // Espera un ciclo para estabilizar las salidas
    #5;
    // Verifica los resultados esperados
    if (ALUFlags !== 4'b0000 || PCF !== 32'h0000000C || ALUResultM !== (R5 | R6) || WriteDataM !== (R5 | R6) || InstrControl !== 20'h000) begin
      $display("Error en OR");
      $finish;
    end

    // AND R7, R8, R9
    RegSrcD = 2'b10; // R8 y R9 como fuentes de datos
    ALUControlE = 3'b001; // AND
    // Resto de las señales se mantienen igual

    // Espera un ciclo para estabilizar las salidas
    #5;
    // Verifica los resultados esperados
    if (ALUFlags !== 4'b0000 || PCF !== 32'h00000010 || ALUResultM !== (R8 & R9) || WriteDataM !== (R8 & R9) || InstrControl !== 20'h000) begin
      $display("Error en AND");
      $finish;
    end

    // SUB R10, R11, R12
    RegSrcD = 2'b11; // R11 y R12 como fuentes de datos
    ALUControlE = 3'b011; // RESTA
    // Resto de las señales se mantienen igual

    // Espera un ciclo para estabilizar las salidas
    #5;
    // Verifica los resultados esperados
    if (ALUFlags !== 4'b0010 || PCF !== 32'h00000014 || ALUResultM !== (R11 - R12) || WriteDataM !== (R11 - R12) || InstrControl !== 20'h000) begin
      $display("Error en SUB");
      $finish;
    end

    // STR R13, R14
    RegSrcD = 2'b00; // R14 como fuente de datos
    RegWriteW = 0; // Deshabilitar escritura en registro de destino
    ALUSrcE = 1; // Fuente B es inmediato
    ALUControlE = 3'b000; // Suma
    MemtoRegW = 0; // No cargar dato de memoria al registro de destino
    PCSrcW = 0; // PC siguiente
    ImmSrcD = 2'b00; // Inmediato 0

    // Espera un ciclo para estabilizar las salidas
    #5;
    // Verifica los resultados esperados
    if (ALUFlags !== 4'b0000 || PCF !== 32'h00000018 || ALUResultM !== (R14 + 0) || WriteDataM !== (R14 + 0) || InstrControl !== 20'h000) begin
      $display("Error en STR");
      $finish;
    end

    // LDR R15, R16
    RegSrcD = 2'b00; // R16 como fuente de datos
    RegWriteW = 1; // Habilitar escritura en registro de destino
    ALUSrcE = 1; // Fuente B es inmediato
    ALUControlE = 3'b000; // Suma
    MemtoRegW = 1; // Cargar dato de memoria al registro de destino
    PCSrcW = 0; // PC siguiente
    ImmSrcD = 2'b01; // Inmediato 1

    // Espera un ciclo para estabilizar las salidas
    #5;
    // Verifica los resultados esperados
    if (ALUFlags !== 4'b0000 || PCF !== 32'h0000001C || ALUResultM !== (R16 + 1) || WriteDataM !== ReadDataM || InstrControl !== 20'h000) begin
      $display("Error en LDR");
      $finish;
    end

    // Fin del testbench
    $display("Testbench completo");
    $finish;
  end
    initial begin
        $dumpfile("datapath_tb.vcd"); // this creates a waveform file after simulation
        $dumpvars;
    end
endmodule
