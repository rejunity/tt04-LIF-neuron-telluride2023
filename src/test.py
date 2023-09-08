import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


@cocotb.test()
async def test_neuron(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut._log.info("reset {shift=0, theta=5, membrane=0}")
    dut.rst_n.value = 0
    dut._log.info("load weights 1111_1101")
    dut.ui_in.value = 0b1111_1101 # load weights
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("calculate")
    dut._log.info("input 0000_0001")
    dut.ui_in.value = 0b0000_0001
    await ClockCycles(dut.clk, 1)
    for i in range(12):
        await ClockCycles(dut.clk, 1)
        # print(dut.tt_um_rejunity_telluride2023_neuron_uut.w.value,
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.w.value,
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.x.value,
        #         int(dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.u_out),
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.is_spike.value,
        #         dut.uo_out.value)
        assert dut.uo_out[0] == [0,0,0,0, 1,0,0,0, 0,1,0,0][i]

    dut.ui_in.value = 0b0000_0011
    dut._log.info("input 0000_0011")
    await ClockCycles(dut.clk, 1)
    for i in range(12):
        await ClockCycles(dut.clk, 1)
        # print(dut.tt_um_rejunity_telluride2023_neuron_uut.w.value,
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.w.value,
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.x.value,
        #         int(dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.u_out),
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.is_spike.value,
        #         dut.uo_out.value)
        assert dut.uo_out[0] == [0,0,0,0, 0,0,0,0, 0,0,0,0][i]

    dut.ui_in.value = 0b0000_0101
    dut._log.info("input 0000_0101")
    await ClockCycles(dut.clk, 1)
    for i in range(12):
        await ClockCycles(dut.clk, 1)
        # print(dut.tt_um_rejunity_telluride2023_neuron_uut.w.value,
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.w.value,
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.x.value,
        #         int(dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.u_out),
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.is_spike.value,
        #         dut.uo_out.value)
        assert dut.uo_out[0] == [1,0,0,1, 0,1,0,0, 1,0,1,0][i]

    dut.ui_in.value = 0b0000_0111
    dut._log.info("input 0000_0111")
    await ClockCycles(dut.clk, 1)
    for i in range(12):
        await ClockCycles(dut.clk, 1)
        # print(dut.tt_um_rejunity_telluride2023_neuron_uut.w.value,
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.w.value,
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.x.value,
        #         int(dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.u_out),
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.is_spike.value,
        #         dut.uo_out.value)
        assert dut.uo_out[0] == [1,0,0,0, 0,1,0,0, 0,0,1,0][i]

    dut.ui_in.value = 0b1000_0111
    dut._log.info("input 1000_0111")
    await ClockCycles(dut.clk, 1)
    for i in range(12):
        await ClockCycles(dut.clk, 1)
        # print(dut.tt_um_rejunity_telluride2023_neuron_uut.w.value,
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.w.value,
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.x.value,
        #         int(dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.u_out),
        #         dut.tt_um_rejunity_telluride2023_neuron_uut.neuron_uut.is_spike.value,
        #         dut.uo_out.value)
        assert dut.uo_out[0] == [0,1,0,1, 0,0,1,0, 1,0,0,1][i]


    # figure out how enable this part only in `ifdef GL_TEST
    if False: # not GL_TEST:
        dut.tt_um_rejunity_telluride2023_neuron_uut.shift.value = 1;
        for i in range(50):
            await ClockCycles(dut.clk, 1)

        dut.tt_um_rejunity_telluride2023_neuron_uut.shift.value = 2;
        for i in range(50):
            await ClockCycles(dut.clk, 1)

        dut.tt_um_rejunity_telluride2023_neuron_uut.shift.value = 3;
        for i in range(50):
            await ClockCycles(dut.clk, 1)

        dut.tt_um_rejunity_telluride2023_neuron_uut.shift.value = 4;
        for i in range(50):
            await ClockCycles(dut.clk, 1)

        dut.tt_um_rejunity_telluride2023_neuron_uut.minus_teta.value = 0b0001;
        dut.tt_um_rejunity_telluride2023_neuron_uut.shift.value = 3;
        for i in range(100):
            await ClockCycles(dut.clk, 1)

