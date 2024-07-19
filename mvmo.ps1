# Define the necessary P/Invoke for moving the mouse cursor and simulating key presses
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class NativeMethods {
    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void mouse_event(uint dwFlags, int dx, int dy, uint dwData, UIntPtr dwExtraInfo);

    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);

    public const int MOUSEEVENTF_MOVE = 0x0001;
    public const int KEYEVENTF_KEYUP = 0x0002;
}
"@

function SimulateKeyPress {
    $VK_RIGHT = 0x27 # Virtual Key code for the Right Arrow key
    [NativeMethods]::keybd_event($VK_RIGHT, 0, 0, [UIntPtr]::Zero) # Press right arrow key
    Start-Sleep -Milliseconds 100
    [NativeMethods]::keybd_event($VK_RIGHT, 0, [NativeMethods]::KEYEVENTF_KEYUP, [UIntPtr]::Zero) # Release right arrow key
}

while ($true) {
    # Generate random relative movement values for X and Y coordinates
    $RandomX = Get-Random -Minimum -50 -Maximum 50  # Random movement between -50 and 50 pixels
    $RandomY = Get-Random -Minimum -50 -Maximum 50  # Random movement between -50 and 50 pixels

    # Move the mouse cursor by the random offset
    [NativeMethods]::mouse_event([NativeMethods]::MOUSEEVENTF_MOVE, $RandomX, $RandomY, 0, [UIntPtr]::Zero)

    # Simulate a key press to prevent screen lock
    SimulateKeyPress

    # Pause for a while before the next iteration (e.g., 60 seconds)
    Start-Sleep -Seconds 5
}
