module wm(clk,rst,coin, lid_r, d_wash, T, soak,rinse, spin, wash,pause,break1,slow_clk,rst1); 
input clk,rst,coin,lid_r,d_wash,T,rst1; 
output reg soak,rinse,spin,wash,pause,break1; 
reg[2:0] cst, nst; // state assignment 
 
    output reg slow_clk;
    
   reg [27:0]count;
	always@(posedge clk)
	begin
	      if(rst1)
			count<=27'b0;
			else
			count<=count+1;
			slow_clk<=count[27];
	end
parameter IDLE = 3'b000, SOAK = 3'b001, WASH=3'b010, RINSE=3'b011, WASH2=3'b100, RINSE2=3'b101, SPIN=3'b110, PAUSH=3'b111; 

always @(cst or coin or d_wash or lid_r or T) 
begin 
case (cst) 
IDLE: 
if(coin==1) 
begin 
nst=SOAK; 
soak=1; 
rinse=0; 
spin=0; 
wash=0; 
pause=0; 
break1=0; 
end 
else 
begin 
nst=cst; 
soak=0; 
rinse=0; 
spin=0; 
wash=0; 
pause=0; 
break1=0; 
end 
SOAK: 
if(T==1) 
begin 
nst=WASH; 
soak=0; 
rinse=0; 
spin=0; 
wash=1; 
pause=0; 
break1=0; 
end 
else 
begin 
nst=cst; 
soak=1; 
rinse=0; 
spin=0; 
wash=0; 
pause=0; 
break1=0; 
end 
WASH: 
if(T==1) 
begin 
nst=RINSE; 
soak=0; 
rinse=1; 
spin=0; 
wash=0; 
pause=0; 
break1=0; 
end 
else 
begin 
nst=cst; 
soak=0; 
rinse=0; 
spin=0; 
wash=1; 
pause=0; 
break1=0; 
end 
RINSE: 
if(T==1 && d_wash==1) 
begin 
nst=WASH2; 
soak=0; 
rinse=0; 
spin=0; 
wash=1; 
pause=0; 
break1=0; 
end 
else 
if(T==1 && d_wash==0) 
begin 
nst=SPIN; 
soak=0; 
rinse=0; 
spin=1; 
wash=0; 
pause=0; 
break1=0; 
end 
else 
begin 
nst=cst; 
soak=0; 
rinse=1; 
spin=0; 
wash=0; 
pause=0; 
break1=0; 
end 
WASH2: 
if(T==1) 
begin 
nst=RINSE2; 
soak=0; 
rinse=1; 
spin=0; 
wash=0; 
pause=0; 
break1=0; 
end 
else 
begin 
nst=cst; 
soak=0; 
rinse=0; 
spin=0; 
wash=1; 
pause=0; 
break1=0; 
end 
RINSE2: 
if(T==1) 
begin 
nst=SPIN; 
soak=0; 
rinse=0; 
spin=1; 
wash=0; 
pause=0; 
break1=0; 
end 
else 
begin 
nst=cst; 
soak=0; 
rinse=0; 
spin=0; 
wash=0; 
pause=1;
break1=0; 
end 
SPIN: 
if(T==0 && lid_r==1) 
begin 
nst=PAUSH; 
soak=0; 
rinse=0; 
spin=0; 
wash=0; 
pause=1; 
break1=0; 
end 
else 
if(T==1) 
begin 
nst=IDLE; 
soak=0; 
rinse=0; 
spin=0; 
wash=0; 
pause=1; 
break1=0; 
end 
else 
begin 
nst=cst; 
soak=0; 
rinse=0; 
spin=1; 
wash=0; 
pause=0; 
break1=0; 
end 
PAUSH: 
if(lid_r==0) 
begin 
nst=SPIN; 
soak=0; 
rinse=0; 
spin=1; 
wash=0; 
pause=0; 
break1=0; 
end 
else 
begin 
nst=cst; 
soak=0; 
rinse=0; 
spin=0; 
wash=0; 
pause=1; 
break1=0; 
end 
default: 
nst=IDLE;
endcase 
end 

always @(posedge slow_clk or negedge rst) 
begin 
if (rst==0) 
cst <= IDLE; 
else 
cst <= nst; 
end   

endmodule
