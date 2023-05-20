#!/bin/bash

while [ "`adb devices | grep -Eoh \"emulator-\d{0,4}\" | wc -l | tr -d ' '`" != "0" ]; do 
    echo "Connected emulators:"
    adb devices | grep -Eoh "emulator-\d{0,4}"

    for emulator in $(adb devices | grep -Eoh "emulator-\d{0,4}")
    do
        echo "Killing the emulator: $emulator"
        adb -s "$emulator" emu kill | true
    done

    sleep 10; 
done
echo "All emus has been killed"
