module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    
	wire enam,enah;
    
    assign enam = (ss[3:0] == 9 && ss[7:4] == 5) ? 1: 0;
    assign enah = ((mm == 16'h59)&&(ss == 16'h59))? 1: 0;
    
    
    cnt60 cnts (clk,reset,ena,ss) ; 
    cnt60 cntm (clk,reset,enam,mm) ;
    cnt12 cnth (clk,reset,enah,pm,hh);
    

endmodule


module cnt60 (    
    input clk,
    input reset,
    input ena,
    output [7:0] out); 
    
    wire ena2 ; 
    assign ena2 = (out[3:0] == 9 && ena==1) ? 1 : 0;
        
    always @ (posedge clk)
        begin
            if (reset == 1 || (ena == 1 && out[3:0] == 9)  )
                out[3:0] <= 0 ;
            else if(ena == 1 && out[3:0] < 9)
                out[3:0] <= out[3:0] + 1 ;
        end
    
    always @ (posedge clk)
        begin
            if (reset == 1 || (ena2 == 1 && out == 16'h59 )  )
                out[7:4] <= 0 ;
            else if(ena2 == 1 && out[7:4] < 5)
                out[7:4] <= out[7:4] + 1 ;     
        end
    
endmodule
    
    
module cnt12 (    
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] out); 
    
    
    always @ (posedge clk)
        begin
            if (reset == 1)
                begin
                out[3:0] <= 2 ; out[7:4] <= 1 ;	pm <= 0;
                end
            else if(ena == 1 && out < 9 )
                out[3:0] <= out[3:0] + 1 ;  
            else if(ena == 1 && out == 9)
                out <= 16'h10 ;
            else if(ena == 1 && out == 16'h10)
                out <= 16'h11 ;
            else if(ena == 1 && out == 16'h11)
                begin
                out <= 16'h12 ;
                pm <= ~pm;
                end    
            else if(ena == 1 && out == 16'h12)
                begin
                out <= 16'h1 ;
                end   
        end
   
       
endmodule
