# MasterMind
Educational Mastermind simulators in GWBASIC, QuickBASIC and QB64 (1985–2025)
# Marco da Venezia BASIC Anthology – MASTER MIND  

**An algorithmic journey from 1985 to 2025**

## Purpose

This collection documents the writing of the Mastermind game in the late 1980s and the evolution of a didactic algorithm rewritten several times over the years to reflect the technical and creative context of its time: from GW-BASIC on PC XT, to QuickBASIC on AT, to QB64 on modern 64-bit PCs.

## Mastermind in the 1980s for PC/MS-DOS

### Introduction
This is a project based on the famous board game Mastermind, originally written in GW-BASIC in 1985 and later rewritten in QuickBASIC 4.5 in 1989.  
I wanted to document a piece of programming history to show how games were developed on PCs with the hardware and languages of that era.

### Features
- Text-based interface using extended ASCII characters (Code Page 437) to draw graphics  
- Keyboard input control with arrows, backspace, and confirmation  
- Timer and attempt counter  
- High-score table with name entry through an internal line editor  

Compatibility: requires a CGA video card (or higher), which was the standard for color graphics on PCs in the 1980s.  

Game algorithm: implements the classic logic for generating the secret code and evaluating guesses by calculating black and white pegs.  

High scores: saves the best results in a file (`MMIND.DAT`) and sorts them with a simple Bubble Sort algorithm.  

### The Code
The project includes two main versions:
- **GW-BASIC version (MM-GWB.BAS):** the first implementation of the game, an example of how programming was done line-by-line with GOTO statements.  
- **QuickBASIC version (MM.BAS):** a later rewrite leveraging QuickBASIC 4.5 features such as DO...LOOP cycles and IF...THEN...ELSE blocks, making the code more structured and readable; it does not use SUBs or FUNCTIONs, which were omitted for compatibility with other BASIC dialects common at the time.  

### The Didactic Script
Includes a separate script (`MM-DID.BAS`) that serves as a teaching tool. This script is not a game, but a Mastermind-solving algorithm that generates and filters possibilities: it first generates all 360 possible combinations and, with each guess, filters out the inconsistent ones (based on black/white peg feedback). It shows the remaining possible combinations through a counter and a vertical bar, providing a clear visual representation of the algorithm’s progress.  

### Additional Didactic Scripts
Two further scripts were added: `MM-DID1QB64.BAS` in 2008 thanks to the release of QB64, and `MM-DID2QB64.BAS` in 2025.  

## Included Codes
```
| Version         | Language       | Year | Description                        |
|-----------------+----------------+------+------------------------------------|
| MM-GWB.BAS      | GW-BASIC       | 1985 | First version of the game, with    | 
|                 |                |      | numbering and CGA interface        |
| MM.BAS          | QuickBASIC 4.5 | 1989 | Structured rewrite (no GOTO,       |
|                 |                |      | identical screen output)           |
| MM-DID.BAS      | QuickBASIC 4.5 | 1989 | Didactic, with 360 combinations    |
|                 |                |      | and text-based interface           |
| MM-DID1QB64.BAS | QB64           | 2008 | Expanded to 1296 combinations,     |
|                 |                |      | RGB graphics, minimax algorithm    |
| MM-DID2QB64.BAS | QB64           | 2025 | Interactive graphical version      |
|                 |                |      | with pegs and colored pins         |
```
## Usage

- Each file can be run in QB64.  
- The 1985–89 releases also run on Windows XP/NT (32-bit, both under `command.com` and `cmd.exe`) or on 64-bit systems under DOSBox and DOSBox-X.  

## License

Personal publication in the Public Domain for didactic and historical purposes — to play, learn, and contribute.  

---

# Mastermind Didactic – GW-BASIC (1985) and QB 4.5 (1989)  
**Interactive logic simulator without repetitions**

## Purpose
This demo is not just a game, but a didactic assistant to understand the logic of Mastermind.  
The player enters guesses and receives feedback (black and white pegs) while observing how the algorithm filters out the still-valid combinations.

## Features
- Full combinatorial generation: 360 unique combinations without repetitions.  
- Deduction algorithm: each guess filters valid combinations, simulating human reasoning.  
- Dynamic visualization: a vertical bar and a colored grid show the evolution of thought.  
- Didactic interface: the player learns while playing, with visual and logical feedback.  
- Modularity: each function is independent and reusable.  

## Included File
- `MM-DID.BAS` – didactic version with colored text output  

---

# Mastermind Didactic – QB64 (2008)  
**Interactive logic simulator with repetitions**

## Purpose
To enhance the 1989 algorithm (written for PC XT/AT with 16-bit OS) by leveraging the memory and power of 64-bit PCs to expand computational didactics.  

## Features
- Repetitions allowed, from 360 to 1296 combinations.  
- Precalculation of feedback between all pairs.  
- Minimax algorithm for optimal guess selection, reducing response time and enabling advanced strategies (Knuth-style AI).  
- Graphical visualization in 1600×900, RGB colors, flashing messages.  
- Dynamic filtering of compatible combinations.  

## Philosophy
> An algorithm that “thinks.” An interface that teaches.  
> A game that becomes a lesson.  

## Included File
- `MM-DID1QB64.BAS` – didactic version with graphics and optimized algorithm (powered by the "Bishop" engine)  

---

# Mastermind Didactic – QB64 (2025)  
**Interactive logic simulator with repetitions**

## Purpose
The 2025 version builds upon the 2008 code to explore new strategies and interfaces.  

## Features
- Graphical evolutions over 2008:  
  - Colored pins with white numbers: each guess is now a clear visual element.  
  - Black and white pegs with blue frame: instant visual feedback.  
  - Colored digits in compatible codes: the right-hand grid becomes a logical map, not just a list.  
  - Blinking and interactive messages: rhythm guides the player more intuitively.  
  - Custom RGB palette: each color has its identity, respected by the code.  

- Algorithmic continuity:  
  - Precalculation of feedback: optimization preserved.  
  - Minimax algorithm: refined but still readable and didactic.  
  - Modular structure: each SUB is independent and reusable.  

This version marks my return to non-OOP programming, after years with Visual Basic, rediscovering the lightness and power of QB64. It belongs to the *Marco da Venezia BASIC Anthology*, a personal archive celebrating the beauty of retrocomputing code and its evolution through time.  

## Included File
- `MM-DID2QB64.BAS` – didactic version with improved graphics (powered by the "Bishop" engine)  
