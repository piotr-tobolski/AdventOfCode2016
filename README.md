# AdventOfCode2016

This repository contains solutions for every puzzle from AdventOfCode 2016.
All of them are written in Swift (Day 5 has also ultra fast and unsafe C implementation).
All of them are written in playgrounds except for Day 5 and 11, which are command line tools.
Some of them need long time to execute.

Playgrounds sounded like a fun way to write them.
At first I wanted to write everything in single playground but after couple of days compilation times became painful.
I eventually splitted them into separate playgrounds but this still isn't perfect.
Most of the time I was fighting with vague compiler errors ("you can't use "<" with two Ints because figure out why"), crashes and freezes.
I learned not to print too much data in playground console, Xcode 8.2 hates this.

Swift is not the best tool for work like this.
Playgrounds are slow.
Really slow.
I mean like several orders of magnitude slower than "normal" code.
If you use Soures folder it is faster but it is still very slow.
Swift code compilation and indexing is also slow.
Playgrounds are not flexible, command line tools can't easily use frameworks, creating Mac app is an overkill.
Standard library doesn't have some required data structures, external dependencies are often missing or slow.
Swift is not good scripting language, at least for now.

Those solutions are neither beautiful nor fast but are a compromise between performance, readability, my skills and avaialble time.

If you want to run them, remember to execute the `install.sh` first.
