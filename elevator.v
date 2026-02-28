`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.02.2026 19:53:43
// Design Name: 
// Module Name: elevator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//============================================================
// Elevator Controller using Moore FSM
// Supports 4 floors (0 to 3)
// Door stays open for 3 clock cycles
// State changes on negative edge of clock
// Asynchronous active-high reset
//============================================================

module elevator (

    input wire clk,                 // Clock input
    input wire rst,                 // Asynchronous reset (active high)
    input wire [1:0] floor_req,     // Requested floor (0 to 3)

    output reg move_up,             // High when elevator moves up
    output reg move_down,           // High when elevator moves down
    output reg door_open            // High when door is open
);

//------------------------------------------------------------
// Internal Registers
//------------------------------------------------------------

reg [1:0] current_floor;            // Stores current floor (0–3)
reg [2:0] door_count;               // Counter for door open timing
reg [2:0] state;                    // FSM state register


//------------------------------------------------------------
// State Encoding (5 States)
//------------------------------------------------------------

parameter IDLE        = 3'b000;
parameter MOVING_UP   = 3'b001;
parameter MOVING_DOWN = 3'b010;
parameter OPEN_DOOR   = 3'b011;
parameter CLOSE_DOOR  = 3'b100;


//------------------------------------------------------------
// FSM Sequential Block
//------------------------------------------------------------

always @(negedge clk or posedge rst)
begin

    //--------------------------------------------------------
    // Reset Condition
    //--------------------------------------------------------
    if (rst == 1'b1)
    begin
        state          <= IDLE;
        move_up        <= 1'b0;
        move_down      <= 1'b0;
        door_open      <= 1'b0;
        current_floor  <= 2'b00;
        door_count     <= 3'b000;
    end

    //--------------------------------------------------------
    // Normal Operation
    //--------------------------------------------------------
    else
    begin

        case (state)

        //----------------------------------------------------
        // IDLE STATE
        //----------------------------------------------------
        IDLE:
        begin
            move_up   <= 1'b0;
            move_down <= 1'b0;
            door_open <= 1'b0;
            door_count <= 3'b000;

            if (current_floor < floor_req)
            begin
                state <= MOVING_UP;
            end
            else if (current_floor > floor_req)
            begin
                state <= MOVING_DOWN;
            end
            else
            begin
                state <= OPEN_DOOR;
            end
        end


        //----------------------------------------------------
        // MOVING UP STATE
        //----------------------------------------------------
        MOVING_UP:
        begin
            move_down <= 1'b0;
            door_open <= 1'b0;

            if (current_floor < floor_req)
            begin
                move_up <= 1'b1;
                current_floor <= current_floor + 1'b1;
            end
            else
            begin
                move_up <= 1'b0;
                state   <= OPEN_DOOR;
            end
        end


        //----------------------------------------------------
        // MOVING DOWN STATE
        //----------------------------------------------------
        MOVING_DOWN:
        begin
            move_up   <= 1'b0;
            door_open <= 1'b0;

            if (current_floor > floor_req)
            begin
                move_down <= 1'b1;
                current_floor <= current_floor - 1'b1;
            end
            else
            begin
                move_down <= 1'b0;
                state     <= OPEN_DOOR;
            end
        end


        //----------------------------------------------------
        // OPEN DOOR STATE
        //----------------------------------------------------
        OPEN_DOOR:
        begin
            move_up   <= 1'b0;
            move_down <= 1'b0;
            door_open <= 1'b1;

            if (door_count == 3'd3)
            begin
                door_count <= 3'b000;
                state <= CLOSE_DOOR;
            end
            else
            begin
                door_count <= door_count + 1'b1;
            end
        end


        //----------------------------------------------------
        // CLOSE DOOR STATE
        //----------------------------------------------------
        CLOSE_DOOR:
        begin
            move_up   <= 1'b0;
            move_down <= 1'b0;
            door_open <= 1'b0;
            state <= IDLE;
        end


        //----------------------------------------------------
        // DEFAULT STATE
        //----------------------------------------------------
        default:
        begin
            state <= IDLE;
        end

        endcase

    end

end

endmodule


//============================================================
// Testbench for Elevator Controller
//============================================================

module elevator_tb;

//------------------------------------------------------------
// Testbench Signals
//------------------------------------------------------------

reg clk;
reg rst;
reg [1:0] floor_req;

wire move_up;
wire move_down;
wire door_open;


//------------------------------------------------------------
// Instantiate DUT (Device Under Test)
//------------------------------------------------------------

elevator uut (
    .clk(clk),
    .rst(rst),
    .floor_req(floor_req),
    .move_up(move_up),
    .move_down(move_down),
    .door_open(door_open)
);


//------------------------------------------------------------
// Clock Generation (10 time unit period)
//------------------------------------------------------------

always
begin
    #5 clk = ~clk;
end


//------------------------------------------------------------
// Test Sequence
//------------------------------------------------------------

initial
begin

    clk = 1'b0;
    rst = 1'b1;
    floor_req = 2'b00;

    // Hold reset for 20 time units
    #20;
    rst = 1'b0;

    // Move from floor 0 to floor 2
    #40;
    floor_req = 2'b10;

    // Move from floor 2 to floor 0
    #100;
    floor_req = 2'b00;

    // Move from floor 0 to floor 3
    #100;
    floor_req = 2'b11;

    // Stop simulation
    #200;
    $stop;

end

endmodule
