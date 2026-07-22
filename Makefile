RTL_DIR = rtl
TB_DIR  = tb
SIM_DIR = sim

RTL = $(RTL_DIR)/ALU_8bit.v
TB  = $(TB_DIR)/tb_ALU_8bit.v

.PHONY: compile run gui clean wave

compile:
	vlib work
	vlog $(RTL)
	vlog -sv $(TB)

run:
	vsim -c -do $(SIM_DIR)/run.do

gui:
	vsim -do $(SIM_DIR)/run.do

clean:
	@if exist work rmdir /s /q work
	@if exist transcript del /q transcript
	@if exist vsim.wlf del /q vsim.wlf
	@if exist *.vcd del /q *.vcd
	@if exist *.log del /q *.log

wave:
	vsim tb_ALU_8bit
