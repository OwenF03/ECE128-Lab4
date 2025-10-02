`timescale 1ns / 1ps
`default_nettype none
`include "defs.v" //Include defines


module Car_Safety(
    input wire [15:3] sw, 
    input wire SRV, 
    output wire [15:5] led
    );
    
    wire warn_pri1;
    wire warn_pri2; 
    assign warn_pri1 = ~`DOOR | ~`SB | ~`HOOD| ~`TMP_OK | ~`TRUNK | (`PASS_OCC & ~`SB_P); 
    assign warn_pri2 =  ~`BAT_OK | ~`AIB_OK | `PBRK  ; 
    
    //If SRV is asserted override temperature check 
    //Flip SRV for existing cases
    assign `DOOR_WARN = ~`DOOR & `KEY; 
    assign `SEAT_WARN = `KEY & (~`SB | (`PASS_OCC & ~`SB_P));
    assign `HOOD_WARN = `KEY & ~`HOOD; 
    assign `TRUNK_WARN = `KEY & ~`TRUNK;
    assign `BAT_WARN = `KEY & ~`BAT_OK;
    assign `AIRBAG_WARN = `KEY & ~`AIB_OK;
    assign `TEMP_WARN = `KEY & ~`TMP_OK; 
    assign `START_PERMIT = SRV | (`KEY & `BRK & `PARK & `TMP_OK); //IF SRV is asserted, can start regardless of warnings
    assign `CHIME = `KEY & warn_pri1 & ~`PARK & ~SRV | (`KEY & `PARK & ~`TMP_OK);
    assign `WARN_PRI1 = `KEY & warn_pri1;
    assign `WARN_PRI2 = `KEY & warn_pri2;
    
endmodule
