/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : U-2022.12-SP7
// Date      : Mon Mar 16 20:39:18 2026
/////////////////////////////////////////////////////////////


module sram_wrapper ( clk, wr_en, rd_en, waddr, raddr, wdata, rdata ,VDD,VSS);
inout VDD, VSS;
  input [8:0] waddr;
  input [8:0] raddr;
  input [63:0] wdata;
  output [63:0] rdata;
  input clk, wr_en, rd_en;
  wire   n_Logic1_, n_Logic0_, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11,
         n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25,
         n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39,
         n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53,
         n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67,
         n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83;
  wire   [8:0] sram_addr_delayed;

  sram00 sram00_inst ( .Q(rdata), .A({n5, n6, n7, n8, n9, n10, n11, n12, n13}), 
        .D({n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, 
        n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, 
        n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, 
        n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, 
        n69, n70, n71, n72, n73, n74, n75, n76, n77}), .EMA({n_Logic0_, 
        n_Logic1_, n_Logic0_}), .CLK(clk), .CEN(n4), .WEN(n1), .RETN(n_Logic1_) , .VDD(VDD), .VSS(VSS) );
  DEL0 U15 ( .I(n3), .Z(n4) , .VDD(VDD), .VSS(VSS) );
  NR2XD0 U16 ( .A1(n81), .A2(rd_en), .ZN(n3) , .VDD(VDD), .VSS(VSS) );
  DEL02 U17 ( .I(wr_en), .Z(n83) , .VDD(VDD), .VSS(VSS) );
  DEL0 U18 ( .I(sram_addr_delayed[8]), .Z(n5) , .VDD(VDD), .VSS(VSS) );
  AO22D4 U19 ( .A1(raddr[8]), .A2(n80), .B1(waddr[8]), .B2(n81), .Z(
        sram_addr_delayed[8]) , .VDD(VDD), .VSS(VSS) );
  DEL0 U20 ( .I(sram_addr_delayed[7]), .Z(n6) , .VDD(VDD), .VSS(VSS) );
  AO22D4 U21 ( .A1(waddr[7]), .A2(n82), .B1(raddr[7]), .B2(n80), .Z(
        sram_addr_delayed[7]) , .VDD(VDD), .VSS(VSS) );
  DEL0 U22 ( .I(sram_addr_delayed[6]), .Z(n7) , .VDD(VDD), .VSS(VSS) );
  AO22D4 U23 ( .A1(waddr[6]), .A2(n83), .B1(raddr[6]), .B2(n78), .Z(
        sram_addr_delayed[6]) , .VDD(VDD), .VSS(VSS) );
  DEL0 U24 ( .I(sram_addr_delayed[5]), .Z(n8) , .VDD(VDD), .VSS(VSS) );
  AO22D4 U25 ( .A1(waddr[5]), .A2(n81), .B1(raddr[5]), .B2(n79), .Z(
        sram_addr_delayed[5]) , .VDD(VDD), .VSS(VSS) );
  DEL0 U26 ( .I(sram_addr_delayed[4]), .Z(n9) , .VDD(VDD), .VSS(VSS) );
  AO22D4 U27 ( .A1(waddr[4]), .A2(n82), .B1(raddr[4]), .B2(n80), .Z(
        sram_addr_delayed[4]) , .VDD(VDD), .VSS(VSS) );
  DEL0 U28 ( .I(sram_addr_delayed[3]), .Z(n10) , .VDD(VDD), .VSS(VSS) );
  AO22D4 U29 ( .A1(waddr[3]), .A2(n83), .B1(raddr[3]), .B2(n78), .Z(
        sram_addr_delayed[3]) , .VDD(VDD), .VSS(VSS) );
  DEL0 U30 ( .I(sram_addr_delayed[2]), .Z(n11) , .VDD(VDD), .VSS(VSS) );
  AO22D4 U31 ( .A1(waddr[2]), .A2(n81), .B1(raddr[2]), .B2(n79), .Z(
        sram_addr_delayed[2]) , .VDD(VDD), .VSS(VSS) );
  DEL0 U32 ( .I(sram_addr_delayed[1]), .Z(n12) , .VDD(VDD), .VSS(VSS) );
  AO22D4 U33 ( .A1(waddr[1]), .A2(n82), .B1(raddr[1]), .B2(n79), .Z(
        sram_addr_delayed[1]) , .VDD(VDD), .VSS(VSS) );
  DEL0 U34 ( .I(sram_addr_delayed[0]), .Z(n13) , .VDD(VDD), .VSS(VSS) );
  AO22D4 U35 ( .A1(waddr[0]), .A2(n83), .B1(raddr[0]), .B2(n78), .Z(
        sram_addr_delayed[0]) , .VDD(VDD), .VSS(VSS) );
  DEL0 U36 ( .I(wdata[63]), .Z(n14) , .VDD(VDD), .VSS(VSS) );
  DEL0 U37 ( .I(wdata[62]), .Z(n15) , .VDD(VDD), .VSS(VSS) );
  DEL0 U38 ( .I(wdata[61]), .Z(n16) , .VDD(VDD), .VSS(VSS) );
  DEL0 U39 ( .I(wdata[60]), .Z(n17) , .VDD(VDD), .VSS(VSS) );
  DEL0 U40 ( .I(wdata[59]), .Z(n18) , .VDD(VDD), .VSS(VSS) );
  DEL0 U41 ( .I(wdata[58]), .Z(n19) , .VDD(VDD), .VSS(VSS) );
  DEL0 U42 ( .I(wdata[57]), .Z(n20) , .VDD(VDD), .VSS(VSS) );
  DEL0 U43 ( .I(wdata[56]), .Z(n21) , .VDD(VDD), .VSS(VSS) );
  DEL0 U44 ( .I(wdata[55]), .Z(n22) , .VDD(VDD), .VSS(VSS) );
  DEL0 U45 ( .I(wdata[54]), .Z(n23) , .VDD(VDD), .VSS(VSS) );
  DEL0 U46 ( .I(wdata[53]), .Z(n24) , .VDD(VDD), .VSS(VSS) );
  DEL0 U47 ( .I(wdata[52]), .Z(n25) , .VDD(VDD), .VSS(VSS) );
  DEL0 U48 ( .I(wdata[51]), .Z(n26) , .VDD(VDD), .VSS(VSS) );
  DEL0 U49 ( .I(wdata[50]), .Z(n27) , .VDD(VDD), .VSS(VSS) );
  DEL0 U50 ( .I(wdata[49]), .Z(n28) , .VDD(VDD), .VSS(VSS) );
  DEL0 U51 ( .I(wdata[48]), .Z(n29) , .VDD(VDD), .VSS(VSS) );
  DEL0 U52 ( .I(wdata[47]), .Z(n30) , .VDD(VDD), .VSS(VSS) );
  DEL0 U53 ( .I(wdata[46]), .Z(n31) , .VDD(VDD), .VSS(VSS) );
  DEL0 U54 ( .I(wdata[45]), .Z(n32) , .VDD(VDD), .VSS(VSS) );
  DEL0 U55 ( .I(wdata[44]), .Z(n33) , .VDD(VDD), .VSS(VSS) );
  DEL0 U56 ( .I(wdata[43]), .Z(n34) , .VDD(VDD), .VSS(VSS) );
  DEL0 U57 ( .I(wdata[42]), .Z(n35) , .VDD(VDD), .VSS(VSS) );
  DEL0 U58 ( .I(wdata[41]), .Z(n36) , .VDD(VDD), .VSS(VSS) );
  DEL0 U59 ( .I(wdata[40]), .Z(n37) , .VDD(VDD), .VSS(VSS) );
  DEL0 U60 ( .I(wdata[39]), .Z(n38) , .VDD(VDD), .VSS(VSS) );
  DEL0 U61 ( .I(wdata[38]), .Z(n39) , .VDD(VDD), .VSS(VSS) );
  DEL0 U62 ( .I(wdata[37]), .Z(n40) , .VDD(VDD), .VSS(VSS) );
  DEL0 U63 ( .I(wdata[36]), .Z(n41) , .VDD(VDD), .VSS(VSS) );
  DEL0 U64 ( .I(wdata[35]), .Z(n42) , .VDD(VDD), .VSS(VSS) );
  DEL0 U65 ( .I(wdata[34]), .Z(n43) , .VDD(VDD), .VSS(VSS) );
  DEL0 U66 ( .I(wdata[33]), .Z(n44) , .VDD(VDD), .VSS(VSS) );
  DEL0 U67 ( .I(wdata[32]), .Z(n45) , .VDD(VDD), .VSS(VSS) );
  DEL0 U68 ( .I(wdata[31]), .Z(n46) , .VDD(VDD), .VSS(VSS) );
  DEL0 U69 ( .I(wdata[30]), .Z(n47) , .VDD(VDD), .VSS(VSS) );
  DEL0 U70 ( .I(wdata[29]), .Z(n48) , .VDD(VDD), .VSS(VSS) );
  DEL0 U71 ( .I(wdata[28]), .Z(n49) , .VDD(VDD), .VSS(VSS) );
  DEL0 U72 ( .I(wdata[27]), .Z(n50) , .VDD(VDD), .VSS(VSS) );
  DEL0 U73 ( .I(wdata[26]), .Z(n51) , .VDD(VDD), .VSS(VSS) );
  DEL0 U74 ( .I(wdata[25]), .Z(n52) , .VDD(VDD), .VSS(VSS) );
  DEL0 U75 ( .I(wdata[24]), .Z(n53) , .VDD(VDD), .VSS(VSS) );
  DEL0 U76 ( .I(wdata[23]), .Z(n54) , .VDD(VDD), .VSS(VSS) );
  DEL0 U77 ( .I(wdata[22]), .Z(n55) , .VDD(VDD), .VSS(VSS) );
  DEL0 U78 ( .I(wdata[21]), .Z(n56) , .VDD(VDD), .VSS(VSS) );
  DEL0 U79 ( .I(wdata[20]), .Z(n57) , .VDD(VDD), .VSS(VSS) );
  DEL0 U80 ( .I(wdata[19]), .Z(n58) , .VDD(VDD), .VSS(VSS) );
  DEL0 U81 ( .I(wdata[18]), .Z(n59) , .VDD(VDD), .VSS(VSS) );
  DEL0 U82 ( .I(wdata[17]), .Z(n60) , .VDD(VDD), .VSS(VSS) );
  DEL0 U83 ( .I(wdata[16]), .Z(n61) , .VDD(VDD), .VSS(VSS) );
  DEL0 U84 ( .I(wdata[15]), .Z(n62) , .VDD(VDD), .VSS(VSS) );
  DEL0 U85 ( .I(wdata[14]), .Z(n63) , .VDD(VDD), .VSS(VSS) );
  DEL0 U86 ( .I(wdata[13]), .Z(n64) , .VDD(VDD), .VSS(VSS) );
  DEL0 U87 ( .I(wdata[12]), .Z(n65) , .VDD(VDD), .VSS(VSS) );
  DEL0 U88 ( .I(wdata[11]), .Z(n66) , .VDD(VDD), .VSS(VSS) );
  DEL0 U89 ( .I(wdata[10]), .Z(n67) , .VDD(VDD), .VSS(VSS) );
  DEL0 U90 ( .I(wdata[9]), .Z(n68) , .VDD(VDD), .VSS(VSS) );
  DEL0 U91 ( .I(wdata[8]), .Z(n69) , .VDD(VDD), .VSS(VSS) );
  DEL0 U92 ( .I(wdata[7]), .Z(n70) , .VDD(VDD), .VSS(VSS) );
  DEL0 U93 ( .I(wdata[6]), .Z(n71) , .VDD(VDD), .VSS(VSS) );
  DEL0 U94 ( .I(wdata[5]), .Z(n72) , .VDD(VDD), .VSS(VSS) );
  DEL0 U95 ( .I(wdata[4]), .Z(n73) , .VDD(VDD), .VSS(VSS) );
  DEL0 U96 ( .I(wdata[3]), .Z(n74) , .VDD(VDD), .VSS(VSS) );
  DEL0 U97 ( .I(wdata[2]), .Z(n75) , .VDD(VDD), .VSS(VSS) );
  DEL0 U98 ( .I(wdata[1]), .Z(n76) , .VDD(VDD), .VSS(VSS) );
  DEL0 U99 ( .I(wdata[0]), .Z(n77) , .VDD(VDD), .VSS(VSS) );
  ND2D1 U100 ( .A1(rd_en), .A2(n1), .ZN(n2) , .VDD(VDD), .VSS(VSS) );
  INVD1 U101 ( .I(n2), .ZN(n78) , .VDD(VDD), .VSS(VSS) );
  INVD1 U102 ( .I(n2), .ZN(n79) , .VDD(VDD), .VSS(VSS) );
  INVD1 U103 ( .I(n2), .ZN(n80) , .VDD(VDD), .VSS(VSS) );
  CKBD1 U104 ( .I(wr_en), .Z(n81) , .VDD(VDD), .VSS(VSS) );
  CKBD1 U105 ( .I(wr_en), .Z(n82) , .VDD(VDD), .VSS(VSS) );
  INVD1 U106 ( .I(n83), .ZN(n1) , .VDD(VDD), .VSS(VSS) );
  TIEH U107 ( .Z(n_Logic1_) , .VDD(VDD), .VSS(VSS) );
  TIEL U108 ( .ZN(n_Logic0_) , .VDD(VDD), .VSS(VSS) );
endmodule

