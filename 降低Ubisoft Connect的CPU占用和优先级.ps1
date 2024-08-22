# 获取系统处理器的总数
$processorCount = [Environment]::ProcessorCount

# 要调整的进程名称列表
$uplayProcessNames = @("upc", "UplayWebCore")

foreach ($processName in $uplayProcessNames) {
    # 获取对应的进程
    $uplayProcesses = Get-Process -Name $processName -ErrorAction SilentlyContinue

    foreach ($process in $uplayProcesses) {
        try {
            # 设置进程优先级为“低”
            $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle

            # 设置进程的处理器关联性为最后一个处理器
            $lastProcessorMask = [System.IntPtr]::new(1 -shl ($processorCount - 1))
            $process.ProcessorAffinity = $lastProcessorMask

            Write-Host "进程 $($process.Name) 的优先级已设置为低，处理器关联性已设置为处理器 $($processorCount)"
        } catch {
            Write-Host "无法修改进程 $($process.Name) 的优先级或处理器关联性: $($_.Exception.Message)"
        }
    }
}

# 脚本结束后暂停，等待用户按下 Enter 键继续
Read-Host -Prompt "脚本执行完毕。按 Enter 键退出"
