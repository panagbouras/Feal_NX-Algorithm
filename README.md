# Feal_NX-Algorithm
This VHDL project focuses on implementing the FEAL-NX algorithm which is a 64-bit block cipher. The algorithm enciphers 64-bit plaintexts into 64-bit ciphertexts and vice versa, using a 128-bit key. Further details about the algorithm can be found in this [link](https://info.isl.ntt.co.jp/crypt/eng/archive/dl/feal/call-3e.pdf). Python code from repository [Donaldduck8/FEAL-NX-Python-Implementation](https://github.com/Donaldduck8/FEAL-NX-Python-Implementation) is utilized for testing and validating the VHDL implementation. The primary goal of this project is to deliver an efficient hardware-design for the FEAL-NX encryption algorithm.

## Top Level Design
The FEAL-NX circuit has four major components:
* Controller (Finite State Machine)
* Register File
* Key Scheduler
* Encryption/Decryption circuit (Crypto)

The full circuit is presented in the image below. The input and output signals are:
* Synchronus reset (synch_rst) and clock (clk).
* Input of 32-bit (in).
* New input signal (new_in-1bit). If the signal is high a new input is available, otherwise it isn’t.
* Number of cipher/decipher rounds (N-4bits). The number of rounds is given by the equation Rounds=32+2*N.
* Mode signal (mode-1bit). If the signal is high dechipher algorithm is applied, otherwise cipher.
* Acknowledge Signal (ack-1bit).If the signal is high the circuit is reading the input, otherwise not.
* Activate output (act_out-1bit). If the signal is high the output data is valid, otherwise not.
* The output of the circuit (out64-64bits).

![FEAL_NX_schematic](https://github.com/user-attachments/assets/14344182-7917-4ba5-a8ca-4ac80d29035d)

## Key Scheduler
The Key Schedule circuit has an input of 128-bit key and produces the extended keys K<sub>i</sub> (i=0,1,...,N+7) where N denotes the number of rounds. By employing the Folding technique, the hardware requirements are significantly minimized. The circuit, based on algorithm's key schedule,  is shown in the following image. The control signal is used to initialize the circuit through the multiplexers. The Key generation happens once, and the keys are progressively fed into the circuit for processing.

![Key_Schedule_schematic](https://github.com/user-attachments/assets/abf5f0ee-1749-4981-afe1-79ececd8e64e)

## Register File
The Register File has 70 slots of 16-bit each, in order to store all the extended keys. It supports two operational modes based on the process: encryption and decryption. In encryption mode, the Register File operates as a Last-In-First-Out (LIFO) structure, while in decryption mode, it functions as a First-In-First-Out (FIFO) structure. The schematic of the circuit is presented in the image below.

![Register_file_schematic](https://github.com/user-attachments/assets/c09d7102-95f6-4550-99f0-1dea37e09b58)

## Encryption/Decryption circuit (Crypto)
The three computational stages of the algorithm for ciphering/deciphering will be jointly implemented in a single circuit. The implementation logic, similar to the Key Schedule circuit, follows the folding technique. The purpose of this approach is to minimize the required hardware. The control signal, is used by the multiplexers to initialize the circuit (similarly with Key Scheduler).

![crypto_schematic](https://github.com/user-attachments/assets/b5045982-fb09-4cb5-bb00-2bc57e78d9f8)

To enhance performance, we will use the replication technique. Multiple parallel units will operate simultaneously, with a total of 8 units. The loading of the registers will take place in parallel with data processing to save time. Each output will be controlled by an 8-to-1 multiplexer, which is managed by our main FSM (Finite State Machine).

![crypto_circuit_schematic](https://github.com/user-attachments/assets/47cca339-5eef-4597-a2be-eeb11ccffad6)

## Controller (FSM)
The Finite State Machine controls most of the inner signals, as well as the input registers and the output signals ack and act_out. It has 11 states:
| State  | Counter | Function |
| ------------- | ------------- | ------------- |
| A  | 0  | Load 32-bit of the key and 4-bit N  |
| B  | 0 to 2  | Load 32-bit if the key  |
| C  | 0  | Initialize Key Scheduler  |
| D  | 0 to 15  | Extended keys output and load 4-bits of each plaintext  |
| E  | 0 to 2+N  | Extended keys output  |
| F  | 0  | Initialize Register File  |
| G  | 0  | Initialize Crypto Circuit  |
| H  | 0 to 13+2N  | Crypto Circuit working  |
| I  | 0 to 15  | Crypto Circuit working and if new input load the input registers  |
| J  | 0  | Last round of Crypto Circuit working and set ack to zero if necessary  |
| K  | 0 to 7  | Output (Can be overlaid)  |

The sequence of states is A &rarr; B &rarr; C &rarr; ... &rarr; K and then from K &rarr; G to process new plaintexts. In case we want a new key, we can go to A state again only by raising the synch_rst signal.

## Analysis
* Latency (L): The first output is after 57 + 3*N + 8 (Can be overlaid) cycles.
* Throughtput (Θ): The throughtput is 8 ouputs per 32 + 8 (Can be overlaid) cycles.

















