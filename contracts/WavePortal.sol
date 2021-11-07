// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;
    mapping(address => uint256) addressToWaves;
    mapping(address => uint256) public lastWavedAt;

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    Wave[] waves;
    event NewWave(address indexed from, uint256 timestamp, string message);

    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 15m"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        addressToWaves[msg.sender] += 1;
        waves.push(Wave(msg.sender, _message, block.timestamp));

        /*
         * Generate a Psuedo random number between 0 and 100
         */
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);

        /*
         * Set the generated, random number as the seed for the next wave
         */
        seed = randomNumber;

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (randomNumber < 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }
    
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have had %s total waves!", totalWaves);
        return totalWaves;
    }
    
    function userWaveCount() public view returns (uint256) {
        console.log("User %s has waved %s times", msg.sender, addressToWaves[msg.sender]);
        return addressToWaves[msg.sender];
    }
}