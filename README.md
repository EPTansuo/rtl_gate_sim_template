# VCS+Verdi 工程模板

## 使用方法

`tb/` 存放`testbench`文件，`vsrc/`存放`Verilog`代码。若想修改默认的工程目录结构，请修改`Makefile`文件。

## 使用到的插件

1. Digital-IDE
2. RemoteSSH
3. Makefile
4. Wavetrace

## 使用方法

在Makefile插件中配置构建Build target为`sim`,即可实现分析编译+仿真，然后可使用Wavetrace查看波形。