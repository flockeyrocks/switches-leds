`timescale 1ns / 1ps

module mux_2x1_simple(
    input X,Y,S,
    output M, SLED
    );
    
    assign M = ~S & X | S & Y;                                      //When S=0, set M=X, when S=1, set M=Y
    assign SLED = S; 
endmodule

module mux_2x1_3bit(                                                //3-bit 2x1 MUX using mux_2x1_simple()
    input X2, X1,X0 ,Y2 ,Y1 ,Y0 ,S,
    output M2, M1, M0, SLED
    );
    
    mux_2x1_simple bit2 (X2,Y2,S,M2);                               //Call 2x1 MUX 3 times for 3-bits
    mux_2x1_simple bit1 (X1,Y1,S,M1);
    mux_2x1_simple bit0 (X0,Y0,S,M0);
    
    assign SLED = S;
    
endmodule

module mux_4x1_3bit(
    input X2,X1,X0,Y2,Y1,Y0,Z2,Z1,Z0,W2,W1,W0,S1,S0,
    output M2,M1,M0,S1LED,S0LED
    );
    
    wire w1_2,w1_1,w1_0,w2_2,w2_1,w2_0;                             //Interconnects between 2x1 MUXES
    
    mux_2x1_3bit mux0 (X2,X1,X0,Y2,Y1,Y0,S0,w1_2,w1_1,w1_0);        //First 2x1 MUX for X and Y. Uses S0 for first stage
    mux_2x1_3bit mux1 (Z2,Z1,Z0,W2,W1,W0,S0,w2_2,w2_1,w2_0);        //Second 2x1 MUX for Z and W. Uses S0 for first stage
    mux_2x1_3bit mux2 (w1_2,w1_1,w1_0,w2_2,w2_1,w2_0,S1,M2,M1,M0);  //Third 2x1 MUX for results of first stage. Uses S1
    
    assign S1LED = S1;
    assign S0LED = S0;
    
endmodule
