@echo off
for %%l in (
    "This is my"
    "multi-line here document"
    "that this batch file"
    "will print!"
    ) do echo.%%~l >> here.txt