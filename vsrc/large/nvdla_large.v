// ================================================================
// NVDLA Open Source Project
//
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with
// this distribution for more information.
// ================================================================

module nvdla_large
(
    input core_clk,
//    input csb_clk,
    input rstn,
    input csb_rstn,

    output dla_intr,
    // dbb AXI
    output nvdla_core2dbb_aw_awvalid,
    input nvdla_core2dbb_aw_awready,
    output [7:0] nvdla_core2dbb_aw_awid,
    output [3:0] nvdla_core2dbb_aw_awlen,
    output [2:0] nvdla_core2dbb_aw_awsize,
    output [64 -1:0] nvdla_core2dbb_aw_awaddr,
    output nvdla_core2dbb_w_wvalid,
    input nvdla_core2dbb_w_wready,
    output [256 -1:0] nvdla_core2dbb_w_wdata,
    output [256/8-1:0] nvdla_core2dbb_w_wstrb,
    output nvdla_core2dbb_w_wlast,
    output nvdla_core2dbb_ar_arvalid,
    input nvdla_core2dbb_ar_arready,
    output [7:0] nvdla_core2dbb_ar_arid,
    output [3:0] nvdla_core2dbb_ar_arlen,
    output [2:0] nvdla_core2dbb_ar_arsize,
    output [64 -1:0] nvdla_core2dbb_ar_araddr,
    input nvdla_core2dbb_b_bvalid,
    output nvdla_core2dbb_b_bready,
    input [7:0] nvdla_core2dbb_b_bid,
    input nvdla_core2dbb_r_rvalid,
    output nvdla_core2dbb_r_rready,
    input [7:0] nvdla_core2dbb_r_rid,
    input nvdla_core2dbb_r_rlast,
    input [256 -1:0] nvdla_core2dbb_r_rdata,
    // cvsram AXI
    output nvdla_core2cvsram_aw_awvalid,
    input nvdla_core2cvsram_aw_awready,
    output [7:0] nvdla_core2cvsram_aw_awid,
    output [3:0] nvdla_core2cvsram_aw_awlen,
    output [2:0] nvdla_core2cvsram_aw_awsize,
    output [64 -1:0] nvdla_core2cvsram_aw_awaddr,
    output nvdla_core2cvsram_w_wvalid,
    input nvdla_core2cvsram_w_wready,
    output [256 -1:0] nvdla_core2cvsram_w_wdata,
    output [256/8-1:0] nvdla_core2cvsram_w_wstrb,
    output nvdla_core2cvsram_w_wlast,
    input nvdla_core2cvsram_b_bvalid,
    output nvdla_core2cvsram_b_bready,
    input [7:0] nvdla_core2cvsram_b_bid,
    output nvdla_core2cvsram_ar_arvalid,
    input nvdla_core2cvsram_ar_arready,
    output [7:0] nvdla_core2cvsram_ar_arid,
    output [3:0] nvdla_core2cvsram_ar_arlen,
    output [2:0] nvdla_core2cvsram_ar_arsize,
    output [64 -1:0] nvdla_core2cvsram_ar_araddr,
    input nvdla_core2cvsram_r_rvalid,
    output nvdla_core2cvsram_r_rready,
    input [7:0] nvdla_core2cvsram_r_rid,
    input nvdla_core2cvsram_r_rlast,
    input [256 -1:0] nvdla_core2cvsram_r_rdata,
    // cfg APB
    input psel,
    input penable,
    input pwrite,
    input [31:0] paddr,
    input [31:0] pwdata,
    output [31:0] prdata,
    output pready
);

wire        m_csb2nvdla_valid;
wire        m_csb2nvdla_ready;
wire [15:0] m_csb2nvdla_addr;
wire [31:0] m_csb2nvdla_wdat;
wire        m_csb2nvdla_write;
wire        m_csb2nvdla_nposted;
wire        m_nvdla2csb_valid;
wire [31:0] m_nvdla2csb_data;

