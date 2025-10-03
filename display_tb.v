`timescale 1ns / 1ps
`include "defs.v"

//Test bench file for Car_Safety module
module testbench();
    
    wire [15:5] led;
    reg [15:3] sw; 
    reg SRV; 
    
    Car_Safety DUT(.sw(sw), .SRV(SRV), .led(led)); 
    
    
    initial
        begin
            sw = 13'b0000111110011;
            SRV = 0;
            //Initialize with the driver's door open, 
            //Seatbelt not fastened, key not inserted,
            //Brake not pressed, hood closed, battery ok, airbag ok,
            //temperature okay, no passenger, no passenger seatbelt,
            //trunk closed, parking brake engaged, and vehicle is not in service mode
            //Expect no lights, chime, or warnings 
            
        end
    
    always
        begin
           #2 sw = 13'b0011111110011;
           //Insert key and press brake, expect start permit
           #2 sw = 13'b1110011110010;
           //Fasten seatbelt, close door, lift brake, lift parking brake, 
           //and take the car out of park. Car is now "running," expect start
           //permit to change to 0 and expect no other warnings
           #2 sw = 13'b1110011111010;
           //Add passenger. Seatbelt is not fastened. Expect SEAT_WARN, WARN_PRI1,
           //and the chime to be active
           #2 sw = 13'b1110011111110;
           //Passenger fastens seatbelt. Expect all LEDs to be 0.
           #2 sw = 13'b0110011111110;
           //Driver unfastens seatbelt. Expect SEAT_WARN, WARN_PRI1, and chime
           #2 sw = 13'b1110011111110;
           //Driver fastens seatbelt. Expect no warnings
           #2 sw = 13'b1010011111110;
           //Driver door opens. Expect DOOR_WARN, WARN_PRI1, and chime
           #2 sw = 13'b1110011111110;
           //Driver door closes. Expect no warnings
           #2 sw = 13'b1110001111110;
           //Hood no longer closed. Expect HOOD_WARN, WARN_PRI1, and CHIME.
           #2 sw = 13'b1110011111110;
           //Hood okay. Expect no warnings
           #2 sw = 13'b1110010111110;
           //Battery no longer okay. Expect BAT_WARN, WARN_PRI2, but no chime
           #2 sw = 13'b1110011111110;
           //Battery okay. Expect no warnings
           #2 sw = 13'b1110011011110;
           //Airbag not okay. Expect AIRBAG_WARN, WARN_PRI2, but no chime
           #2 sw = 13'b1110011111110;
           //Airbag okay. Expect no warnings
           #2 sw = 13'b1110011101110;
           //Temp not okay. Expect TEMP_WARN, WARN_PRI1, and CHIME
           #2 sw = 13'b1110011111110;
           //Temp okay. Expect no warnings;
           #2 sw = 13'b1110011111100;
           //Trunk open. Expect TRUNK_WARN, WARN_PRI1, and CHIME
           #2 sw = 13'b1110011111110;
           //Trunk closed. Expect no warnings;
           #2 sw = 13'b1110011111111;
           //Parking brake engaged. Expect only WARN_PRI1 and CHIME
           #2 sw = 13'b1110011111110;
           //Parking brake disengaged. Expect no warnings.
           #2 sw = 13'b0010100011001;
           //Put car in park, and trigger every warning except temp. Expect
           //WARN_PRI2, WARN_PRI1, SEAT_WARN, DOOR_WARN, HOOD_WARN, TRUNK_WARN,BAT_WARN, AIRBAG_WARN,
           //but NO CHIME
           #2 sw = 13'b0010100001001;
           //Temp no longer okay, expect all previous signals as well as TEMP_WARN and CHIME
           #2 sw = 13'b0000100001001;
           //Take key out. Expect all warnings to disappear
           #2 sw = 13'b1100011111110;
           //Fix all warnings but keep key out. Still expect no warning LEDs
           #2 sw = 13'b1111111101110;
           //Insert key, put car in park, and push brake, but TEMP is not okay. Expect
           // NO start_permit and expect TEMP WARN, WARN_PRI1, and CHIME
           #2 sw = 13'b1111111111110;
           //Fix temp warning. Expect no warnings and START_PERMIT
           #2 sw = 13'b0010000000001; SRV = 1;
           //Key is in and car is in service mode. Expect START_PERMIT and all warning LEDs
           //but NO CHIME
        end 
        
        initial
            begin
                #56 $finish;
            end
    
endmodule