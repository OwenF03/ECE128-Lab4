`timescale 1ns / 1ps
`include "defs.v"

//Test bench file for Car_Safety module
module testbench();
    
    wire [15:5] led;
    reg [15:3] sw; 
    reg SRV; 
    
    Car_Safety DUT(.sw(sw), .SRV(SRV), .led(led)); 
      
    
endmodule