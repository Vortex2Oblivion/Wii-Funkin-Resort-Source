package backend;

import openfl.system.Capabilities;
import sys.io.Process;
import openfl.display.FPS;

/*
    This is hella unfinished, and a HEAVY wip. -- shit was made for Red Fury 2.0, but porting it to here too, lol -Turbo
    Currently only supports Windows
*/


class SpecsState
{
    public static function toString():String
    {
        return 
            "--->|System Specs|<---\n\n" +
            "Operating System (OS): " + Capabilities.os + "\n" +
            "CPU: " + getCPU() + "\n" +
            "Memory (RAM): " + getRAM() + " GB\n" +
            'Memory Usage: ${FPS.memoryInUse} / ${FPS.memoryPeak}\n' +
            "GPU (Graphics Card): " + getGPU() + "\n";
    }

    private static function getCPU():String
    {
        #if windows
        var process:Process = new Process("wmic", ["cpu", "get", "name"]);
        var output:String = process.stdout.readAll().toString();
        process.close();
        return trim(output.split("\n")[1]);
        #end
    }

    private static function getRAM():String
    {
        #if windows
        var process:Process = new Process("wmic", ["MemoryChip", "get", "Capacity"]);
        var output:String = process.stdout.readAll().toString();
        process.close();
        var totalRam:Float = 0;
        for (line in output.split("\n"))
        {
            var trimmed = trim(line);
            if (trimmed != "" && trimmed != "Capacity")
            {
                totalRam += Std.parseFloat(trimmed);
            }
        }
        totalRam = totalRam / (1024 * 1024 * 1024);
        return Std.string(Math.ceil(totalRam));
        #end
    }

    private static function getGPU():String
    {
        #if windows
        var process:Process = new Process("wmic", ["path", "win32_VideoController", "get", "name"]);
        var output:String = process.stdout.readAll().toString();
        process.close();
        return trim(output.split("\n")[1]);
        #end
    }

    private static function trim(s:String):String
    {
        var start = 0;
        var end = s.length;
        
        while (start < end && isWhitespace(s.charAt(start)))
        {
            start++;
        }
        
        while (end > start && isWhitespace(s.charAt(end - 1)))
        {
            end--;
        }
        
        return s.substring(start, end);
    }

    private static inline function isWhitespace(c:String):Bool
    {
        return c == " " || c == "\n" || c == "\r" || c == "\t";
    }
}
