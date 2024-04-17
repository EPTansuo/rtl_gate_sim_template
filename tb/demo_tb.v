`timescale 1ns/1ps

module demo_tb();

    //生成波形文件
    initial begin
        $dumpfile("wave.vcd");
        //	$fsdbDumpfile("wave.fsdb");
        $dumpvars(0, demo_tb);
        //$fsdbDumpvars();
    end

    reg clk;
    reg rst;
    reg input_;
    wire output_;

    //生成时钟
    initial begin
        clk = 1'b0;
        #5;
        forever
            #5 clk = ~clk;
    end

    //生成输入测试信号
    initial begin
        forever
            #10 input_ = $random % 2;
    end

    //生成复位信号和设置仿真时长
    initial begin
        rst = 1;  //使能复位
        #50  rst = 0;
        #500 $finish;   //停止仿真
    end

    //实例化待测模块
    demo demo_dut(
             .clk(clk),
             .rst(rst),
             .a(input_),
             .w(output_)
         );

endmodule