wire csb_clk;
assign csb_clk = core_clk;

NV_NVDLA_apb2csb apb2csb (
   .pclk                  (csb_clk)
  ,.prstn                 (csb_rstn)
  ,.csb2nvdla_ready       (m_csb2nvdla_ready)
  ,.nvdla2csb_data        (m_nvdla2csb_data)
  ,.nvdla2csb_valid       (m_nvdla2csb_valid)
  ,.paddr                 (paddr)
  ,.penable               (penable)
  ,.psel                  (psel)
  ,.pwdata                (pwdata)
  ,.pwrite                (pwrite)
  ,.csb2nvdla_addr        (m_csb2nvdla_addr)
  ,.csb2nvdla_nposted     (m_csb2nvdla_nposted)
  ,.csb2nvdla_valid       (m_csb2nvdla_valid)
  ,.csb2nvdla_wdat        (m_csb2nvdla_wdat)
  ,.csb2nvdla_write       (m_csb2nvdla_write)
  ,.prdata                (prdata)
  ,.pready                (pready)
);


NV_nvdla nvdla_top (
   .dla_core_clk                    (core_clk)
  ,.dla_csb_clk                     (csb_clk)
  ,.global_clk_ovr_on               (1'b0)
  ,.tmc2slcg_disable_clock_gating   (1'b0)
  ,.dla_reset_rstn                  (rstn)
  ,.direct_reset_                   (1'b1)
  ,.test_mode                       (1'b0)
  ,.csb2nvdla_valid                 (m_csb2nvdla_valid)
  ,.csb2nvdla_ready                 (m_csb2nvdla_ready)
  ,.csb2nvdla_addr                  (m_csb2nvdla_addr)
  ,.csb2nvdla_wdat                  (m_csb2nvdla_wdat)
  ,.csb2nvdla_write                 (m_csb2nvdla_write)
  ,.csb2nvdla_nposted               (m_csb2nvdla_nposted)
  ,.nvdla2csb_valid                 (m_nvdla2csb_valid)
  ,.nvdla2csb_data                  (m_nvdla2csb_data)
  ,.nvdla2csb_wr_complete           () //FIXME: no such port in apb2csb
  ,.nvdla_core2dbb_aw_awvalid       (nvdla_core2dbb_aw_awvalid)
  ,.nvdla_core2dbb_aw_awready       (nvdla_core2dbb_aw_awready)
  ,.nvdla_core2dbb_aw_awaddr        (nvdla_core2dbb_aw_awaddr)
  ,.nvdla_core2dbb_aw_awid          (nvdla_core2dbb_aw_awid)
  ,.nvdla_core2dbb_aw_awlen         (nvdla_core2dbb_aw_awlen)
  ,.nvdla_core2dbb_w_wvalid         (nvdla_core2dbb_w_wvalid)
  ,.nvdla_core2dbb_w_wready         (nvdla_core2dbb_w_wready)
  ,.nvdla_core2dbb_w_wdata          (nvdla_core2dbb_w_wdata)
  ,.nvdla_core2dbb_w_wstrb          (nvdla_core2dbb_w_wstrb)
  ,.nvdla_core2dbb_w_wlast          (nvdla_core2dbb_w_wlast)
  ,.nvdla_core2dbb_b_bvalid         (nvdla_core2dbb_b_bvalid)
  ,.nvdla_core2dbb_b_bready         (nvdla_core2dbb_b_bready)
  ,.nvdla_core2dbb_b_bid            (nvdla_core2dbb_b_bid)
  ,.nvdla_core2dbb_ar_arvalid       (nvdla_core2dbb_ar_arvalid)
  ,.nvdla_core2dbb_ar_arready       (nvdla_core2dbb_ar_arready)
  ,.nvdla_core2dbb_ar_araddr        (nvdla_core2dbb_ar_araddr)
  ,.nvdla_core2dbb_ar_arid          (nvdla_core2dbb_ar_arid)
  ,.nvdla_core2dbb_ar_arlen         (nvdla_core2dbb_ar_arlen)
  ,.nvdla_core2dbb_r_rvalid         (nvdla_core2dbb_r_rvalid)
  ,.nvdla_core2dbb_r_rready         (nvdla_core2dbb_r_rready)
  ,.nvdla_core2dbb_r_rid            (nvdla_core2dbb_r_rid)
  ,.nvdla_core2dbb_r_rlast          (nvdla_core2dbb_r_rlast)
  ,.nvdla_core2dbb_r_rdata          (nvdla_core2dbb_r_rdata)

  ,.nvdla_core2cvsram_aw_awvalid    (nvdla_core2cvsram_aw_awvalid)
  ,.nvdla_core2cvsram_aw_awready    (nvdla_core2cvsram_aw_awready)
  ,.nvdla_core2cvsram_aw_awaddr     (nvdla_core2cvsram_aw_awaddr)
  ,.nvdla_core2cvsram_aw_awid       (nvdla_core2cvsram_aw_awid)
  ,.nvdla_core2cvsram_aw_awlen      (nvdla_core2cvsram_aw_awlen)
  ,.nvdla_core2cvsram_w_wvalid      (nvdla_core2cvsram_w_wvalid)
  ,.nvdla_core2cvsram_w_wready      (nvdla_core2cvsram_w_wready)
  ,.nvdla_core2cvsram_w_wdata       (nvdla_core2cvsram_w_wdata)
  ,.nvdla_core2cvsram_w_wstrb       (nvdla_core2cvsram_w_wstrb)
  ,.nvdla_core2cvsram_w_wlast       (nvdla_core2cvsram_w_wlast)
  ,.nvdla_core2cvsram_b_bvalid      (nvdla_core2cvsram_b_bvalid)
  ,.nvdla_core2cvsram_b_bready      (nvdla_core2cvsram_b_bready)
  ,.nvdla_core2cvsram_b_bid         (nvdla_core2cvsram_b_bid)
  ,.nvdla_core2cvsram_ar_arvalid    (nvdla_core2cvsram_ar_arvalid)
  ,.nvdla_core2cvsram_ar_arready    (nvdla_core2cvsram_ar_arready)
  ,.nvdla_core2cvsram_ar_araddr     (nvdla_core2cvsram_ar_araddr)
  ,.nvdla_core2cvsram_ar_arid       (nvdla_core2cvsram_ar_arid)
  ,.nvdla_core2cvsram_ar_arlen      (nvdla_core2cvsram_ar_arlen)
  ,.nvdla_core2cvsram_r_rvalid      (nvdla_core2cvsram_r_rvalid)
  ,.nvdla_core2cvsram_r_rready      (nvdla_core2cvsram_r_rready)
  ,.nvdla_core2cvsram_r_rid         (nvdla_core2cvsram_r_rid)
  ,.nvdla_core2cvsram_r_rlast       (nvdla_core2cvsram_r_rlast)
  ,.nvdla_core2cvsram_r_rdata       (nvdla_core2cvsram_r_rdata)

  ,.dla_intr                        (dla_intr)
  ,.nvdla_pwrbus_ram_c_pd           (32'b0)
  ,.nvdla_pwrbus_ram_ma_pd          (32'b0)
  ,.nvdla_pwrbus_ram_mb_pd          (32'b0)
  ,.nvdla_pwrbus_ram_p_pd           (32'b0)
  ,.nvdla_pwrbus_ram_o_pd           (32'b0)
  ,.nvdla_pwrbus_ram_a_pd           (32'b0)
); // nvdla_top

assign nvdla_core2dbb_aw_awsize = 3'b101;
assign nvdla_core2dbb_ar_arsize = 3'b101;
assign nvdla_core2cvsram_aw_awsize = 3'b101;
assign nvdla_core2cvsram_ar_arsize = 3'b101;

endmodule
